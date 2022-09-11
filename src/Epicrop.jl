
module Epicrop

include("hlipmodel.jl")
include("helpers.jl")

using DataFrames, Dates, Interpolations

export hlipmodel,
    bacterialblight,
    brownspot,
    leafblast,
    sheathblight,
    tungro

end # module
