```@meta
Author = "Adam H. Sparks"
CurrentModule = Epicrop
DocTestSetup = quote
    using Epicrop
end
```

# Epicrop.jl

*Crop disease modeling in Julia.*
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

julia> Pkg.clone("https://github.com/adamhsparks/Epicrop.jl")
```
## Functions exported from `Epicrop`

```@autodocs
Modules = [Epicrop]
Private = false
Order = [:function]
```

