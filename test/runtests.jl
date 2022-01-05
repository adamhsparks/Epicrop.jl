using Epicrop
using DataFrames
using Dates
using CSV

@testset "hlipmodel tests" begin
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

    @test nrow(bs) == 120
    @test ncol(bs) == 15
    @test bs[120, 13] == 0.0843183
end
