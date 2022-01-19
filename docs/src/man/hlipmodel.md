# Modelling Crop Disease Epidemics

```@meta
Author = "Adam H. Sparks"
```

Epicrop provides a basic function, `hlipmodel`, that can be used to predict unmanaged plant disease epidemics given the proper inputs.
Predefined values for the EPIRICE model can be found in Savary _et al._ (2012) for the following diseases of rice: bacterial blight, brown spot, leaf blast, sheath blight, tungro and are included as helper functions that simplify running the model, `bacterialblight`, `brownspot`, `leafblast`, `sheathblight`, and `tungro`.
Given other parameters, the model framework is capable of modelling other diseases using the methods as described by Savary _et al._ (2012).

```julia
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
```
## Keywords

- `wth` a data frame of weather on a daily time-step containing data with the following field names.
  | Field | value |
  |-------|-------------|
  |YYYYMMDD | Date as Year Month Day, YYYY-MM-DD, (ISO8601) |
  |DOY |  Consecutive day of year, commonly called "Julian date" |
  |TEMP | Mean daily temperature (°C) |
  |RHUM | Mean daily relative humidity (%) |
  |RAIN | Mean daily rainfall (mm) |
- `emergence`: expected date of plant emergence as a `Date` object. From Table 1 Savary _et al._ 2012.
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

## Returns

- A `DataFrame` with the model's output with the following fields and values.

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
  |audpc | Area under the disease progress curve for the whole of simulated season |
  |lat | Latitude value as provided by `wth` object |
  |lon | Longitude value as provided by `wth` object |

## Example Usage

Predict an unmanaged epidemic of brown spot at the International Rice Research Institute (IRRI) Zeigler Experiment station in Los Baños, Calabarzon, Philippines.
Weather data will be downloaded from the [NASA POWER](https://power.larc.nasa.gov) API for use in this example.
As the model will run for 120 days, we will download weather data for for 120 days starting on July 01, 2010 and ending on October 28, 2010.
To automate this process, you may find the R package, [nasapower](https://cran.r-project.org/web/packages/nasapower/index.html), useful for
downloading weather data in conjunction with [RCall](https://github.com/JuliaInterop/RCall.jl).

```@example
using Epicrop, DataFrames, Dates, CSV, Downloads

# download weather data from NASA POWER API
w = CSV.read(Downloads.download("https://power.larc.nasa.gov/api/temporal/daily/point?parameters=PRECTOTCORR,T2M,RH2M&community=ag&start=20100701&end=20101028&latitude=14.6774&longitude=121.25562&format=csv&time_standard=utc&user=Epicropjl"), DataFrame, header = 12)

# rename the columns to match the expected column names for hlipmodel
rename!(w, :RH2M => :RHUM, :T2M => :TEMP, :PRECTOTCORR => :RAIN)

# add columns for YYYYMMDD and lat/lon
insertcols!(w, 1, :YYYYMMDD => range(Date(2010, 06, 30); step = Day(1), length = 120))
insertcols!(w, :LAT => 14.6774, :LON => 121.25562)

emergence = Dates.Date.("2010-07-01", Dates.DateFormat("yyyy-mm-dd"))

RcA = [0 0.35; 20 0.35; 40 0.35; 60 0.47; 80 0.59; 100 0.71; 120 1]

RcT = [15 0; 20 0.06; 25 1.0; 30 0.85; 35 0.16; 40 0]

bs = hlipmodel(
		wth = w,
		emergence = emergence,
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
## References

Serge Savary, Andrew Nelson, Laetitia Willocquet, Ireneo Pangga and Jorrel Aunario (2012). Modeling and mapping potential epidemics of rice diseases globally. _Crop Protection_, Volume 34, Pages 6-17, ISSN 0261-2194 DOI: [10.1016/j.cropro.2011.11.009](https://doi.org/10.1016/j.cropro.2011.11.009).