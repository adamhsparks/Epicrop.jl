using Documenter
using Epicrop

makedocs(
    sitename = "Epicrop.jl",
    format = Documenter.HTML(),
    modules = [Epicrop]
)

deploydocs(
    repo = "github.com/adamhsparks/Epicrop.jl",
    devbranch = "main"
)
