var documenterSearchIndex = {"docs":
[{"location":"","page":"Epicrop","title":"Epicrop","text":"CurrentModule = Epicrop","category":"page"},{"location":"#Epicrop","page":"Epicrop","title":"Epicrop","text":"","category":"section"},{"location":"","page":"Epicrop","title":"Epicrop","text":"Documentation for Epicrop.","category":"page"},{"location":"","page":"Epicrop","title":"Epicrop","text":"","category":"page"},{"location":"","page":"Epicrop","title":"Epicrop","text":"Modules = [Epicrop]","category":"page"},{"location":"#Epicrop.bacterialblight-Tuple{DataFrames.AbstractDataFrame, Dates.Date}","page":"Epicrop","title":"Epicrop.bacterialblight","text":"bacterialblight(wth::DataFrames.AbstractDataFrame, emergence::Dates.Date)\n\nRun a healthy-latent-infectious-postinfectious (HLIP) model using weather data and optimal curve values for rice bacterial blight Xanthomonas oryzae pv. oryzae.\n\nArguments\n\nwth: DataFrames:DataFrame a data frame of weather on a daily time-step containing data with the following field names.\nYYYYMMDD: Date as Year Month Day, YYYY-MM-DD, (ISO8601)\nDOY`:  Consecutive day of year, commonly called \"Julian date\"\nTEMP: Mean daily temperature (°C)`\nRHUM: Mean daily relative humidity (%)\nRAIN: Mean daily rainfall (mm)\nemergence: expected date of plant emergence as a Date object. From Table 1 Savary et al. 2012.\n\nExamples\n\njulia> weather=\njulia> emergence=Dates.Date.(\"2010-07-01\", Dates.DateFormat(\"yyyy-mm-dd\"))\njulia> bacterialblight(weather, emergence)\n\nReturns\n\nA Table with predictions for bacterial blight severity. Latitude and longitude are included for mapping purposes if they are present in the input weather data.\n\n\n\n\n\n","category":"method"},{"location":"#Epicrop.brownspot-Tuple{DataFrames.AbstractDataFrame, Dates.Date}","page":"Epicrop","title":"Epicrop.brownspot","text":"brownspot(wth::DataFrames.AbstractDataFrame, emergence::Dates:Date)\n\nRun a healthy-latent-infectious-postinfectious (HLIP) model using weather data and optimal curve values for rice brown spot caused by Cochliobolus miyabeanus.\n\nArguments\n\nwth: DataFrames:DataFrame a data frame of weather on a daily time-step containing data with the following field names.\nYYYYMMDD: Date as Year Month Day, YYYY-MM-DD, (ISO8601)\nDOY`:  Consecutive day of year, commonly called \"Julian date\"\nTEMP: Mean daily temperature (°C)`\nRHUM: Mean daily relative humidity (%)\nRAIN: Mean daily rainfall (mm)\nemergence: expected date of plant emergence as a Date object. From Table 1 Savary et al. 2012.\n\nExamples\n\njulia> weather=\njulia> emergence=Dates.Date.(\"2010-07-01\", Dates.DateFormat(\"yyyy-mm-dd\"))\njulia> brownspot(weather, emergence)\n\nReturns\n\nA Table with predictions for brown spot severity. Latitude and longitude are included for mapping purposes if they are present in the input weather data.\n\n\n\n\n\n","category":"method"},{"location":"#Epicrop.hlipmodel-Tuple{DataFrames.AbstractDataFrame, Dates.Date, Int64, Int64, Int64, Int64, Int64, Int64, Matrix{AbstractFloat}, Matrix{AbstractFloat}, AbstractFloat, Int64, Int64, Int64, AbstractFloat, AbstractFloat, AbstractFloat}","page":"Epicrop","title":"Epicrop.hlipmodel","text":"hlipmodel(\n    wth::DataFrames.AbstractDataFrame,\n    emergence::Dates.Date,\n    onset::Int,\n    duration::Int,\n    rhlim::Int,\n    rainlim::Int,\n    H0::Int,\n    I0::Int,\n    RcA::Matrix{AbstractFloat},\n    RcT::Matrix{AbstractFloat},\n    RcOpt::AbstractFloat,\n    p::Int,\n    i::Int,\n    Sx::Int,\n    a::AbstractFloat,\n    RRS::AbstractFloat,\n    RRG::AbstractFloat,\n)\n\nRun a healthy-latent-infectious-postinfectious (HLIP) model using weather data and optimal curve values for respective crop diseases.\n\nKeywords\n\nwth: DataFrames:DataFrame a data frame of weather on a daily time-step containing data with the following field names.\nYYYYMMDD: Date as Year Month Day, YYYY-MM-DD, (ISO8601)\nDOY`:  Consecutive day of year, commonly called \"Julian date\"\nTEMP: Mean daily temperature (°C)`\nRHUM: Mean daily relative humidity (%)\nRAIN: Mean daily rainfall (mm)\nemergence: Dates.Date expected date of plant emergence entered as a Dates.Date object. From Table 1 Savary et al. 2012.\nonset: Int,  expected number of days until the onset of disease after emergence date. From Table 1 Savary et al. 2012.\nduration: Int,  simulation duration (growing season length). From Table 1 Savary et al. 2012.\nrhlim: Int, threshold to decide whether leaves are wet or not (usually 90%). From Table 1 Savary et al. 2012.\nrainlim: Int, threshold to decide whether leaves are wet or not. From Table 1 Savary et al. 2012.\nH0: Int, initial number of plant's healthy sites. From Table 1 Savary et al. 2012.\nI0: Int, initial number of infective sites. From Table 1 Savary et al. 2012.\nRcA: Matrix{AbstractFloat}, crop age modifier for Rc (the basic infection rate corrected for removals). From Table 1 Savary et al. 2012.\nRcT: Matrix{AbstractFloat}, temperature modifier for Rc (the basic infection rate corrected for removals). From Table 1 Savary et al. 2012.\nRcOpt: AbstractFloat, potential basic infection rate corrected for removals. From Table 1 Savary et al. 2012.\np: Int, duration of latent period. From Table 1 Savary et al. 2012.\nSx: Int, maximum number of sites. From Table 1 Savary et al. 2012.\na: AbstractFloat, aggregation coefficient. From Table 1 Savary et al. 2012.\nRRS: AbstractFloat, relative rate of physiological senescence. From Table 1 Savary et al. 2012.\nRRG: AbstractFloat, relative rate of growth. From Table 1 Savary et al. 2012.\n\nReturns\n\nA DataFrame with the model's output. Latitude and longitude are included for mapping purposes if they are present in the input weather data.\n\n\n\n\n\n","category":"method"},{"location":"#Epicrop.leafblast-Tuple{DataFrames.AbstractDataFrame, Dates.Date}","page":"Epicrop","title":"Epicrop.leafblast","text":"leafblast(wth::DataFrames.AbstractDataFrame, emergence::Dates.Date)\n\nRun a healthy-latent-infectious-postinfectious (HLIP) model using weather data and optimal curve values for rice leaf blast caused by Magnaporthe oryzae.\n\nArguments\n\nwth: DataFrames:DataFrame a data frame of weather on a daily time-step containing data with the following field names.\nYYYYMMDD: Date as Year Month Day, YYYY-MM-DD, (ISO8601)\nDOY`:  Consecutive day of year, commonly called \"Julian date\"\nTEMP: Mean daily temperature (°C)`\nRHUM: Mean daily relative humidity (%)\nRAIN: Mean daily rainfall (mm)\nemergence: expected date of plant emergence as a Date object. From Table 1 Savary et al. 2012.\n\nExamples\n\njulia> weather=\njulia> emergence=Dates.Date.(\"2010-07-01\", Dates.DateFormat(\"yyyy-mm-dd\"))\njulia> leafblast(weather, emergence)\n\nReturns\n\nA Table with predictions for leaf blast severity. Latitude and longitude are included for mapping purposes if they are present in the input weather data.\n\n\n\n\n\n","category":"method"},{"location":"#Epicrop.sheathblight-Tuple{DataFrames.AbstractDataFrame, Dates.Date}","page":"Epicrop","title":"Epicrop.sheathblight","text":"sheathblight(wth::DataFrames.AbstractDataFrame, emergence::Dates.Date)\n\nRun a healthy-latent-infectious-postinfectious (HLIP) model using weather data and optimal curve values for rice sheath blight caused by Rhizoctonia solani AG1-1A Kühn.\n\nArguments\n\nwth: DataFrames:DataFrame a data frame of weather on a daily time-step containing data with the following field names.\nYYYYMMDD: Date as Year Month Day, YYYY-MM-DD, (ISO8601)\nDOY`:  Consecutive day of year, commonly called \"Julian date\"\nTEMP: Mean daily temperature (°C)`\nRHUM: Mean daily relative humidity (%)\nRAIN: Mean daily rainfall (mm)\nemergence: expected date of plant emergence as a Date object. From Table 1 Savary et al. 2012.\n\nExamples\n\njulia> weather=\njulia> emergence=Dates.Date.(\"2010-07-01\", Dates.DateFormat(\"yyyy-mm-dd\"))\njulia> sheathblight(weather, emergence)\n\nReturns\n\nA Table with predictions for sheath blight severity. Latitude and longitude are included for mapping purposes if they are present in the input weather data.\n\n\n\n\n\n","category":"method"},{"location":"#Epicrop.tungro-Tuple{DataFrames.AbstractDataFrame, Dates.Date}","page":"Epicrop","title":"Epicrop.tungro","text":"tungro(wth::DataFrames.AbstractDataFrame, emergence::Dates.Date)\n\nRun a healthy-latent-infectious-postinfectious (HLIP) model using weather data and optimal curve values for rice tungro disease caused by Rice Tungro Spherical and Rice Tungro Bacilliform viruses.\n\nArguments\n\nwth: DataFrames:DataFrame a data frame of weather on a daily time-step containing data with the following field names.\nYYYYMMDD: Date as Year Month Day, YYYY-MM-DD, (ISO8601)\nDOY`:  Consecutive day of year, commonly called \"Julian date\"\nTEMP: Mean daily temperature (°C)`\nRHUM: Mean daily relative humidity (%)\nRAIN: Mean daily rainfall (mm)\nemergence: expected date of plant emergence as a Date object. From Table 1 Savary et al. 2012.\n\nExamples\n\njulia> weather=\njulia> emergence=Dates.Date.(\"2010-07-01\", Dates.DateFormat(\"yyyy-mm-dd\"))\njulia> tungro(weather, emergence)\n\nReturns\n\nA Table with predictions for tungro incidence. Latitude and longitude are included for mapping purposes if they are present in the input weather data.\n\n\n\n\n\n","category":"method"}]
}