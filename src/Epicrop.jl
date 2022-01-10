module Epicrop

using DataFrames, Dates, Interpolations

include("helpers.jl")

export hlipmodel
export bacterialblight
export brownspot
export leafblast
export sheathblight
export tungro

#re-exports from DataFrames.jl
export DataFrame

"""
hlipmodel(
    wth,
    emergence,
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
    RRG)

Runs a healthy-latent-infectious-postinfectious (HLIP) model using weather data and optimal curve values for respective crop diseases.

# Keywords
- `wth` a data frame of weather on a daily time-step containing data with the following field names.
    | Field | value |
    |-------|-------------|
    |YYYYMMDD | Date as Year Month Day, YYYY-MM-DD, (ISO8601) |
    |DOY |  Consecutive day of year, commonly called "Julian date" |
    |TEMP | Mean daily temperature (°C) |
    |RHUM | Mean daily relative humidity (%) |
    |RAIN | Mean daily rainfall (mm) |
- `emergence`: expected date of plant emergence entered as a `Dates.Date` object. From Table 1 Savary _et al._ 2012.
- `onset` expected number of days until the onset of disease after emergence date. From Table 1 Savary _et al._ 2012.
- `duration`: simulation duration (growing season length). From Table 1 Savary _et al._ 2012.
- `rhlim`: threshold to decide whether leaves are wet or not (usually 90%). From Table 1 Savary _et al._ 2012.
- `rainlim`: threshold to decide whether leaves are wet or not. From Table 1 Savary _et al._ 2012.
- `H0`: initial number of plant's healthy sites. From Table 1 Savary _et al._ 2012.
- `I0`: initial number of infective sites. From Table 1 Savary _et al._ 2012.
- `RcA`: crop age modifier for *Rc* (the basic infection rate corrected for removals). From Table 1 Savary _et al._ 2012.
- `RcT`: temperature modifier for *Rc* (the basic infection rate corrected for removals). From Table 1 Savary _et al._ 2012.
- `RcOpt`: potential basic infection rate corrected for removals. From Table 1 Savary _et al._ 2012.
- `i`: duration of infectious period. From Table 1 Savary _et al._ 2012.
- `p`: duration of latent period. From Table 1 Savary _et al._ 2012.
- `Sx`: maximum number of sites. From Table 1 Savary _et al._ 2012.
- `a`: aggregation coefficient. From Table 1 Savary _et al._ 2012.
- `RRS`: relative rate of physiological senescence. From Table 1 Savary _et al._ 2012.
- `RRG`: relative rate of growth. From Table 1 Savary _et al._ 2012.

# Returns
A `DataFrame` with the model's output. Latitude and longitude are included for mapping purposes if they are present in the input weather data.

"""

function hlipmodel(;
    wth,
    emergence{Dates.Date},
    onset,
    duration,
    rhlim,
    rainlim,
    H0{Int, Float64},
    I0{Int, Float64},
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

    if !(typeof(emergence) == Dates.Date)
        error("emergence must be a Date object")
    end

    final_day = emergence + Dates.Day(duration - 1)
    season = Base.collect(emergence:Dates.Day(1):final_day)

    # Convert emergence date into Julian date, sequential day in year.
    emergence_doy = Dates.dayofyear(emergence)

    if !(emergence >= wth[1, "YYYYMMDD"] ||
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
        audpc = _audpc(intensity)
    )

    if hasproperty(wth, "LAT") && hasproperty(wth, "LON")
        res = DataFrames.DataFrame(
            insertcols!(res, :lat => wth[1, "LAT"], :lon => wth[1, "LON"])
        )
    end

    return res
end

function _fn_rc(Rc, x)
    itp = Interpolations.LinearInterpolation(Rc[:, 1], Rc[:, 2], extrapolation_bc = 0)
    x = itp.(x)
    return x
end

function _audpc(intensity)
    n = length(intensity) - 1
    out = Base.zeros(n)

    for i in 1:n
        out[i] = (intensity[i] + intensity[i + 1]) / 2
    end

    return sum(out)
    end

end # module
