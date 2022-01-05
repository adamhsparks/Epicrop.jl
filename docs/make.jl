using Documenter
using Epicrop

makedocs(
    sitename = "Epicrop.jl",
    format = Documenter.HTML(),
    modules = [Epicrop],
    doctest = true
)

deploydocs(
    repo = "github.com/adamhsparks/Epicrop.jl.git",
    devbranch = "main"
)
