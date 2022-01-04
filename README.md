# Epicrop.jl

[![Lifcycle:Experimental](https://img.shields.io/badge/Lifecycle-Experimental-yellow.svg)](https://img.shields.io/badge/Lifecycle-Experimental-yellow.svg)
[![CI](https://github.com/adamhsparks/Epicrop.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/adamhsparks/Epicrop.jl/actions/workflows/ci.yml)
[![Coverage](https://codecov.io/gh/adamshparks/Epicrop.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/adamshparks/Epicrop.jl)

Epicrop.jl is a [Julia](https://julialang.org) package that can be used to simulate disease epidemics.
If you have not yet installed Julia, [please follow the instructions for your operating system](https://julialang.org/downloads/platform/).

This package provides a Healthy-Latent-Infectious-Postinfectious (HLIP) model for unmanaged plant disease epidemic modelling.
Originally this modelling framework was used by specific disease models in EPIRICE to simulate severity of several rice diseases (Savary _et al._ 2012).
Given proper values it can be used with other pathosystems as well.
## Installation

Epicrop.jl is not yet a registered Julia package, but I hope to have it in good enough condition to register it shortly.
Until then you can install it with the following commands:

```julia
julia> using Pkg

julia> Pkg.clone("https://github.com/adamhsparks/Epicrop.jl")
```

You can copy and paste all commands to the REPL including the leading `julia>` prompts - they will automatically be stripped away by Julia.
## Using Epicrop.jl

Epicrop.jl is a package that can be used to simulate disease epidemics.
It provides a single function, `run_hlip_model`, which takes the following arguments and returns a DataFrame of the results:

- `wth` a data frame of weather on a daily time-step containing data with the following field names.
  | Field | value |
  |-------|-------------|
  |YYYYMMDD | Date as Year Month Day, YYYY-MM-DD, (ISO8601) |
  |DOY |  Consecutive day of year, commonly called "Julian date" |
  |TEMP | Mean daily temperature (°C) |
  |TMIN | Minimum daily temperature (°C) |
  |TMAX | Maximum daily temperature (°C) |
  |TDEW | Mean daily dew point temperature (°C) |
  |RHUM | Mean daily temperature (°C) |
  |RAIN | Mean daily rainfall (mm) |
- `emergence` expected date of plant emergence entered in `YYYY-MM-DD` format. From Table 1 Savary *et al.* 2012.
- `onset` expected number of days until the onset of disease after emergence date. From Table 1 Savary *et al.* 2012.
- `duration` simulation duration (growing season length). From Table 1 Savary *et al.* 2012.
- `rhlim` threshold to decide whether leaves are wet or not (usually 90%). From Table 1 Savary *et al.* 2012.
- `rainlim` threshold to decide whether leaves are wet or not. From Table 1 Savary *et al.* 2012.
- `H0` initial number of plant's healthy sites. From Table 1 Savary *et al.* 2012.
- `I0` initial number of infective sites. From Table 1 Savary *et al.* 2012.
- `RcA` crop age modifier for *Rc* (the basic infection rate corrected for removals). From Table 1 Savary *et al.* 2012.
- `RcT` temperature modifier for *Rc* (the basic infection rate corrected for removals). From Table 1 Savary *et al.* 2012.
- `RcOpt` potential basic infection rate corrected for removals. From Table 1 Savary *et al.* 2012. 
- `i` duration of infectious period. From Table 1 Savary *et al.* 2012.
- `p` duration of latent period. From Table 1 Savary *et al.* 2012.
- `Sx` maximum number of sites. From Table 1 Savary *et al.* 2012.
- `a` aggregation coefficient. From Table 1 Savary *et al.* 2012.
- `RRS` relative rate of physiological senescence. From Table 1 Savary *et al.* 2012.
- `RRG` relative rate of growth. From Table 1 Savary *et al.* 2012.
### Output

`run_hlip_model` returns a DataFrame with the following fields and values.
  | Field | Value |
  |-------|-------------|
  |simday | Zero indexed day of simulation that was run |
  |dates |  Date of simulation |
  |sites | Total number of sites present on day "x" |
  |latent | Number of latent sites present on day "x" |
  |infectious | Number of infectious sites present on day "x" |
  |removed | Number of removed sites present on day "x" |
  |senesced | Number of senesced sites present on day "x" |
  |rateinf | Rate of infection | 
  |rtransfer | Rate of transfer from latent to infectious sites |
  |rgrowth | Rate of growth of healthy sites |
  |rsenesced | Rate of senescence of healthy sites |
  |diseased | Number of diseased (latent + infectious + removed) sites |
  |intensity | Number of diseased sites as a proportion of total sites |
  |lat | Latitude value as provided by `wth` object |
  |lon | Longitude value as provided by `wth` object |
# Example

Provide `RcA` and `RcT` values suitable for brown spot severity and fetch weather data for the year 2000 wet season at the IRRI Zeigler Experiment Station in Los Baños, Philippines.
In this example, we will download weather data for the International Rice Research Institute (IRRI) from the NASA POWER database using a pre-defined API call for this location for the 2010 wet season.

```julia
julia> using DataFrames

julia> using CSV

julia> w = CSV.read(download("https://power.larc.nasa.gov/api/temporal/daily/point?parameters=PRECTOTCORR,T2M,RH2M&community=ag&start=20100630&end=20101231&latitude=14.6774&longitude=121.25562&format=csv&time_standard=utc&user=Epicropjl"), DataFrame, header = 12)

julia> rename!(w, :RH2M => :RHUM, :T2M => :TEMP, :PRECTOTCORR => :RAIN)

julia> RcA = [0 0.35; 20 0.35; 40 0.35; 60 0.47; 80 0.59; 100 0.71; 120 1]

julia> RcT = [15 0; 20 0.06; 25 1.0; 30 0.85; 35 0.16; 40 0]

julia> hlipmodel(
  wth = w,
  emergence = "2000-07-01",
  onset = 20,
  duration = 120,
  rhlim = 90,
  rainlim = 5,
  H0 = 600,
  I0 = 1,
  RcA = RcA,
  RcT = RcT,
  RcOpt = 0.61,
  p = 6,
  i = 19,
  Sx = 100000,
  a = 1,
  RRS = 0.01,
  RRG = 0.1
)
```
# References
Savary, S., Nelson, A., Willocquet, L., Pangga, I., and Aunario,  J. Modeling and mapping potential epidemics of rice diseases globally. _Crop Protection_, Volume 34, 2012, Pages 6-
17, ISSN 0261-2194 DOI: [10.1016/j.cropro.2011.11.009](http://dx.doi.org/10.1016/j.cropro.2011.11.009).