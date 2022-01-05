using Documenter, Epicrop, DataFrames, Dates, CSV, Plots

makedocs(
    sitename = "Epicrop.jl",
    format = Documenter.HTML(),
    modules = [Epicrop],
    doctest = true,
    pages = Any[
        "Home" => "index.md",
        "Manual" => Any[
            "hlipmodel" => "man/hlipmodel.md"
        ]
    ]
)

deploydocs(
    repo = "github.com/adamhsparks/Epicrop.jl.git",
    devbranch = "main"
)
