using Documenter
using Epicrop

makedocs(
    sitename = "Epicrop",
    format = Documenter.HTML(),
    modules = [Epicrop]
)

deploydocs(
    repo = "github.com/adamhsparks/Epicrop.jl.git",
    devbranch = "main"
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "https://github.com/adamhsparks/Epicrop.jl"
)
