"""
run_seir_model(
    wth::DataFrame,
    emergence::String,
    onset::Int64,
    duration::Int64,
    rhlim::Int64,
    rainlim::Int64,
    H0::Int64,
    I0::Int64,
    RcA::Matrix{Float64},
    RcT::Matrix{Float64},
    RcOpt::Float64,
    p::Int64,
    i::Int64,
    Sx::Int64,
    a::Float64,
    RRS::Float64,
    RRG::Float64)

Runs a Susceptible-Exposed-Infectious-Removed (SEIR) model using weather data and
optimal curve values for respective crop diseases. 


# Arguments
- - `wth`::DataFrame`: a data frame of weather on a daily time-step 
- `val::T`: the value to search for

# Keywords
- `verbose::Bool=true`: print out progress details

# Returns
- A `DataFrame` with the model's output.
"""

function run_seir_model(;
    wth::DataFrame,
    emergence::Date,
    onset,
    duration,
    rhlim,
    rainlim,
    H0,
    I0,
    RcA,
    RcT,
    RcOpt,
    p,
    i,
    Sx,
    a,
    RRS,
    RRG,
)

    emergence_day = Dates.Date.(emergence, Dates.DateFormat("yyyy-mm-dd"))
    final_day = emergence_day + Dates.Day(duration - 1)
    season = Base.collect(emergence_day:Dates.Day(1):final_day)

    # Convert emergence date into Julian date, sequential day in year.
    emergence_doy = Dates.dayofyear(emergence_day)

    if !(emergence_day >= wth[1, "YYYYMMDD"] || 
        final_day > Base.findmax(wth[:, "YYYYMMDD"])[1])
        error("incomplete weather data or dates do not align")
    end

    if (H0 < 0)
        Base.error("H0 cannot be < 0, check your initial number of healthy sites")
    end

    if (I0 < 0)
        Base.error("I0 cannot be < 0, check your initial number of infective sites")
    end

    season_wth = wth[Base.in(season - Dates.Day(1)).(wth.YYYYMMDD), :]

    # Create `infday` for use in for loop below.
    infday = 0

    # Create vectors of preallocated output variables.
    cofr = Base.zeros(duration)
    rc = Base.zeros(duration)
    RHCoef = Base.zeros(duration)
    latency = Base.zeros(duration)
    infectious = Base.zeros(duration)
    intensity = Base.zeros(duration)
    rsenesced = Base.zeros(duration)
    rgrowth = Base.zeros(duration)
    rtransfer = Base.zeros(duration)
    infection = Base.zeros(duration)
    diseased = Base.zeros(duration)
    senesced = Base.zeros(duration)
    removed = Base.zeros(duration)
    now_infectious = Base.zeros(duration)
    now_latent = Base.zeros(duration)
    sites = Base.zeros(duration)
    total_sites = Base.zeros(duration)
    Rc_age = _fn_rc(RcA, 1:duration)
    Rc_temp = _fn_rc(RcT, wth[!, :TEMP])

    for d in 1:duration
        d_1 = d - 1

        # Start of the state calculations.
        if d == 1
            # Start crop growth.
            sites[d] = H0
            rsenesced[d] = RRS * sites[d]
        else
            if d > i
                removed_today = infectious[infday+1]
            else
                removed_today = 0
            end

            sites[d] = sites[d_1] + rgrowth[d_1] - infection[d_1] - rsenesced[d_1]
            rsenesced[d] = removed_today + RRS * sites[d]
            senesced[d] = senesced[d_1] + rsenesced[d_1]

            latency[d] = infection[d_1]
            latday = d - p
            latday = Base.max(1, latday)
            now_latent[d] = Base.sum(latency[latday:d])

            infectious[d] = rtransfer[d_1]
            infday = d - i
            infday = Base.max(1, infday)
            now_infectious[d] = Base.sum(infectious[infday:d])
        end

        if (wth[!, :RHUM][d] >= rhlim || wth[!, :RAIN][d] >= rainlim)
            RHCoef[d] = 1
        end

        rc[d] = RcOpt * (Rc_age[d] * Rc_temp[d] * RHCoef[d])
        diseased[d] = sum(infectious) + now_latent[d] + removed[d]
        removed[d] = sum(infectious) - now_infectious[d]

        cofr[d] = 1 - (diseased[d] / (sites[d] + diseased[d]))

        # Initialise disease.   
        if d == onset
            infection[d] = I0
        elseif d > onset
            infection[d] = now_infectious[d] * rc[d] * (cofr[d]^a)
        else
            infection[d] = 0
        end

        if d >= p
            rtransfer[d] = latency[latday]
        else
            rtransfer[d] = 0
        end

        total_sites[d] = diseased[d] + sites[d]
        rgrowth[d] = RRG * sites[d] * (1 - (total_sites[d] / Sx))
        intensity[d] = (diseased[d] - removed[d]) / (total_sites[d] - removed[d])
    end

    res = DataFrames.DataFrame(
        simday = 1:duration,
        dates = season,
        sites = sites,
        latent = now_latent,
        infectious = now_infectious,
        removed = removed,
        senseced = senesced,
        rateinf = infection,
        rtransfer = rtransfer,
        rgrowth = rgrowth,
        rsenesced = rsenesced,
        diseased = diseased,
        intensity = intensity,
        lat = wth[1, "LAT"],
        lon = wth[1, "LON"],
    )

    return res
end

function _fn_rc(Rc, x)
    itp = Interpolations.LinearInterpolation(Rc[:, 1], Rc[:, 2], extrapolation_bc = 0)
    x = itp.(x)
    return x
end
