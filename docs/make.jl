using CSV
using DataFrames
using Dates
using Documenter
using Epicrop
using Plots

makedocs(
    sitename = "Epicrop.jl",
    format = Documenter.HTML(),
    modules = [Epicrop],
    doctest = true,
    pages = Any[
        "Home" => "index.md",
        "Manual" => Any[
            "hlipmodel" => "man/hlipmodel.md",
            "helper functions" => "man/helperfns.md"
        ]
    ]
)

deploydocs(
    repo = "github.com/adamhsparks/Epicrop.jl.git",
    devbranch = "main"
)
