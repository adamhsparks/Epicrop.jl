# Epicrop.jl

![Lifecycle:Experimental](https://img.shields.io/badge/Lifecycle-Experimental-339999)

A Julia version of the R [_epicrop_](https://github.com/adamhsparks/epicrop/) package.

Weather data fetching is not built-in with this package as it is with the R version, but can
be implemented using [**RCall**](https://github.com/JuliaInterop/RCall.jl) and calling
(_nasapower_)[https://github.com/ropensci/nasapower].
