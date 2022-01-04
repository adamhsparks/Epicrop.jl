```@meta
Author = "Adam H. Sparks"
```
# Epicrop.jl

A Healthy-Latent-Infectious-Postinfectious (HLIP) model for unmanaged plant disease epidemic modeling.
Originally this modelling framework was used by specific disease models in EPIRICE to simulate severity of several rice
diseases (Savary _et al._ 2012).
Given proper values it can be used with other pathosystems as well.
## Installation

Epicrop.jl is not yet a registered Julia package, but I hope to have it in good enough condition to register it shortly.
Until then you can install it with the following commands:

```julia
julia> using Pkg

julia> Pkg.clone("https://github.com/adamhsparks/Epicrop.jl")
```

Epicrop.jl provides a single function, `run_hlip_model`, which takes the following arguments and returns a DataFrame of the results:

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


```@index
Modules = [Epicrop]
```

## Overview

```@autodocs
Modules = [Epicrop]
Order   = [:module]
```

## Types

```@autodocs
Modules = [Epicrop]
Order   = [:type]
```

## Methods

```@autodocs
Modules = [Epicrop]
Order   = [:function]
```
