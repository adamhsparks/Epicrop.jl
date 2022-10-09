var documenterSearchIndex = {"docs":
[{"location":"","page":"Epicrop","title":"Epicrop","text":"CurrentModule = Epicrop\nAuthor = \"Adam H. Sparks\"","category":"page"},{"location":"#Epicrop","page":"Epicrop","title":"Epicrop","text":"","category":"section"},{"location":"","page":"Epicrop","title":"Epicrop","text":"Documentation for Epicrop.","category":"page"},{"location":"","page":"Epicrop","title":"Epicrop","text":"","category":"page"},{"location":"#Helper-Functions","page":"Epicrop","title":"Helper Functions","text":"","category":"section"},{"location":"","page":"Epicrop","title":"Epicrop","text":"Quickly and easily model bacterial blight, brown spot, leaf blast, sheath blight and tungro. These functions provide the basic values necessary as published in Savary et al. (2012) to model these diseases with just daily weather data that spans the growing season of interest and growing season start date as values.","category":"page"},{"location":"#Bacterial-Blight","page":"Epicrop","title":"Bacterial Blight","text":"","category":"section"},{"location":"","page":"Epicrop","title":"Epicrop","text":"A dynamic mechanistic simulation of bacterial blight disease of rice, causal agent Xanthomonas oryzae pv. oryzae. The model represents site size as 1 rice plant's leaf. Default values for this disease model are derived from Table 2 (Savary et al. 2012).","category":"page"},{"location":"","page":"Epicrop","title":"Epicrop","text":"bacterialblight","category":"page"},{"location":"#Epicrop.bacterialblight","page":"Epicrop","title":"Epicrop.bacterialblight","text":"bacterialblight(wth::DataFrames.AbstractDataFrame, emergence::Dates.Date)\n\nRun a healthy-latent-infectious-postinfectious (HLIP) model using weather data and optimal curve values for rice bacterial blight Xanthomonas oryzae pv. oryzae.\n\nInput\n\nwth: DataFrames.DataFrame a data frame of weather on a daily time-step containing data with the following field names.\nYYYYMMDD: Date as Year Month Day, YYYY-MM-DD, (ISO8601) format either as an AbstractString or Dates.Date\nDOY: Consecutive day of year, commonly called \"Julian date\" as an Int64\nTEMP: Mean daily temperature (°C) as aa Float64\nRHUM: Mean daily relative humidity (%) as a Float64\nRAIN: Mean daily rainfall (mm) as a Float64\nemergence: expected date of plant emergence as an AbstractString. From Table 1 Savary et al. 2012.\nduration: duration of the growing season in days as an Int64 value, defaults to 120 as in Savary et al. 2012.\n\nOutput\n\nA DataFrames.DataFrame with predictions for bacterial blight severity. Latitude and longitude are included for mapping purposes if they are present in the input weather data. See hlipmodel for a full description of the return values.\n\nNotes\n\nThis is one of a family of helper functions. Also see brownspot, leafblast, sheathblight and tungro.\n\nExamples\n\njulia> using Epicrop\n\njulia> using DelimitedFiles\n\njulia> using DataFrames\n\njulia> data, header = readdlm(joinpath(\n                                dirname(pathof(Epicrop)),\n                                    \"..\", \"docs\", \"src\", \"assets\",\n                                        \"POWER_data_LB_PHI_2000_ws.csv\"),\n                                ',', header=true)\n\njulia> w = DataFrame(data, vec(header))\n\njulia> emergence = \"2000-07-01\"\n\njulia> bacterialblight(w, emergence)\n\n\n\n\n\n","category":"function"},{"location":"#Brown-Spot","page":"Epicrop","title":"Brown Spot","text":"","category":"section"},{"location":"","page":"Epicrop","title":"Epicrop","text":"A dynamic mechanistic simulation of rice brown spot, causal agent Cochliobolus miyabeanus. The model represents site size as 10 mm² of a rice plant's leaf. Default values for this disease model are derived from Table 2 (Savary et al. 2012).","category":"page"},{"location":"","page":"Epicrop","title":"Epicrop","text":"Note The optimum temperature for brown spot as presented in Table 2 of Savary et al. 2012 has a typo. The optimal value should be 25 °C, not 20 °C as shown. The correct value, 25 °C, is used in this implementation.","category":"page"},{"location":"","page":"Epicrop","title":"Epicrop","text":"brownspot","category":"page"},{"location":"#Epicrop.brownspot","page":"Epicrop","title":"Epicrop.brownspot","text":"brownspot(wth::DataFrames.AbstractDataFrame, emergence::Dates:Date)\n\nRun a healthy-latent-infectious-postinfectious (HLIP) model using weather data and optimal curve values for rice brown spot caused by Cochliobolus miyabeanus.\n\nInput\n\nwth: DataFrames.DataFrame a data frame of weather on a daily time-step containing data with the following field names.\nYYYYMMDD: Date as Year Month Day, YYYY-MM-DD, (ISO8601) format either as an AbstractString or Dates.Date\nDOY: Consecutive day of year, commonly called \"Julian date\" as an Int64\nTEMP: Mean daily temperature (°C) as aa Float64\nRHUM: Mean daily relative humidity (%) as a Float64\nRAIN: Mean daily rainfall (mm) as a Float64\nemergence: expected date of plant emergence as an AbstractString. From Table 1 Savary et al. 2012.\nduration: duration of the growing season in days as an Int64 value, defaults to 120 as in Savary et al. 2012.\n\nOutput\n\nA DataFrames.DataFrame with predictions for brown spot severity. Latitude and longitude are included for mapping purposes if they are present in the input weather data. See hlipmodel for a full description of the return values.\n\nThis function is one of a family of helper functions. Also see bacterialblight, leafblast, sheathblight and tungro.\n\nExamples\n\njulia> using Epicrop\n\njulia> using DelimitedFiles\n\njulia> using DataFrames\n\njulia> data, header = readdlm(joinpath(\n                                dirname(pathof(Epicrop)),\n                                    \"..\", \"docs\", \"src\", \"assets\",\n                                        \"POWER_data_LB_PHI_2000_ws.csv\"),\n                                ',', header=true)\n\njulia> w = DataFrame(data, vec(header))\n\njulia> emergence = \"2000-07-01\"\n\njulia> brownspot(w, emergence)\n\n\n\n\n\n","category":"function"},{"location":"#Leaf-Blast","page":"Epicrop","title":"Leaf Blast","text":"","category":"section"},{"location":"","page":"Epicrop","title":"Epicrop","text":"A dynamic mechanistic simulation of leaf blast disease of rice, causal agent Magnaporthe oryzae. The model represents site size as 45 mm² of a rice plant's leaf.","category":"page"},{"location":"","page":"Epicrop","title":"Epicrop","text":"Note The optimum temperature for leaf blast as presented in Table 2 of Savary et al. 2012 has a typo. The optimal value should be 20 °C, not 25 °C as shown. The correct value, 20 °C, is used in this implementation.","category":"page"},{"location":"","page":"Epicrop","title":"Epicrop","text":"leafblast","category":"page"},{"location":"#Epicrop.leafblast","page":"Epicrop","title":"Epicrop.leafblast","text":"leafblast(wth::DataFrames.AbstractDataFrame, emergence::Dates.Date)\n\nRun a healthy-latent-infectious-postinfectious (HLIP) model using weather data and optimal curve values for rice leaf blast caused by Magnaporthe oryzae.\n\nInput\n\nwth: DataFrames.DataFrame a data frame of weather on a daily time-step containing data with the following field names.\nYYYYMMDD: Date as Year Month Day, YYYY-MM-DD, (ISO8601) format either as an AbstractString or Dates.Date\nDOY: Consecutive day of year, commonly called \"Julian date\" as an Int64\nTEMP: Mean daily temperature (°C) as aa Float64\nRHUM: Mean daily relative humidity (%) as a Float64\nRAIN: Mean daily rainfall (mm) as a Float64\nemergence: expected date of plant emergence as an AbstractString. From Table 1 Savary et al. 2012.\nduration: duration of the growing season in days as an Int64 value, defaults to 120 as in Savary et al. 2012.\n\nOutput\n\nA DataFrames.DataFrame with predictions for leaf blast severity. Latitude and longitude are included for mapping purposes if they are present in the input weather data. See hlipmodel for a full description of the return values.\n\nNotes\n\nThis is one of a family of helper functions. Also see bacterialblight, brownspot, sheathblight and tungro.\n\nExamples\n\njulia> using Epicrop\n\njulia> using DelimitedFiles\n\njulia> using DataFrames\n\njulia> data, header = readdlm(joinpath(\n                                dirname(pathof(Epicrop)),\n                                    \"..\", \"docs\", \"src\", \"assets\",\n                                        \"POWER_data_LB_PHI_2000_ws.csv\"),\n                                ',', header=true)\n\njulia> w = DataFrame(data, vec(header))\n\njulia> emergence = \"2000-07-01\"\n\njulia> leafblast(w, emergence)\n\n\n\n\n\n","category":"function"},{"location":"#Sheath-Blight","page":"Epicrop","title":"Sheath Blight","text":"","category":"section"},{"location":"","page":"Epicrop","title":"Epicrop","text":"A dynamic mechanistic simulation of sheath blight disease of rice, causal agent Rhizoctonia solani AG1-1A Kühn. The model represents site size as 1 rice plant's tiller.","category":"page"},{"location":"","page":"Epicrop","title":"Epicrop","text":"sheathblight","category":"page"},{"location":"#Epicrop.sheathblight","page":"Epicrop","title":"Epicrop.sheathblight","text":"sheathblight(wth::DataFrames.AbstractDataFrame, emergence::Dates.Date)\n\nRun a healthy-latent-infectious-postinfectious (HLIP) model using weather data and optimal curve values for rice sheath blight caused by Rhizoctonia solani AG1-1A Kühn.\n\nInput\n\nwth: DataFrames.DataFrame a data frame of weather on a daily time-step containing data with the following field names.\nYYYYMMDD: Date as Year Month Day, YYYY-MM-DD, (ISO8601) format either as an AbstractString or Dates.Date\nDOY: Consecutive day of year, commonly called \"Julian date\" as an Int64\nTEMP: Mean daily temperature (°C) as aa Float64\nRHUM: Mean daily relative humidity (%) as a Float64\nRAIN: Mean daily rainfall (mm) as a Float64\nemergence: expected date of plant emergence as an AbstractString. From Table 1 Savary et al. 2012.\nduration: duration of the growing season in days as an Int64 value, defaults to 120 as in Savary et al. 2012.\n\nOutput\n\nA DataFrames.DataFrame with predictions for sheath blight severity. Latitude and longitude are included for mapping purposes if they are present in the input weather data. See hlipmodel for a full description of the return values.\n\nNotes\n\nThis is one of a family of helper functions. Also see bacterialblight, brownspot, leafblast and tungro.\n\nExamples\n\njulia> using Epicrop\n\njulia> using DelimitedFiles\n\njulia> using DataFrames\n\njulia> data, header = readdlm(joinpath(\n                                dirname(pathof(Epicrop)),\n                                    \"..\", \"docs\", \"src\", \"assets\",\n                                        \"POWER_data_LB_PHI_2000_ws.csv\"),\n                                ',', header=true)\n\njulia> w = DataFrame(data, vec(header))\n\njulia> emergence = \"2000-07-01\"\n\njulia> sheathblight(w, emergence)\n\n\n\n\n\n","category":"function"},{"location":"#Tungro","page":"Epicrop","title":"Tungro","text":"","category":"section"},{"location":"","page":"Epicrop","title":"Epicrop","text":"A dynamic mechanistic simulation of tungro disease of rice, causal agents Rice Tungro Spherical Virus and Rice Tungro Bacilliform Virus. The model represents site size as 1 rice plant. Default values for this disease model are derived from Table 2 (Savary et al. 2012).","category":"page"},{"location":"","page":"Epicrop","title":"Epicrop","text":"tungro","category":"page"},{"location":"#Epicrop.tungro","page":"Epicrop","title":"Epicrop.tungro","text":"tungro(wth::DataFrames.AbstractDataFrame, emergence::Dates.Date)\n\nRun a healthy-latent-infectious-postinfectious (HLIP) model using weather data and optimal curve values for rice tungro disease caused by Rice Tungro Spherical and Rice Tungro Bacilliform viruses.\n\nInput\n\nwth: DataFrames.DataFrame a data frame of weather on a daily time-step containing data with the following field names.\nYYYYMMDD: Date as Year Month Day, YYYY-MM-DD, (ISO8601) format either as an AbstractString or Dates.Date\nDOY: Consecutive day of year, commonly called \"Julian date\" as an Int64\nTEMP: Mean daily temperature (°C) as aa Float64\nRHUM: Mean daily relative humidity (%) as a Float64\nRAIN: Mean daily rainfall (mm) as a Float64\nemergence: expected date of plant emergence as an AbstractString. From Table 1 Savary et al. 2012.\nduration: duration of the growing season in days as an Int64 value, defaults to 120 as in Savary et al. 2012.\n\nOutput\n\nA DataFrames.DataFrame with predictions for tungro incidence. Latitude and longitude are included for mapping purposes if they are present in the input weather data. See hlipmodel for a full description of the return values.\n\nNotes\n\nThis is one of a family of helper functions. Also see bacterialblight, brownspot, leafblast and sheathblight.\n\nExamples\n\njulia> using Epicrop\n\njulia> using DelimitedFiles\n\njulia> using DataFrames\n\njulia> data, header = readdlm(joinpath(\n                                dirname(pathof(Epicrop)),\n                                    \"..\", \"docs\", \"src\", \"assets\",\n                                        \"POWER_data_LB_PHI_2000_ws.csv\"),\n                                ',', header=true)\n\njulia> w = DataFrame(data, vec(header))\n\njulia> emergence = \"2000-07-01\"\n\njulia> tungro(w, emergence)\n\n# output\n\n\n\n\n\n","category":"function"},{"location":"#Advanced-Use","page":"Epicrop","title":"Advanced Use","text":"","category":"section"},{"location":"","page":"Epicrop","title":"Epicrop","text":"Epicrop.jl provides a basic function, hlipmodel, that can be used to predict unmanaged plant disease epidemics given the proper input. Predefined values for the EPIRICE model can be found in Savary et al. (2012) for the following diseases of rice: bacterial blight, brown spot, leaf blast, sheath blight and tungro and are included as helper functions, bacterialblight, brownspot, leafblast, sheathblight, and tungro, that simplify using the model's interface. Given other parameters, the model framework is capable of modelling other diseases using the methods as described by Savary et al. (2012).","category":"page"},{"location":"","page":"Epicrop","title":"Epicrop","text":"hlipmodel","category":"page"},{"location":"#Epicrop.hlipmodel","page":"Epicrop","title":"Epicrop.hlipmodel","text":"hlipmodel(;\nwth::DataFrames.AbstractDataFrame,\nrhlim::Int64,\nrainlim::Int64,\nH0::Int64,\nI0::Int64,\nRcA::Matrix{Float64},\nRcT::Matrix{Float64},\nRcOpt::Float64,\np::Int64,\ni::Int64,\nSx::Int64,\na::Float64,\nRRS::Float64,\nRRG::Float64,\n)\n\nRun a healthy-latent-infectious-postinfectious (HLIP) model using weather data and optimal curve values for respective crop diseases.\n\nInput\n\nwth: a Matrix{Any} of weather on a daily time-step containing data with the following values.\nYYYYMMDD: Date as in ISO8601 format, i.e., YYYY-MM-DD\nDOY:  Consecutive day of year, commonly called \"Julian date\"\nTEMP: Mean daily temperature (°C)\nRHUM: Mean daily relative humidity (%)\nRAIN: Mean daily rainfall (mm)\nemergence: Dates.Date expected date of plant emergence entered as a Dates.Date object. From Table 1 Savary et al. 2012.\nonset: Integer,  expected number of days until the onset of disease after emergence date. From Table 1 Savary et al. 2012.\nduration: Integer,  simulation duration (growing season length). From Table 1 Savary et al. 2012.\nrhlim: Integer, threshold to decide whether leaves are wet or not (usually 90%). From Table 1 Savary et al. 2012.\nrainlim: Integer, threshold to decide whether leaves are wet or not. From Table 1 Savary et al. 2012.\nH0: Integer, initial number of plant's healthy sites. From Table 1 Savary et al. 2012.\nI0: Integer, initial number of infective sites. From Table 1 Savary et al. 2012.\nRcA: Matrix{Float64}, crop age modifier for Rc (the basic infection rate corrected for removals). From Table 1 Savary et al. 2012.\nRcT: Matrix{Float64}, temperature modifier for Rc (the basic infection rate corrected for removals). From Table 1 Savary et al. 2012.\nRcOpt: Float64, potential basic infection rate corrected for removals. From Table 1 Savary et al. 2012.\np: Integer, duration of latent period. From Table 1 Savary et al. 2012.\nSx: Integer, maximum number of sites. From Table 1 Savary et al. 2012.\na: Float64, aggregation coefficient. From Table 1 Savary et al. 2012.\nRRS: Float64, relative rate of physiological senescence. From Table 1 Savary et al. 2012.\nRRG: Float64, relative rate of growth. From Table 1 Savary et al. 2012.\n\nOutput\n\nA Matrix{Any} with the model's output with the following columns and values.\n\nsimday: Zero indexed day of simulation that was run.\ndates:  Date of simulation.\nsites: Total number of sites present on day \"x\".\nlatent: Number of latent sites present on day \"x\".\ninfectious: Number of infectious sites present on day \"x\".\nremoved: Number of removed sites present on day \"x\".\nsenesced: Number of senesced sites present on day \"x\".\nrateinf: Rate of infection.\nrtransfer: Rate of transfer from latent to infectious sites.\nrgrowth: Rate of growth of healthy sites.\nrsenesced: Rate of senescence of healthy sites.\ndiseased: Number of diseased (latent + infectious + removed) sites.\nintensity: Number of diseased sites as a proportion of total sites.\naudpc: Area under the disease progress curve for the whole of simulated season.\nlat: Latitude value as provided by wth object.\nlon: Longitude value as provided by wth object.\n\nExamples\n\nUsing data downloaded and saved from NASA POWER for Los Baños, Calabarzon, PH.\n\njulia> using Epicrop\n\njulia> using CSV\n\njulia> using DelimitedFiles\n\njulia> using DataFrames\n\njulia> data, header = readdlm(joinpath(\n                                dirname(pathof(Epicrop)),\n                                    \"..\", \"docs\", \"src\", \"assets\",\n                                        \"POWER_data_LB_PHI_2000_ws.csv\"),\n                                ',', header=true)\n\njulia> w = DataFrame(data, vec(header))\n\njulia> emergence = \"2000-07-01\"\n\njulia> RcA = [0 0.35;\n            20 0.35;\n            40 0.35;\n            60 0.47;\n            80 0.59;\n            100 0.71;\n            120 1.0]\n\njulia> RcT = [15 0.0;\n            20 0.06;\n            25 1.0;\n            30 0.85;\n            35 0.16;\n            40 0.0]\n\njulia> bs = hlipmodel(;\n        wth=w,\n        emergence=emergence,\n        onset=20,\n        duration=120,\n        rhlim=90,\n        rainlim=5,\n        H0=600,\n        I0=1,\n        RcA=RcA,\n        RcT=RcT,\n        RcOpt=0.61,\n        p=6,\n        i=19,\n        Sx=100000,\n        a=1.0,\n        RRS=0.01,\n        RRG=0.1\n)\n\n# output\n\n\n\n\n\n\n","category":"function"},{"location":"#References","page":"Epicrop","title":"References","text":"","category":"section"},{"location":"","page":"Epicrop","title":"Epicrop","text":"Savary, S., Nelson, A., Willocquet, L., Pangga, I., and Aunario,  J. Modeling and mapping potential epidemics of rice diseases globally. Crop Protection, Volume 34, 2012, Pages 6-17, ISSN 0261-2194 DOI: 10.1016/j.cropro.2011.11.009.","category":"page"},{"location":"assets/README/#Weather-Data-Source","page":"Weather Data Source","title":"Weather Data Source","text":"","category":"section"},{"location":"assets/README/","page":"Weather Data Source","title":"Weather Data Source","text":"These data were obtained from the NASA Langley Research Center (LaRC) POWER Project funded through the NASA Earth Science/Applied Science Program using the contributed R package, nasapower (Sparks 2018).","category":"page"},{"location":"assets/README/","page":"Weather Data Source","title":"Weather Data Source","text":"See https://power.larc.nasa.gov for more details.","category":"page"},{"location":"assets/README/#References","page":"Weather Data Source","title":"References","text":"","category":"section"},{"location":"assets/README/","page":"Weather Data Source","title":"Weather Data Source","text":"Sparks, Adam (2018). nasapower: A NASA POWER Global Meteorology, Surface Solar Energy and Climatology Data Client for R. Journal of Open Source Software, 3(30), 1035, https://doi.org/10.21105/joss.01035","category":"page"}]
}
