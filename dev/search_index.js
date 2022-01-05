var documenterSearchIndex = {"docs":
[{"location":"man/hlipmodel/","page":"hlipmodel","title":"hlipmodel","text":"Author = \"Adam H. Sparks\"","category":"page"},{"location":"man/hlipmodel/#Modelling-Disease-Epidemics","page":"hlipmodel","title":"Modelling Disease Epidemics","text":"","category":"section"},{"location":"man/hlipmodel/","page":"hlipmodel","title":"hlipmodel","text":"Epicrop supplies one function, hlipmodel that can be used to predict unmanaged plant disease epidemics. Predefined values for the EPIRICE model can be found in Savary et al. (2012) for the following diseases of rice: bacterial blight, brown spot, leaf blast, sheath blight, tungro. Given other parameters, the model framework is capable of modelling other diseases using the methods as described by Savary et al. (2012).","category":"page"},{"location":"man/hlipmodel/#Example-Usage","page":"hlipmodel","title":"Example Usage","text":"","category":"section"},{"location":"man/hlipmodel/","page":"hlipmodel","title":"hlipmodel","text":"Predict an unmanaged epidemic of brown spot at the International Rice Research Institute (IRRI) Zeigler Experiment station in Los Baños, Calabarzon, Philippines. Weather data will be downloaded from the NASA POWER API for use in this example. As the model will run for 120 days, we will download weather data for for 120 days starting on July 01, 2010 and ending on October 28, 2010. To automate this process, you may find the R package, nasapower, useful for downloading weather data in conjunction with RCall.","category":"page"},{"location":"man/hlipmodel/","page":"hlipmodel","title":"hlipmodel","text":"using Epicrop, DataFrames, Dates, CSV\n\nw = CSV.read(download(\"https://power.larc.nasa.gov/api/temporal/daily/point?parameters=PRECTOTCORR,T2M,RH2M&community=ag&start=20100701&end=20101028&latitude=14.6774&longitude=121.25562&format=csv&time_standard=utc&user=Epicropjl\"), DataFrame, header = 12)\n\n# rename the columns to match the expected column names for hlipmodel\nrename!(w, :RH2M => :RHUM, :T2M => :TEMP, :PRECTOTCORR => :RAIN)\n\n# add columns for YYYYMMDD and lat/lon\ninsertcols!(w, 1, :YYYYMMDD => range(Date(2010, 06, 30); step=Day(1), length=120))\ninsertcols!(w, :LAT => 14.6774, :LON => 121.25562)\n\nRcA = [0 0.35; 20 0.35; 40 0.35; 60 0.47; 80 0.59; 100 0.71; 120 1]\n\nRcT = [15 0; 20 0.06; 25 1.0; 30 0.85; 35 0.16; 40 0]\n\nbs = hlipmodel(\n\t\twth = w,\n\t\temergence = \"2010-07-01\",\n\t\tonset = 20,\n\t\tduration = 120,\n\t\trhlim = 90,\n\t\trainlim = 5,\n\t\tH0 = 600,\n\t\tI0 = 1,\n\t\tRcA = RcA,\n\t\tRcT = RcT,\n\t\tRcOpt = 0.61,\n\t\tp = 6,\n\t\ti = 19,\n\t\tSx = 100000,\n\t\ta = 1,\n\t\tRRS = 0.01,\n\t\tRRG = 0.1\n)","category":"page"},{"location":"man/hlipmodel/#References","page":"hlipmodel","title":"References","text":"","category":"section"},{"location":"man/hlipmodel/","page":"hlipmodel","title":"hlipmodel","text":"Serge Savary, Andrew Nelson, Laetitia Willocquet, Ireneo Pangga and Jorrel Aunario (2012). Modeling and mapping potential epidemics of rice diseases globally. Crop Protection, Volume 34, Pages 6-17, ISSN 0261-2194 DOI: 10.1016/j.cropro.2011.11.009.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Author = \"Adam H. Sparks\"\nCurrentModule = Epicrop\nDocTestSetup = quote\n    using Epicrop\nend","category":"page"},{"location":"#Epicrop.jl","page":"Home","title":"Epicrop.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Crop disease modeling in Julia.","category":"page"},{"location":"#Overview","page":"Home","title":"Overview","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Epicrop.jl is a Julia package that can be used to simulate disease epidemics. If you have not yet installed Julia, please follow the instructions for your operating system.","category":"page"},{"location":"","page":"Home","title":"Home","text":"This package provides a Healthy-Latent-Infectious-Postinfectious (HLIP) model for unmanaged plant disease epidemic modelling. Originally this modelling framework was used by specific disease models in EPIRICE to simulate severity of several rice diseases (Savary et al. 2012). Given proper values it can be used with other pathosystems as well.","category":"page"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Epicrop.jl is not yet a registered Julia package, but I hope to have it in good enough condition to register it shortly. Until then you can install it with the following commands:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> using Pkg\n\njulia> Pkg.add(url = \"https://github.com/adamhsparks/Epicrop.jl\")","category":"page"}]
}
