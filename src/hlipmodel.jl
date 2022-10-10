"""
    hlipmodel(;
    wth::DataFrames.AbstractDataFrame,
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
    RRG::Float64,
    )

Run a healthy-latent-infectious-postinfectious (HLIP) model using weather data and optimal
curve values for respective crop diseases.

## Keywords

- `wth::DataFrames.AbstractDataFrame`: weather data on a daily time-step containing data with the following values.
    - `YYYYMMDD::Union{AbstractString, Dates.Date}: the date in ISO8601 format, _i.e._, YYYY-MM-DD
    - `DOY::Int64`: the consecutive day of year, commonly called "Julian date"
    - `TEMP::AbstractFloat`: the mean daily temperature (°C)
    - `RHUM::AbstractFloat`: the mean daily relative humidity (%)
    - `RAIN::AbstractFloat`: the mean daily rainfall (mm)
- `emergence::Union{AbstractString, Dates.Date}`: the expected date of plant emergence. From Table 1 Savary _et al._ 2012.
- `onset::Int64`: the expected number of days until the onset of disease after emergence date. From Table 1 Savary _et al._ 2012.
- `duration::Int64`: the simulation duration (growing season length in days). From Table 1 Savary _et al._ 2012.
- `rhlim::Int64`: the threshold to decide whether leaves are wet or not (usually 90%). From Table 1 Savary _et al._ 2012.
- `rainlim::Int64`: the threshold to decide whether leaves are wet or not. From Table 1 Savary _et al._ 2012.
- `H0::Int64`: the initial number of plant's healthy sites. From Table 1 Savary _et al._ 2012.
- `I0::Int64`: the initial number of infective sites. From Table 1 Savary _et al._ 2012.
- `RcA::Matrix{Float64}`: a crop age modifier for *Rc* (the basic infection rate corrected for removals). From Table 1 Savary _et al._ 2012.
- `RcT::Matrix{Float64}`: a temperature modifier for *Rc* (the basic infection rate corrected for removals). From Table 1 Savary _et al._ 2012.
- `RcOpt::Float64`: the potential basic infection rate corrected for removals. From Table 1 Savary _et al._ 2012.
- `p::Int64`: the duration of latent period. From Table 1 Savary _et al._ 2012.
- `Sx::Int64`: the maximum number of sites. From Table 1 Savary _et al._ 2012.
- `a::Float64`: an aggregation coefficient. From Table 1 Savary _et al._ 2012.
- `RRS::Float64`: the relative rate of physiological senescence. From Table 1 Savary _et al._ 2012.
- `RRG::Float64`: the relative rate of growth. From Table 1 Savary _et al._ 2012.

## Output

A `DataFrames.AbstractDataFrame` with the model's output with the following columns and
values.

- simday: Zero indexed day of simulation that was run.
- dates:  Date of simulation.
- sites: Total number of sites present on day "x".
- latent: Number of latent sites present on day "x".
- infectious: Number of infectious sites present on day "x".
- removed: Number of removed sites present on day "x".
- senesced: Number of senesced sites present on day "x".
- rateinf: Rate of infection.
- rtransfer: Rate of transfer from latent to infectious sites.
- rgrowth: Rate of growth of healthy sites.
- rsenesced: Rate of senescence of healthy sites.
- diseased: Number of diseased (latent + infectious + removed) sites.
- intensity: Number of diseased sites as a proportion of total sites.
- audpc: Area under the disease progress curve for the whole of simulated season.
- lat: Latitude value as provided by `wth` object.
- lon: Longitude value as provided by `wth` object.

## Examples

Using data downloaded and saved from NASA POWER for Los Baños, Calabarzon, PH.

```julia
julia> using Epicrop

julia> using CSV

julia> using DelimitedFiles

julia> using DataFrames

julia> data, header = readdlm(joinpath(
                                dirname(pathof(Epicrop)),
                                    "..", "docs", "src", "assets",
                                        "POWER_data_LB_PHI_2000_ws.csv"),
                                ',', header=true)

julia> w = DataFrame(data, vec(header))

julia> emergence = "2000-07-01"

julia> RcA = [0 0.35;
            20 0.35;
            40 0.35;
            60 0.47;
            80 0.59;
            100 0.71;
            120 1.0]

julia> RcT = [15 0.0;
            20 0.06;
            25 1.0;
            30 0.85;
            35 0.16;
            40 0.0]

julia> bs = hlipmodel(;
        wth=w,
        emergence=emergence,
        onset=20,
        duration=120,
        rhlim=90,
        rainlim=5,
        H0=600,
        I0=1,
        RcA=RcA,
        RcT=RcT,
        RcOpt=0.61,
        p=6,
        i=19,
        Sx=100000,
        a=1.0,
        RRS=0.01,
        RRG=0.1
)
```

"""
function hlipmodel(;
        wth::DataFrames.AbstractDataFrame,
        emergence::Union{AbstractString, Dates.Date},
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
        RRG::Float64,
)

    if !(emergence isa Dates.Date)
        emergence = Dates.Date(emergence, Dates.DateFormat("yyyy-mm-dd"))
    end

    final_day = emergence + Dates.Day(duration - 1)
    season = Base.collect(emergence:Dates.Day(1):final_day)

    if !(wth[1, "YYYYMMDD"] isa Dates.Date)
        wth[!, :"YYYYMMDD"] = Dates.Date.(wth[!,:"YYYYMMDD"])
    end

    if !(Base.in(emergence, wth[:, 1]) || Base.in(final_day, wth.YYYYMMDD))
        throw(DomainError(wth, "incomplete weather data or dates do not align"))
    end

    if (H0 < 0)
        throw(DomainError(H0,
            "H0 cannot be < 0, check your initial number of healthy sites"))
    end

    if (I0 < 0)
        throw(DomainError(I0,
            "I0 cannot be < 0, check your initial number of infective sites"))
    end

    season_wth = wth[Base.in(season).(wth[:, 1]), :]

    return (
        _hliploop(;
        season = season,
        season_wth = season_wth,
        onset = onset,
        duration = duration,
        rhlim = rhlim,
        rainlim = rainlim,
        H0 = H0,
        I0 = I0,
        RcA = RcA,
        RcT = RcT,
        RcOpt = RcOpt,
        p = p,
        i = i,
        Sx = Sx,
        a = a,
        RRS = RRS,
        RRG = RRG
    )
    )
