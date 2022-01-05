```@meta
Author = "Adam H. Sparks"
```

# Modelling Disease Epidemics

Epicrop supplies one function, `hlipmodel` that can be used to predict unmanaged plant
disease epidemics.
Predefined values for the EPIRICE model can be found in Savary _et al._ (2012) for the
following diseases of rice: bacterial blight, brown spot, leaf blast, sheath blight, tungro.
Given other parameters, the model framework is capable of modelling other diseases using the
methods as described by Savary _et al._ (2012).

# Example Usage

Predict an unmanaged epidemic of brown spot at the International Rice Research Institute
(IRRI) Zeigler Experiment station in Los Baños, Calabarzon, Philippines.
Weather data will be downloaded from the [NASA POWER](https://power.larc.nasa.gov) API for
use in this example.
As the model will run for 120 days, we will download weather data for for 120 days starting
on July 01, 2010 and ending on October 28, 2010.
To automate this process, you may find the R package,
[nasapower](https://cran.r-project.org/web/packages/nasapower/index.html), useful for
downloading weather data in conjunction with
[RCall](https://github.com/JuliaInterop/RCall.jl).

```@example 1
using Epicrop, DataFrames, Dates, CSV

w = CSV.read(download("https://power.larc.nasa.gov/api/temporal/daily/point?parameters=PRECTOTCORR,T2M,RH2M&community=ag&start=20100701&end=20101028&latitude=14.6774&longitude=121.25562&format=csv&time_standard=utc&user=Epicropjl"), DataFrame, header = 12)

# rename the columns to match the expected column names for hlipmodel
rename!(w, :RH2M => :RHUM, :T2M => :TEMP, :PRECTOTCORR => :RAIN)

# add columns for YYYYMMDD and lat/lon
insertcols!(w, 1, :YYYYMMDD => range(Date(2010, 06, 30); step=Day(1), length=120))
insertcols!(w, :LAT => 14.6774, :LON => 121.25562)

RcA = [0 0.35; 20 0.35; 40 0.35; 60 0.47; 80 0.59; 100 0.71; 120 1]

RcT = [15 0; 20 0.06; 25 1.0; 30 0.85; 35 0.16; 40 0]

bs = hlipmodel(
		wth = w,
		emergence = "2010-07-01",
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

bs
```

## References

Serge Savary, Andrew Nelson, Laetitia Willocquet, Ireneo Pangga and Jorrel Aunario (2012). Modeling and mapping potential epidemics of rice diseases globally. _Crop Protection_, Volume 34, Pages 6-17, ISSN 0261-2194 DOI: [10.1016/j.cropro.2011.11.009](https://doi.org/10.1016/j.cropro.2011.11.009).