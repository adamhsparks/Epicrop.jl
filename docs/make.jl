using Documenter
using Epicrop

makedocs(
    sitename = "Epicrop",
    format = Documenter.HTML(),
    modules = [Epicrop]
)

deploydocs(
    repo = "https://github.com/adamhsparks/Epicrop.jl",
    devbranch = "main"
)
