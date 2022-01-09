var documenterSearchIndex = {"docs":
[{"location":"man/hlipmodel/","page":"hlipmodel","title":"hlipmodel","text":"Author = \"Adam H. Sparks\"","category":"page"},{"location":"man/hlipmodel/#Modelling-Disease-Epidemics","page":"hlipmodel","title":"Modelling Disease Epidemics","text":"","category":"section"},{"location":"man/hlipmodel/","page":"hlipmodel","title":"hlipmodel","text":"Epicrop a basic function, hlipmodel that can be used to predict unmanaged plant disease epidemics. Predefined values for the EPIRICE model can be found in Savary et al. (2012) for the following diseases of rice: bacterial blight, brown spot, leaf blast, sheath blight, tungro and are included as helper functions that simplify running the model, bacterialblight, brownspot, leafblast, sheathblight, and tungro. Given other parameters, the model framework is capable of modelling other diseases using the methods as described by Savary et al. (2012).","category":"page"},{"location":"man/hlipmodel/","page":"hlipmodel","title":"hlipmodel","text":"hlipmodel(\n    wth,\n    emergence,\n    onset,\n    duration,\n    rhlim,\n    rainlim,\n    H0,\n    I0,\n    RcA,\n    RcT,\n    RcOpt,\n    p,\n    i,\n    Sx,\n    a,\n    RRS,\n    RRG)","category":"page"},{"location":"man/hlipmodel/#Keywords","page":"hlipmodel","title":"Keywords","text":"","category":"section"},{"location":"man/hlipmodel/","page":"hlipmodel","title":"hlipmodel","text":"wth: a data frame of weather on a daily time-step.\nemergence: expected date of plant emergence entered in YYYY-MM-DD format. From Table 1 Savary et al. 2012.\nonset expected number of days until the onset of disease after emergence date. From Table 1 Savary et al. 2012.\nduration: simulation duration (growing season length). From Table 1 Savary et al. 2012.\nrhlim: threshold to decide whether leaves are wet or not (usually 90%). From Table 1 Savary et al. 2012.\nrainlim: threshold to decide whether leaves are wet or not. From Table 1 Savary et al. 2012.\nH0: initial number of plant's healthy sites. From Table 1 Savary et al. 2012.\nI0: initial number of infective sites. From Table 1 Savary et al. 2012.\nRcA: crop age modifier for Rc (the basic infection rate corrected for removals). From Table 1 Savary et al. 2012.\nRcT: temperature modifier for Rc (the basic infection rate corrected for removals). From Table 1 Savary et al. 2012.\nRcOpt: potential basic infection rate corrected for removals. From Table 1 Savary et al. 2012.\ni: duration of infectious period. From Table 1 Savary et al. 2012.\np: duration of latent period. From Table 1 Savary et al. 2012.\nSx: maximum number of sites. From Table 1 Savary et al. 2012.\na: aggregation coefficient. From Table 1 Savary et al. 2012.\nRRS: relative rate of physiological senescence. From Table 1 Savary et al. 2012.\nRRG: relative rate of growth. From Table 1 Savary et al. 2012.","category":"page"},{"location":"man/hlipmodel/#Returns","page":"hlipmodel","title":"Returns","text":"","category":"section"},{"location":"man/hlipmodel/","page":"hlipmodel","title":"hlipmodel","text":"A DataFrame with the model's output with the following fields and values.\nField Value\nsimday Zero indexed day of simulation that was run\ndates Date of simulation\nsites Total number of sites present on day \"x\"\nlatent Number of latent sites present on day \"x\"\ninfectious Number of infectious sites present on day \"x\"\nremoved Number of removed sites present on day \"x\"\nsenesced Number of senesced sites present on day \"x\"\nrateinf Rate of infection\nrtransfer Rate of transfer from latent to infectious sites\nrgrowth Rate of growth of healthy sites\nrsenesced Rate of senescence of healthy sites\ndiseased Number of diseased (latent + infectious + removed) sites\nintensity Number of diseased sites as a proportion of total sites\naudpc Area under the disease progress curve for the whole of simulated season\nlat Latitude value as provided by wth object\nlon Longitude value as provided by wth object","category":"page"},{"location":"man/hlipmodel/#Example-Usage","page":"hlipmodel","title":"Example Usage","text":"","category":"section"},{"location":"man/hlipmodel/","page":"hlipmodel","title":"hlipmodel","text":"Predict an unmanaged epidemic of brown spot at the International Rice Research Institute (IRRI) Zeigler Experiment station in Los Baños, Calabarzon, Philippines. Weather data will be downloaded from the NASA POWER API for use in this example. As the model will run for 120 days, we will download weather data for for 120 days starting on July 01, 2010 and ending on October 28, 2010. To automate this process, you may find the R package, nasapower, useful for downloading weather data in conjunction with RCall.","category":"page"},{"location":"man/hlipmodel/","page":"hlipmodel","title":"hlipmodel","text":"using Epicrop, DataFrames, Dates, CSV, Plots, Downloads\n\n# download weather data from NASA POWER API\nw = CSV.read(Downloads.download(\"https://power.larc.nasa.gov/api/temporal/daily/point?parameters=PRECTOTCORR,T2M,RH2M&community=ag&start=20100701&end=20101028&latitude=14.6774&longitude=121.25562&format=csv&time_standard=utc&user=Epicropjl\"), DataFrame, header = 12)\n\n# rename the columns to match the expected column names for hlipmodel\nrename!(w, :RH2M => :RHUM, :T2M => :TEMP, :PRECTOTCORR => :RAIN)\n\n# add columns for YYYYMMDD and lat/lon\ninsertcols!(w, 1, :YYYYMMDD => range(Date(2010, 06, 30); step = Day(1), length = 120))\ninsertcols!(w, :LAT => 14.6774, :LON => 121.25562)\n\nRcA = [0 0.35; 20 0.35; 40 0.35; 60 0.47; 80 0.59; 100 0.71; 120 1]\n\nRcT = [15 0; 20 0.06; 25 1.0; 30 0.85; 35 0.16; 40 0]\n\nbs = hlipmodel(\n\t\twth = w,\n\t\temergence = \"2010-07-01\",\n\t\tonset = 20,\n\t\tduration = 120,\n\t\trhlim = 90,\n\t\trainlim = 5,\n\t\tH0 = 600,\n\t\tI0 = 1,\n\t\tRcA = RcA,\n\t\tRcT = RcT,\n\t\tRcOpt = 0.61,\n\t\tp = 6,\n\t\ti = 19,\n\t\tSx = 100000,\n\t\ta = 1,\n\t\tRRS = 0.01,\n\t\tRRG = 0.1\n)\n\n# set plotly backend for plots\nplotly()\n\nplot(bs.dates, bs.intensity)","category":"page"},{"location":"man/hlipmodel/","page":"hlipmodel","title":"hlipmodel","text":"(Image: )","category":"page"},{"location":"man/hlipmodel/#References","page":"hlipmodel","title":"References","text":"","category":"section"},{"location":"man/hlipmodel/","page":"hlipmodel","title":"hlipmodel","text":"Serge Savary, Andrew Nelson, Laetitia Willocquet, Ireneo Pangga and Jorrel Aunario (2012). Modeling and mapping potential epidemics of rice diseases globally. Crop Protection, Volume 34, Pages 6-17, ISSN 0261-2194 DOI: 10.1016/j.cropro.2011.11.009.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Author = \"Adam H. Sparks\"\nCurrentModule = Epicrop\nDocTestSetup = quote\n    using Epicrop\nend","category":"page"},{"location":"#Epicrop.jl","page":"Home","title":"Epicrop.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Crop disease modeling in Julia.","category":"page"},{"location":"#Overview","page":"Home","title":"Overview","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Epicrop.jl is a Julia package that can be used to simulate disease epidemics. If you have not yet installed Julia, please follow the instructions for your operating system.","category":"page"},{"location":"","page":"Home","title":"Home","text":"This package provides a Healthy-Latent-Infectious-Postinfectious (HLIP) model for unmanaged plant disease epidemic modelling. Originally this modelling framework was used by specific disease models in EPIRICE to simulate severity of several rice diseases (Savary et al. 2012). Given proper values it can be used with other pathosystems as well.","category":"page"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Epicrop.jl is not yet a registered Julia package, but I hope to have it in good enough condition to register it shortly. Until then you can install it with the following commands:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> using Pkg\n\njulia> Pkg.add(url = \"https://github.com/adamhsparks/Epicrop.jl\")","category":"page"},{"location":"#Usage","page":"Home","title":"Usage","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"You can either specify the parameters directly or use the helper functions to simplify the process of running the model for specific rice diseases as published in Savary et al. (2012).","category":"page"},{"location":"#References","page":"Home","title":"References","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Savary, S., Nelson, A., Willocquet, L., Pangga, I., and Aunario,  J. Modeling and mapping potential epidemics of rice diseases globally. Crop Protection, Volume 34, 2012, Pages 6-17, ISSN 0261-2194 DOI: 10.1016/j.cropro.2011.11.009.","category":"page"},{"location":"man/helperfns/","page":"helper functions","title":"helper functions","text":"Author = \"Adam H. Sparks\"","category":"page"},{"location":"man/helperfns/#Helper-Functions","page":"helper functions","title":"Helper Functions","text":"","category":"section"},{"location":"man/helperfns/","page":"helper functions","title":"helper functions","text":"Quickly and easily model bacterial blight, brown spot, leaf blast, sheath blight, tungro. These functions provide the basic values necessary as published in Savary et al. (2012) to model these diseases with just daily weather data that spans the growing season of interest and growing season start date as values.","category":"page"},{"location":"man/helperfns/#Bacterial-Blight","page":"helper functions","title":"Bacterial Blight","text":"","category":"section"},{"location":"man/helperfns/","page":"helper functions","title":"helper functions","text":"A dynamic mechanistic simulation of bacterial blight disease of rice, causal agent Xanthomonas oryzae pv. oryzae. The model represents site size as 1 rice plant's leaf. Default values for this disease model are derived from Table 2 (Savary et al. 2012).","category":"page"},{"location":"man/helperfns/","page":"helper functions","title":"helper functions","text":"bacterialblight(wth, emergence)","category":"page"},{"location":"man/helperfns/#Brown-Spot","page":"helper functions","title":"Brown Spot","text":"","category":"section"},{"location":"man/helperfns/","page":"helper functions","title":"helper functions","text":"A dynamic mechanistic simulation of rice brown spot, causal agent Cochliobolus miyabeanus. The model represents site size as 10 mm² of a rice plant's leaf. Default values for this disease model are derived from Table 2 (Savary et al. 2012).","category":"page"},{"location":"man/helperfns/","page":"helper functions","title":"helper functions","text":"Note The optimum temperature for brown spot as presented in Table 2 of Savary et al. 2012 has a typo. The optimal value should be 25 °C, not 20 °C as shown. The correct value, 25 °C, is used in this implementation.","category":"page"},{"location":"man/helperfns/","page":"helper functions","title":"helper functions","text":"brownspot(wth, emergence)","category":"page"},{"location":"man/helperfns/#Leaf-Blast","page":"helper functions","title":"Leaf Blast","text":"","category":"section"},{"location":"man/helperfns/","page":"helper functions","title":"helper functions","text":"A dynamic mechanistic simulation of leaf blast disease of rice, causal agent Magnaporthe oryzae. The model represents site size as 45 mm² of a rice plant's leaf.","category":"page"},{"location":"man/helperfns/","page":"helper functions","title":"helper functions","text":"Note The optimum temperature for leaf blast as presented in Table 2 of Savary et al. 2012 has a typo. The optimal value should be 20 °C, not 25 °C as shown. The correct value, 20 °C, is used in this implementation.","category":"page"},{"location":"man/helperfns/","page":"helper functions","title":"helper functions","text":"leafblast(wth, emergence)","category":"page"},{"location":"man/helperfns/#Sheath-Blight","page":"helper functions","title":"Sheath Blight","text":"","category":"section"},{"location":"man/helperfns/","page":"helper functions","title":"helper functions","text":"A dynamic mechanistic simulation of sheath blight disease of rice, causal agent Rhizoctonia solani AG1-1A Kühn. The model represents site size as 1 rice plant's tiller.","category":"page"},{"location":"man/helperfns/","page":"helper functions","title":"helper functions","text":"sheathblight(wth, emergence)","category":"page"},{"location":"man/helperfns/#Tungro","page":"helper functions","title":"Tungro","text":"","category":"section"},{"location":"man/helperfns/","page":"helper functions","title":"helper functions","text":"A dynamic mechanistic simulation of tungro disease of rice, causal agents Rice Tungro Spherical Virus and Rice Tungro Bacilliform Virus. The model represents site size as 1 rice plant. Default values for this disease model are derived from Table 2 (Savary et al. 2012).","category":"page"},{"location":"man/helperfns/","page":"helper functions","title":"helper functions","text":"tungro(wth, emergence)","category":"page"},{"location":"man/helperfns/#References","page":"helper functions","title":"References","text":"","category":"section"},{"location":"man/helperfns/","page":"helper functions","title":"helper functions","text":"Savary, S., Nelson, A., Willocquet, L., Pangga, I., and Aunario,  J. Modeling and mapping potential epidemics of rice diseases globally. Crop Protection, Volume 34, 2012, Pages 6-17, ISSN 0261-2194 DOI: 10.1016/j.cropro.2011.11.009.","category":"page"}]
}