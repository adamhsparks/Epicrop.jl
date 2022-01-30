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
Given proper values it can be used with other pathosystems as well using the methods as described by Savary _et al._ (2012, 2015).

## Installation

Epicrop.jl is a registered Julia package.
You can install it with the following commands:

```julia
julia> ] add Epicrop 
```

## Usage

You can either specify the parameters directly or use the helper functions to simplify the process of running the model for specific rice diseases as published in Savary _et al._ (2012).

## References

Serge Savary, Andrew Nelson, Laetitia Willocquet, Ireneo Pangga and Jorrel Aunario (2012). Modeling and mapping potential epidemics of rice diseases globally. _Crop Protection_, Volume 34, Pages 6-17, ISSN 0261-2194 DOI: [10.1016/j.cropro.2011.11.009](https://doi.org/10.1016/j.cropro.2011.11.009).

Serge Savary, Stacia Stetkiewicz, François Brun, and Laetitia Willocquet. (2015) Modelling and Mapping Potential Epidemics of Wheat Diseases—Examples on Leaf Rust and Septoria Tritici Blotch Using EPIWHEAT. _European Journal of Plant Pathology_ Volume 142, Pages 771–90. [doi.org/10.1007/s10658-015-0650-7](https://doi.org/10.1007/s10658-015-0650-7).
