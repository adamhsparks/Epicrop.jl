using Epicrop
using Documenter

DocMeta.setdocmeta!(Epicrop, :DocTestSetup, :(using Epicrop); recursive=true)

makedocs(;
    modules=[Epicrop],
    authors="Adam H. Sparks",
    repo="https://github.com/adamhsparks/Epicrop.jl/blob/{commit}{path}#{line}",
    sitename="Epicrop.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://adamhsparks.github.io/Epicrop.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/adamhsparks/Epicrop.jl",
    devbranch="main",
)
