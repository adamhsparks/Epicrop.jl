# Epicrop.jl

```@meta
Author = "Adam H. Sparks"
CurrentModule = Epicrop
DocTestSetup = quote
    using Epicrop
end
```

_Crop disease modeling in Julia._

## Overview

Epicrop.jl is a [Julia](https://julialang.org) package that can be used to simulate disease epidemics.
If you have not yet installed Julia, [please follow the instructions for your operating system](https://julialang.org/downloads/platform/).

This package provides a Healthy-Latent-Infectious-Postinfectious (HLIP) model for unmanaged plant disease epidemic modelling.
Originally this modelling framework was used by specific disease models in EPIRICE to simulate severity of several rice diseases (Savary _et al._ 2012).
Given proper values it can be used with other pathosystems as well.

## Installation

Epicrop.jl is not yet a registered Julia package, but I hope to have it in good enough condition to register it shortly.
Until then you can install it with the following commands:

```julia
julia> using Pkg

julia> Pkg.add(url = "https://github.com/adamhsparks/Epicrop.jl")
```

## Usage

You can either specify the parameters directly or use the helper functions to simplify the process of running the model for specific rice diseases as published in Savary _et al._ (2012).

## References

Savary, S., Nelson, A., Willocquet, L., Pangga, I., and Aunario,  J. Modeling and mapping potential epidemics of rice diseases globally. _Crop Protection_, Volume 34, 2012, Pages 6-17, ISSN 0261-2194 DOI: [10.1016/j.cropro.2011.11.009](http://dx.doi.org/10.1016/j.cropro.2011.11.009).
