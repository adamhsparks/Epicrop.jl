module Epicrop

# Use the README as the module docs
@doc let
    path = joinpath(dirname(@__DIR__), "README.md")
    include_dependency(path)
    read(path, String)

using DataFrames
using Dates
using Interpolations

include("seir.jl")

export run_seir_model

#re-exports from DataFrames.jl
export DataFrame

end # module
