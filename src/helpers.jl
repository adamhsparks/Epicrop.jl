
"""
    bacterialblight(wth::DataFrame, emergence::Dates.Date)

Run a healthy-latent-infectious-postinfectious (HLIP) model using weather data and optimal
curve values for rice bacterial blight _Xanthomonas oryzae_ pv. _oryzae_.

## Keywords

- `wth`: a data frame of weather on a daily time-step containing data with the following
field names.

    | Field | value |
    |-------|-------------|
    |YYYYMMDD | Date as Year Month Day, YYYY-MM-DD, (ISO8601) |
    |DOY |  Consecutive day of year, commonly called "Julian date" |
    |TEMP | Mean daily temperature (°C) |
    |RHUM | Mean daily relative humidity (%) |
    |RAIN | Mean daily rainfall (mm) |

- `emergence`: expected date of plant emergence as a `Date` object. From Table 1 Savary
_et al._ 2012.

## Returns

A `DataFrames.DataFrame` with predictions for bacterial blight severity. Latitude and
longitude are included for mapping purposes if they are present in the input weather data.
"""
function bacterialblight(wth::DataFrame, emergence::Dates.Date)
    RcA = [
        0 1
        10 1
        20 1
        30 0.9
        40 0.62
        50 0.43
        60 0.41
        70 0.41
        80 0.41
        90 0.41
        100 0.41
        110 0.41
        120 0.41
    ]

    RcT = [16 0; 19 0.29; 22 0.44; 25 0.90; 28 0.90; 31 1; 34 0.88; 37 0.01; 40 0]

    hlipmodel(
        wth=wth,
        emergence=emergence,
        onset=20,
        duration=120,
        rhlim=90,
        rainlim=5,
        H0=100,
        I0=1,
        RcA=RcA,
        RcT=RcT,
        RcOpt=0.97,
        p=5,
        i=30,
        Sx=3200,
        a=4.0,
        RRS=0.01,
        RRG=0.1,
    )
end

"""
    brownspot(wth::DataFrames.DataFrame, emergence::Dates.Date)

Runs a healthy-latent-infectious-postinfectious (HLIP) model using weather data and optimal
curve values for rice brown spot caused by _Cochliobolus miyabeanus_.

## Keywords

- `wth`: a data frame of weather on a daily time-step containing data with the following
field names.
    | Field | value |
    |-------|-------------|
    |YYYYMMDD | Date as Year Month Day, YYYY-MM-DD, (ISO8601) |
    |DOY |  Consecutive day of year, commonly called "Julian date" |
    |TEMP | Mean daily temperature (°C) |
    |RHUM | Mean daily relative humidity (%) |
    |RAIN | Mean daily rainfall (mm) |.
- `emergence`: expected date of plant emergence as a `Date` object. From Table 1 Savary
_et al._ 2012.

## Returns

A `DataFrame` with predictions for brown spot severity. Latitude and longitude are included
for mapping purposes if they are present in the input weather data.
"""
function brownspot(wth::DataFrames.DataFrame, emergence::Dates.Date)
    RcA = [0 0.35; 20 0.35; 40 0.35; 60 0.47; 80 0.59; 100 0.71; 120 1]

    RcT = [15 0; 20 0.06; 25 1.0; 30 0.85; 35 0.16; 40 0]

    hlipmodel(
        wth=wth,
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
        RRG=0.1,
    )
end

"""
    leafblast(wth::DataFrames.DataFrame, emergence::Dates.Date)

Runs a healthy-latent-infectious-postinfectious (HLIP) model using weather data and optimal
curve values for rice leaf blast caused by _Magnaporthe oryzae_.

## Keywords

- `wth`: a data frame of weather on a daily time-step containing data with the following
field names.
    | Field | value |
    |-------|-------------|
    |YYYYMMDD | Date as Year Month Day, YYYY-MM-DD, (ISO8601) |
    |DOY |  Consecutive day of year, commonly called "Julian date" |
    |TEMP | Mean daily temperature (°C) |
    |RHUM | Mean daily relative humidity (%) |
    |RAIN | Mean daily rainfall (mm) |.
- `emergence`: expected date of plant emergence as a `Date` object. From Table 1 Savary
_et al._ 2012.

## Returns

A `DataFrame` with predictions for leaf blast severity. Latitude and longitude are included
for mapping purposes if they are present in the input weather data.
"""
function leafblast(wth::DataFrames.DataFrame, emergence::Dates.Date)
    RcA = [
        0 1
        5 1
        10 1
        15 0.9
        20 0.8
        25 0.7
        30 0.64
        35 0.59
        40 0.53
        45 0.43
        50 0.32
        55 0.22
        60 0.16
        65 0.09
        70 0.03
        75 0.02
    ]
    RcT = [10 0; 15 0.5; 20 1; 25 0.6; 30 0.2; 35 0.05; 40 0.01; 45 0]

    hlipmodel(
        wth=wth,
        emergence=emergence,
        onset=20,
        duration=120,
        rhlim=90,
        rainlim=5,
        H0=600,
        I0=1,
        RcA=RcA,
        RcT=RcT,
        RcOpt=1.14,
        p=5,
        i=20,
        Sx=30000,
        a=1.0,
        RRS=0.01,
        RRG=0.1,
    )
