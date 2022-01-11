using Epicrop
using Test
using DataFrames
using Dates
using CSV
using Downloads

@testset "hlipmodel tests" begin
    # sometimes the POWER data download fails, this sets the timeout to 60 seconds instead of 20
    downloader = Downloads.Downloader()
    downloader.easy_hook = (easy, info) -> Downloads.Curl.setopt(easy, Downloads.Curl.CURLOPT_LOW_SPEED_TIME, 120)

    w = CSV.read(
        Downloads.download(
            "https://power.larc.nasa.gov/api/temporal/daily/point?parameters=PRECTOTCORR,T2M,RH2M&community=ag&start=20100701&end=20101028&latitude=14.6774&longitude=121.25562&format=csv&time_standard=utc&user=Epicropjl",
            downloader=downloader),
            DataFrame, header = 12)

    # rename the columns to match the expected column names for hlipmodel
    rename!(w, :RH2M => :RHUM, :T2M => :TEMP, :PRECTOTCORR => :RAIN)

    emergence = Dates.Date("2010-07-01", Dates.DateFormat("yyyy-mm-dd"))

    # add columns for YYYYMMDD and lat/lon
    insertcols!(w, 1, :YYYYMMDD => range(Date(2010, 06, 30); step=Day(1), length=120))
    insertcols!(w, :LAT => 14.6774, :LON => 121.25562)

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

    @test nrow(bs) == 120
    @test ncol(bs) == 16
    @test isapprox(bs[120, 13], 0.0843, atol = 0.0001)

# check for stop if supplied args are inappropiate
@testset "emergence is a Date object" begin
    @test_throws DomainError hlipmodel(
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
end

@testset "weather data align with duration and emergence" begin
    @test_throws DomainError hlipmodel(
		wth = w,
		emergence = Dates.Date("2000-07-01", Dates.DateFormat("yyyy-mm-dd")),
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
end

@testset "H0 must be > 0" begin
    @test_throws DomainError hlipmodel(
		wth = w,
		emergence = emergence,
		onset = 20,
		duration = 120,
		rhlim = 90,
		rainlim = 5,
		H0 = -600,
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
end

@testset "I0 must be > 0" begin
    @test_throws DomainError hlipmodel(
		wth = w,
		emergence = emergence,
		onset = 20,
		duration = 120,
		rhlim = 90,
		rainlim = 5,
		H0 = 600,
		I0 = -1,
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
end

    # test helper functions for individual rice diseases
    bbmodel = bacterialblight(wth = w, emergence = emergence)
    @test nrow(bbmodel) == 120
    @test ncol(bbmodel) == 16
    @test isapprox(bbmodel[120, 13], 0.45708, atol = 0.0001)

    bsmodel = brownspot(wth = w, emergence = emergence)
    @test nrow(bsmodel) == 120
    @test ncol(bsmodel) == 16
    @test isapprox(bsmodel[120, 13], 0.0843, atol = 0.0001)

    lbmodel = leafblast(wth = w, emergence = emergence)
    @test nrow(lbmodel) == 120
    @test ncol(lbmodel) == 16
    @test isapprox(lbmodel[120, 13], 5.81269e-6, atol = 0.0001)

    sbmodel = sheathblight(wth = w, emergence = emergence)
    @test nrow(sbmodel) == 120
    @test ncol(sbmodel) == 16
    @test isapprox(sbmodel[120, 13], 0.78539, atol = 0.0001)

    tmodel = tungro(wth = w, emergence = emergence)
    @test nrow(tmodel) == 120
    @test ncol(tmodel) == 16
    @test isapprox(tmodel[120, 13], 0.07564, atol = 0.0001)

end