end

function _hliploop(;
    season,
    season_wth,
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
    Rc_temp = _fn_rc(RcT, season_wth[!, :TEMP])

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

        if (season_wth[:, 4][d] >= rhlim || season_wth[:, 5][d] >= rainlim)
            RHCoef[d] = 1
        end

        rc[d] = RcOpt * (Rc_age[d] * Rc_temp[d] * RHCoef[d])
        diseased[d] = sum(infectious) + now_latent[d] + removed[d]
        removed[d] = sum(infectious) - now_infectious[d]

        cofr[d] = 1 - (diseased[d] / (sites[d] + diseased[d]))

        # Initialise disease.
        if d == onset
            infection[d]=I0
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
        senesced = senesced,
        rateinf = infection,
        rtransfer = rtransfer,
        rgrowth = rgrowth,
        rsenesced = rsenesced,
        diseased = diseased,
        intensity = intensity,
        audpc = _audpc(intensity)
    )

    if hasproperty(season_wth, "LAT") && hasproperty(season_wth, "LON")
        res = DataFrames.DataFrame(
            insertcols!(res, :lat => season_wth[1, "LAT"], :lon => season_wth[1, "LON"])
        )
    end

    return res
end

function _fn_rc(Rc, x)
    itp = Interpolations.linear_interpolation(Rc[:, 1], Rc[:, 2],
        extrapolation_bc = Interpolations.Line())
    x = itp.(x)
    return x
end

function _audpc(intensity)
    n = length(intensity) - 1
    intvec = Base.zeros(n)
    out = 0.0

    for i in 1:n
        intvec[i] = (intensity[i] + intensity[i+1]) / 2
        out = sum(intvec)
    end

    return out
end
