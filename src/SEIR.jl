
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
julia> RcA = [[collect(0:6) * 20], [0.35, 0.35, 0.35, 0.47, 0.59, 0.71, 1.0]]
julia> RcT = [[15 .+ (collect(0:5) * 5)], [0, 0.06, 1.0, 0.85, 0.16, 0]]
julia> emergence = "2000-07-15"

julia> using RCall

julia> wth = rcopy(R"nasapower::get_power(community = 'AG',
  lonlat = c(151.81, -27.48),
  pars = c('RH2M', 'T2M', 'PRECTOT'),
  dates = c('2000-07-01', '2000-12-31'),
  temporal_average = 'DAILY')")

julia> SEIR(
  wth = wth,
  emergence = emergence,
  onset = 20,
  duration = 120,
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
function seir(wth,
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

    # set date formats
    emergence_day = Date.(emergence, Dates.DateFormat("yyyy-mm-dd"))
    
    final_day = emergence_day + Dates.Day(duration)
    season = collect(emergence_day:Day(1):final_day)

    # convert emergence date into Julian date, sequential day in year
    emergence_doy = Dates.dayofyear(emergence_day)

    # check that the dates roughly align
    if !(emergence_day >= wth[1, "YYYYMMDD"]) ||
        final_day > findmax(wth[:, "YYYYMMDD"])[1]
      error("incomplete weather data or dates do not align")
    end

    # subset weather data where date is greater than emergence minus one
    season_wth = wth[in(season - Day(1)).(wth.YYYYMMDD), :]

    # outputvars
    cofr = rc = RHCoef = latency = infectious = severity = rsenesced = rgrowth = rtransfer =
    infection = diseased = senesced = removed = now_infectious = now_latent = sites =
    total_sites = rrlex = zeros(duration + 1)

    for d in 0:duration
      # State calculations
      cs_1 = d + 1
      if d == 0
        # start crop growth
        sites[cs_1] = H0
        rsenesced[cs_1] = RRS * sites[cs_1]
      else
        if d > i
          removed_today = infectious[infday + 2]
        else
          removed_today = 0
        end
      end

        sites[cs_1] = sites[d] + rgrowth[d] - infection[d] - rsenesced[d]
        rsenesced[cs_1] = removed_tod + RRS * sites[cs_1]
        senesced[cs_1] = senesced[d] + rsenesced[d]

        latency[cs_1] = infection[d]
        latd = d - p + 1
        latday = max(0, latday)
        now_latent[d + 1] = sum(latency[latday:d + 1])

        infectious[d + 1] = rtransfer[d]
        infday = d - i + 1
        infday = max(0, infday)
        now_infectious[d + 1] = sum(infectious[infday:d + 1])

      cs_2 = d + 1
      if sites[cs_2] < 0
        sites[cs_2] = 0
        break
      end

      if wth[!, "RHUM"[cs_2] == rhlim] | wth[!, "RAIN"[cs_2] >= rainlim]
        RHCoef[cs_2] = 1
      end
        
      cs_6 = d + 1
      cs_3 = cs_6
      rc[cs_6] = RcOpt * afgen(RcA, d) * afgen(RcT, wth$TEMP[d + 1]) * RHCoef[cs_3]
      cs_4 = d + 1
      diseased[cs_3] = sum(infectious) + now_latent[cs_4] + removed[cs_4]
      cs_5 = d + 1
      removed[cs_4] = sum(infectious) - now_infectious[cs_5]

      cofr[cs_5] = 1 - (diseased[cs_5] / (sites[cs_5] + diseased[cs_5]))
      
      # initialisation of disease
      if d == onset
        infection[cs_5] = I0
      else if d > onset
                infection[cs_5] = now_infectious[cs_5] * rc[cs_5] * (cofr[cs_5] ^ a)
      else
        infection[cs_5] = 0
      end

      if d >=  p
        rtransfer[cs_5] = latency[latday + 1]
      else
        rtransfer[cs_5] = 0
      end

      total_sites[cs_5] = diseased[cs_5] + sites[cs_5] 
      rgrowth[cs_5] = RRG * sites[cs_5] * (1 - (total_sites[cs_5] / Sx))
      severity[cs_5] = (diseased[cs_5] - removed[cs_5]) /
        (total_sites[cs_5] - removed[cs_5]) * 100
    end

    res =
      data.table(
        cbind(
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
          severity
        )
      )

    res[!, dates := dates[1:(d + 1)]]

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
        "severity",
        "dates"
      )
    )

    setcolorder(res, c("simday", "dates"))

    res[!, lat := rep_len(wth[!, LAT], .N)]
    res[!, lon := rep_len(wth[!, LON], .N)]
    return res
  end
