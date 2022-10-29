# Epicrop.jl

[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://adamhsparks.github.io/Epicrop.jl/stable/)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://adamhsparks.github.io/Epicrop.jl/dev/)
[![CI](https://github.com/adamhsparks/Epicrop.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/adamhsparks/Epicrop.jl/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/adamhsparks/Epicrop.jl/branch/main/graph/badge.svg?token=Mmj7JbzCQK)](https://codecov.io/gh/adamhsparks/Epicrop.jl)
[![DOI](https://zenodo.org/badge/347936071.svg)](https://zenodo.org/badge/latestdoi/347936071)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

Epicrop.jl is a [Julia](https://julialang.org) package that can be used to simulate disease epidemics.
If you have not yet installed Julia, [please follow the instructions for your operating system](https://julialang.org/downloads/platform/).

This package provides a Healthy-Latent-Infectious-Postinfectious (HLIP) model for unmanaged plant disease epidemic modelling.
Originally this modelling framework was used by specific disease models in EPIRICE to simulate severity of several rice diseases ([Savary _et al._ 2012](http://dx.doi.org/10.1016/j.cropro.2011.11.009)).
Given proper values it can be used with other pathosystems as well.

## Installation

Epicrop.jl is is a registered Julia package.
You can install it with the following commands:

```julia
julia> ] add Epicrop 
```

You can copy and paste all commands to the REPL including the leading `julia>` prompts - they will automatically be stripped away by Julia.

## Using Epicrop.jl

Epicrop.jl is a package that can be used to simulate disease epidemics.
It provides a main function, `hlipmodel()` and five helper functions that enable users to quickly model bacterial blight, `bacterialblight()`; brown spot, `brownspot()`; leaf blast, `leafblast()`; sheath blight, `sheathblight()`; and tungro, `tungro()`, which require only two arguments to run, an object containing the weather data and the start of season date.

## References

Savary, S., Nelson, A., Willocquet, L., Pangga, I., and Aunario,  J. Modeling and mapping potential epidemics of rice diseases globally. _Crop Protection_, Volume 34, 2012, Pages 6-17, ISSN 0261-2194 DOI: [10.1016/j.cropro.2011.11.009](http://dx.doi.org/10.1016/j.cropro.2011.11.009).