end

"""
    sheathblight(wth::DataFrames.DataFrame, emergence::Dates.Date)

Runs a healthy-latent-infectious-postinfectious (HLIP) model using weather data and optimal
curve values for rice sheath blight caused by _Rhizoctonia solani_ AG1-1A Kühn.

## Keywords

- `wth`: a data frame of weather on a daily time-step containing data with the following
field names.
    | Field | value |
    |-------|-------------|
    |YYYYMMDD | Date as Year Month Day, YYYY-MM-DD, (ISO8601) |
    |DOY |  Consecutive day of year, commonly called "Julian date" |
    |TEMP | Mean daily temperature (°C) |
    |RHUM | Mean daily relative humidity (%) |
    |RAIN | Mean daily rainfall (mm) |
- `emergence`: expected date of plant emergence as a `Date` object. From Table 1 Savary
_et al._ 2012.

## Returns

A `DataFrame` with predictions for sheath blight severity. Latitude and longitude are
included for mapping purposes if they are present in the input weather data.
"""
function sheathblight(wth::DataFrames.DataFrame, emergence::Dates.Date)
    RcA = [
        0 0.84
        10 0.84
        20 0.84
        30 0.84
        40 0.84
        50 0.84
        60 0.84
        70 0.88
        80 0.88
        90 1
        100 1
        110 1
        120 1
    ]

    RcT = [12 0; 16 0.42; 20 94; 24 0.94; 28 1; 32 0.85; 36 0.64; 40 0]

    hlipmodel(
        wth=wth,
        emergence=emergence,
        onset=30,
        duration=120,
        rhlim=90,
        rainlim=5,
        H0=25,
        I0=1,
        RcA=RcA,
        RcT=RcT,
        RcOpt=0.46,
        p=3,
        i=120,
        Sx=800,
        a=2.8,
        RRS=0.005,
        RRG=0.2,
    )
end

"""
    tungro(wth::DataFrames.DataFrame, emergence::Dates.Date)

Runs a healthy-latent-infectious-postinfectious (HLIP) model using weather data and optimal curve
values for rice tungro disease caused by _Rice Tungro Spherical_ and _Rice Tungro Bacilliform_
viruses.

## Keywords

- `wth`: a data frame of weather on a daily time-step containing data with the following field names.
    | Field | value |
    |-------|-------------|
    |YYYYMMDD | Date as Year Month Day, YYYY-MM-DD, (ISO8601) |
    |DOY |  Consecutive day of year, commonly called "Julian date" |
    |TEMP | Mean daily temperature (°C) |
    |RHUM | Mean daily relative humidity (%) |
    |RAIN | Mean daily rainfall (mm) |
- `emergence`: expected date of plant emergence as a `Date` object. From Table 1 Savary _et al._
2012.

## Returns

A `DataFrame` with predictions for tungro incidence. Latitude and longitude are included for mapping
purposes if they are present in the input weather data.
"""
function tungro(wth::DataFrames.DataFrame, emergence::Dates.Date)
    RcA = [0 1; 15 1; 30 0.98; 45 0.73; 60 0.51; 75 0.34; 90 0; 105 0; 120 0]

    RcT = [
        9 0
        10 13
        13.1111 0.65
        16.2222 0.75
        19.3333 0.83
        22.4444 0.89
        25.5555 0.93
        28.6666 0.97
        31.7777 1
        34.8889 0.93
        37.9999 0.99
        40 0
    ]

    hlipmodel(
        wth=wth,
        emergence=emergence,
        onset=30,
        duration=120,
        rhlim=90,
        rainlim=5,
        H0=25,
        I0=1,
        RcA=RcA,
        RcT=RcT,
        RcOpt=0.18,
        p=6,
        i=120,
        Sx=100,
        a=1.0,
        RRS=0.01,
        RRG=0.1,
    )
end
