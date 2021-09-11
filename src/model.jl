
"""
    SEIR(wth,
        emergence,
        onset,
        duration,
        rhlim = 90,
        rainlim = 5,
        H0,
        I0 = 1,
        RcA,
        RcT,
        RcOpt,
        p,
        i,
        Sx,
        a,
        RRS,
        RRG)

A Susceptible-Exposed-Infectious-Removed (SEIR) model framework originally used by specific
disease models in EPIRICE to simulate severity of several rice diseases.

Given proper values it can be used with other pathosystems as well.

Returns a DataFrame with the following fields and values.
  | Field | Value |
  |-------|-------------|
  |simday | Zero indexed day of simulation that was run |
  |dates |  Date of simulation |
  |sites | Total number of sites present on day "x" |
  |latent | Number of latent sites present on day "x" |
  |infectious | Number of infectious sites present on day "x" |
  |removed | Number of removed sites present on day "x" |
  |senesced | Number of senesced sites present on day "x" |
  |rateinf | Rate of infection. | 
  |rtransfer | Rate of transfer from latent to infectious sites |
  |rgrowth | Rate of growth of healthy sites |
  |rsenesced | Rate of senescence of healthy sites |
  |rlex | Rate of lesion expansion |
  |diseased | Number of diseased (latent + infectious + removed) sites |
  |severity | Disease severity or incidence (for tungro) |
  |lat | Latitude value as provided by `wth` object |
  |lon | Longitude value as provided by `wth` object |

# Arguments
- wth a data frame of weather on a daily time-step containing data with the following field
names.
  | Field | value |
  |-------|-------------|
  |YYYYMMDD | Date as Year Month Day (ISO8601) |
  |DOY |  Consecutive day of year, commonly called "Julian date" |
  |TEMP | Mean daily temperature (°C) |
  |TMIN | Minimum daily temperature (°C) |
  |TMAX | Maximum daily temperature (°C) |
  |TDEW | Mean daily dew point temperature (°C) |
  |RHUM | Mean daily temperature (°C) |
  |RAIN | Mean daily rainfall (mm) |
- emergence expected date of plant emergence entered in `YYYY-MM-DD` format. From Table 1
Savary *et al.* 2012.
- onset expected number of days until the onset of disease after emergence date. From Table
1 Savary *et al.* 2012.
- duration simulation duration (growing season length). From Table 1 Savary *et al.* 2012.
- rhlim threshold to decide whether leaves are wet or not (usually 90 %). From Table 1
Savary *et al.* 2012.
- rainlim threshold to decide whether leaves are wet or not. From Table 1 Savary *et al.*
2012.
- wetness_type simulate RHmax or rain threshold (0) or leaf wetness duration (1). From Table
1 Savary *et al.* 2012.
- H0 initial number of plant's healthy sites. From Table 1 Savary *et al.* 2012.
- I0 initial number of infective sites. From Table 1 Savary *et al.* 2012.
- RcA crop age modifier for *Rc* (the basic infection rate corrected for removals). From
Table 1 Savary *et al.* 2012.
- RcT temperature modifier for *Rc* (the basic infection rate corrected for removals). From
Table 1 Savary *et al.* 2012.
- RcOpt potential basic infection rate corrected for removals. From Table 1 Savary *et al.*
2012. 
- i duration of infectious period. From Table 1 Savary *et al.* 2012.
- p duration of latent period. From Table 1 Savary *et al.* 2012.
- Sx maximum number of sites. From Table 1 Savary *et al.* 2012.
- a aggregation coefficient. From Table 1 Savary *et al.* 2012.
- RRS relative rate of physiological senescence. From Table 1 Savary *et al.* 2012.
- RRG relative rate of growth. From Table 1 Savary *et al.* 2012.

# References
> Savary, S., Nelson, A., Willocquet, L., Pangga, I., and Aunario,  J. Modeling and mapping
potential epidemics of rice diseases globally. *Crop Protection*, Volume 34, 2012, Pages 6-
17, ISSN 0261-2194 DOI: <http://dx.doi.org/10.1016/j.cropro.2011.11.009>.

# Examples
```jldoctest
# provide suitable values for brown spot severity
julia> RcA = [0 0.35; 20 0.35; 40 0.35; 60 0.47; 80 0.59; 100 0.71; 120 1.0]
julia> RcT = [15 0; 20 0.06; 25 1.0; 30 0.85; 35 0.16; 40 0]

julia> using RCall

julia> wth = rcopy(
  R"nasapower::get_power(community = 'AG',
  lonlat = c(151.81, -27.48),
  pars = c('RH2M', 'T2M', 'PRECTOT'),
  dates = c('2000-07-01', '2000-12-31'),
  temporal_average = 'DAILY')"
  )

julia> SEIR(
  wth = wth,
  emergence = "2000-07-15",
  onset = 20,
  duration = 120,
  rhlim = 90,
  rainlim = 5,
  RcA = RcA,
  RcT = RcT,
  RcOpt = 0.61,
  p = 6,
  i = 19,
  H0 = 600,
  a = 1,
  Sx = 100000,
  RRS = 0.01,
  RRG = 0.1
)
```

"""
function SEIR(wth,
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

    # set up infday object
    infday = 0
    
    # set date formats
    emergence_day = Date.(emergence, Dates.DateFormat("yyyy-mm-dd"))
    
    final_day = emergence_day + Dates.Day(duration)
    season = collect(emergence_day:Day(1):final_day)

    # convert emergence date into Julian date, sequential day in year
    emergence_doy = Dates.dayofyear(emergence_day)

    # check that the dates roughly align
    if !(emergence_day >= wth[1, "YYYYMMDD"] ||
        final_day > findmax(wth[:, "YYYYMMDD"])[1])
      error("incomplete weather data or dates do not align")
    end

    # subset weather data where date is greater than emergence minus one
    season_wth = wth[in(season - Day(1)).(wth.YYYYMMDD), :]
    
    # output variables
    cofr = zeros(duration + 1)
    rc = zeros(duration + 1)
    RHCoef = zeros(duration + 1)
    latency = zeros(duration + 1)
    infectious = zeros(duration + 1)
    intensity = zeros(duration + 1)
    rsenesced = zeros(duration + 1)
    rgrowth = zeros(duration + 1)
    rtransfer = zeros(duration + 1)
    infection = zeros(duration + 1)
    diseased = zeros(duration + 1)
    senesced = zeros(duration + 1)
    removed = zeros(duration + 1)
    now_infectious = zeros(duration + 1)
    now_latent = zeros(duration + 1)
    sites = zeros(duration + 1)
    total_sites = zeros(duration + 1)
    rrlex = zeros(duration + 1)
    lat = zeros(duration + 1)
    lon = zeros(duration + 1)

    for d in 1:length(duration)
      # State calculations
      d1 = d + 1
      if d == 1
        # start crop growth
        sites[d1] = H0
        rsenesced[d1] = RRS * sites[d1]
      else
        if d > i
          removed_today = infectious[infday + 2]
        else
          removed_today = 0
        end

        sites[d1] = sites[d] + rgrowth[d] - infection[d] - rsenesced[d]
        rsenesced[d1] = removed_today + RRS * sites[d1]
        senesced[d1] = senesced[d] + rsenesced[d]

        latency[d1] = infection[d]
        latday = d - p + 1
        latday = max(0, latday)
        now_latent[d1] = sum(latency[latday:d + 1])

        infectious[d1] = rtransfer[d]
        infday = d - i + 1
        infday = max(0, infday)
        now_infectious[d1] = sum(infectious[infday:d + 1])
      end
      
      if sites[d1] < 0
        sites[d1] = 0
        break
      end

      if (wth[!, :RH2M][d1] >= rhlim || wth[!, :PRECTOT][d1] >= rainlim)
        RHCoef[d1] = 1
      end
        
      rc[d1] = RcOpt * select_mod_val(RcA, d) * select_mod_val(RcT, wth[!, :T2M][d1]) * RHCoef[d1]
      diseased[d1] = sum(infectious) + now_latent[d1] + removed[d1]
      removed[d1] = sum(infectious) - now_infectious[d1]

      cofr[d1] = 1 - (diseased[d1] / (sites[d1] + diseased[d1]))
      
      # initialisation of disease
      if d == onset
        infection[d1] = I0
      elseif d > onset
                infection[d1] = now_infectious[d1] * rc[d1] * (cofr[d1] ^ a)
      else
        infection[d1] = 0
      end

      if d >=  p
        rtransfer[d1] = latency[latday + 1]
      else
        rtransfer[d1] = 0
      end

      total_sites[d1] = diseased[d1] + sites[d1]
      rgrowth[d1] = RRG * sites[d1] * (1 - (total_sites[d1] / Sx))
      intensity[d1] = (diseased[d1] - removed[d1]) / (total_sites[d1] - removed[d1]) * 100
    end

    res = DataFrame(
            0:duration,
            sites,
            now_latent,
            now_infectious,
            removed,
            senesced,
            infection,
            rtransfer,
            rgrowth,
            rsenesced,
            diseased,
            intensity)

    setnames(
      res,
      c(
        "simday",
        "sites",
        "latent",
        "infectious",
        "removed",
        "senesced",
        "rateinf",
        "rtransfer",
        "rgrowth",
        "rsenesced",
        "diseased",
        "intensity",
        "dates"
      )
    )

    setcolorder(res, c("simday", "dates"))

    res[!, :lat] = wth[!, LAT]
    res[!, :lon] = wth[!, LON]
    return res
  end


# Adapted from R package epicrop for SEIR.jl by Adam H. Sparks
function select_mod_val(xy, x)
  d = size(xy)
  if (x <= xy[1, 1])
    res = xy[1, 2]
  elseif (x >= xy[d[1], 1])
  else 
    a = xy[xy[:, 1] .<= x, :]
    b = xy[xy[:, 1] .>= x, :]
    if (length(a) == 2)
      int = vcat(a, b[[1], :])
    elseif (length(b) == 2)
      int = vcat(a[size(a)[1], :]', b)
    else
      int = vcat(a[size(a)[1], :]', b[1, :]')
    end
    if (x == int[1, 1]) 
      res = int[1, 2]
    elseif (x == int[2, 1])
      res = int[2, 2]
    else 
      res = int[1, 2] + (x - int[1, 1]) * ((int[2, 2] - int[1, 2]) / (int[2, 1] - int[1, 1]))
    end
    return res
  end
end