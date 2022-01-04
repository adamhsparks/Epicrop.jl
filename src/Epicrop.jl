module Epicrop

using DataFrames, Dates, Interpolations

include("hlip.jl")

export hlipmodel

#re-exports from DataFrames.jl
export DataFrame

end # module
