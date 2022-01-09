"""
bacterialblight(
    wth,
    emergence,
    duration,
    )

Runs a healthy-latent-infectious-postinfectious (HLIP) model using weather data and
optimal curve values for rice bacterial blight.

# Keywords
- `wth`: a data frame of weather on a daily time-step.
- `emergence`: expected date of plant emergence entered in `YYYY-MM-DD` format.
From Table 1 Savary *et al.* 2012.
- `onset` expected number of days until the onset of disease after emergence date.
From Table 1 Savary *et al.* 2012.
- `duration`: simulation duration (growing season length).
From Table 1 Savary *et al.* 2012.

# Returns
A `DataFrame` with predictions for bacterial blight severity. Latitude and longitude are
included for mapping purposes if they are present in the input weather data.
"""

function brownspot(;
    wth,
    emergence
)

RcA = [0 0.35; 20 0.35; 40 0.35; 60 0.47; 80 0.59; 100 0.71; 120 1]

RcT = [15 0; 20 0.06; 25 1.0; 30 0.85; 35 0.16; 40 0]

return(
    hlipmodel(
        wth = wth,
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
)
end
