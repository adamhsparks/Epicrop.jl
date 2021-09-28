module Epicrop

using DataFrames
import Dates: Date
import Interpolations: LinearInterpolation

include("seir.jl")

export SEIR

end # module
