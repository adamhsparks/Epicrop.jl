
using DataFrames
using DelimitedFiles
using Epicrop
using Test

@testset "hlipmodel tests" begin
    data, header = readdlm(joinpath(
                                    dirname(pathof(Epicrop)),
                                        "..", "docs", "src", "assets",
                                            "POWER_data_LB_PHI_2000_ws.csv"),
                                    ',', header=true)

    w = DataFrame(data, vec(header))

    emergence = "2000-07-01"

    RcA = [0 0.35;
            20 0.35;
            40 0.35;
            60 0.47;
            80 0.59;
            100 0.71;
            120 1.0]
    RcT = [15 0.0;
            20 0.06;
            25 1.0;
            30 0.85;
            35 0.16;
            40 0.0]

    bs = hlipmodel(;
        wth=w,
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
        RRG=0.1
    )

    @test nrow(bs) == 120
    @test ncol(bs) == 16
    @test isapprox(bs[120, 13], 0.03413, atol=0.0001)

    @testset "weather data align with duration and emergence" begin
        @test_throws DomainError hlipmodel(;
            wth=w,
            emergence="2001-07-01",
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
            RRG=0.1
        )
    end

    @testset "H0 must be > 0" begin
        @test_throws DomainError hlipmodel(;
            wth=w,
            emergence=emergence,
            onset=20,
            duration=120,
            rhlim=90,
            rainlim=5,
            H0=-600,
            I0=1,
            RcA=RcA,
            RcT=RcT,
            RcOpt=0.61,
            p=6,
            i=19,
            Sx=100000,
            a=1.0,
            RRS=0.01,
            RRG=0.1
        )
    end

    @testset "I0 must be > 0" begin
        @test_throws DomainError hlipmodel(;
            wth=w,
            emergence=emergence,
            onset=20,
            duration=120,
            rhlim=90,
            rainlim=5,
            H0=600,
            I0=-1,
            RcA=RcA,
            RcT=RcT,
            RcOpt=0.61,
            p=6,
            i=19,
            Sx=100000,
            a=1.0,
            RRS=0.01,
            RRG=0.1
        )
    end

    # test helper functions for individual rice diseases
    bbmodel = bacterialblight(w, emergence)
    @test nrow(bbmodel) == 120
    @test ncol(bbmodel) == 16
    @test isapprox(bbmodel[120, 13], 0.4715, atol=0.0001)

    bsmodel = brownspot(w, emergence)
    @test nrow(bsmodel) == 120
    @test ncol(bsmodel) == 16
    @test isapprox(bsmodel[120, 13], 0.0341, atol=0.0001)

    lbmodel = leafblast(w, emergence)
    @test nrow(lbmodel) == 120
    @test ncol(lbmodel) == 16
    @test isapprox(lbmodel[120, 13], 5.81269e-6, atol=0.0001)

    sbmodel = sheathblight(w, emergence)
    @test nrow(sbmodel) == 120
    @test ncol(sbmodel) == 16
    @test isapprox(sbmodel[120, 13], 0.7726, atol=0.0001)

    tmodel = tungro(w, emergence)
    @test nrow(tmodel) == 120
    @test ncol(tmodel) == 16
    @test isapprox(tmodel[120, 13], 0.0585, atol=0.0001)

end
