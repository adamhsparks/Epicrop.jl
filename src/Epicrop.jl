
module Epicrop

using CSV
using DataFrames
using Dates
using Interpolations

include("hlipmodel.jl")
include("helpers.jl")

export hlipmodel,
    bacterialblight,
    brownspot,
    leafblast,
    sheathblight,
    tungro

end # module
