module Epicrop

using DataFrames, Dates, Interpolations

include("hlip.jl")

export run_hlip_model

#re-exports from DataFrames.jl
export DataFrame

end # module
