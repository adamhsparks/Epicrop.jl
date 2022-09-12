push!(LOAD_PATH, "../src/")

using Documenter
using Epicrop

makedocs(;
    source="src",
    build="build",
    clean=true,
    doctest=true,
    format=Documenter.HTML(
        #assets = ["assets/favicon.ico"],
        highlights = ["yaml"],
        ansicolor = true,
    ),
    modules=[Epicrop],
    sitename = "Epicrop.jl",
    authors = "Adam H. Sparks",
)
