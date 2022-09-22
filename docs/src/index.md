```@meta
CurrentModule = Epicrop
Author = "Adam H. Sparks"
```

# Epicrop

Documentation for [Epicrop](https://github.com/adamhsparks/Epicrop.jl).

```@index
```

## Helper Functions

Quickly and easily model bacterial blight, brown spot, leaf blast, sheath blight, tungro.
These functions provide the basic values necessary as published in Savary _et al._ (2012) to model these diseases with just daily weather data that spans the growing season of interest and growing season start date as values.

### Bacterial Blight

A dynamic mechanistic simulation of bacterial blight disease of rice, causal agent _Xanthomonas oryzae_ pv. _oryzae_.
The model represents site size as 1 rice plant's leaf.
Default values for this disease model are derived from Table 2 (_Savary et al. 2012_).

```@docs
bacterialblight
```

### Brown Spot

A dynamic mechanistic simulation of rice brown spot, causal agent _Cochliobolus miyabeanus_.
The model represents site size as 10 mm² of a rice plant's leaf.
Default values for this disease model are derived from Table 2 (Savary _et al_. 2012).

_Note_ The optimum temperature for brown spot as presented in Table 2 of Savary _et al._ 2012 has a typo.
The optimal value should be 25 °C, not 20 °C as shown.
The correct value, 25 °C, is used in this implementation.

```@docs
brownspot
```

### Leaf Blast

A dynamic mechanistic simulation of leaf blast disease of rice, causal agent _Magnaporthe oryzae_.
The model represents site size as 45 mm² of a rice plant's leaf.

_Note_ The optimum temperature for leaf blast as presented in Table 2 of Savary _et al._ 2012 has a typo.
The optimal value should be 20 °C, not 25 °C as shown.
The correct value, 20 °C, is used in this implementation.

```@docs
leafblast
```

### Sheath Blight

A dynamic mechanistic simulation of sheath blight disease of rice, causal agent _Rhizoctonia solani_ AG1-1A Kühn.
The model represents site size as 1 rice plant's tiller.

```@docs
sheathblight
```

### Tungro

A dynamic mechanistic simulation of tungro disease of rice, causal agents _Rice Tungro Spherical Virus_ and _Rice Tungro Bacilliform Virus_.
The model represents site size as 1 rice plant.
Default values for this disease model are derived from Table 2 (Savary _et al._ 2012).

```@docs
tungro
```

## Advanced Use

Epicrop.jl provides a basic function, `hlipmodel`, that can be used to predict unmanaged plant disease epidemics given the proper input.
Predefined values for the EPIRICE model can be found in Savary _et al._ (2012) for the following diseases of rice: bacterial blight, brown spot, leaf blast, sheath blight and tungro and are included as helper functions, [`bacterialblight`](@ref), [`brownspot`](@ref), [`leafblast`](@ref), [`sheathblight`](@ref), and [`tungro`](@ref), that simplify using the model's interface.
Given other parameters, the model framework is capable of modelling other diseases using the methods as described by Savary _et al._ (2012).

```@docs
hlipmodel
```

## References

Savary, S., Nelson, A., Willocquet, L., Pangga, I., and Aunario,  J. Modeling and mapping potential epidemics of rice diseases globally. _Crop Protection_, Volume 34, 2012, Pages 6-17, ISSN 0261-2194 DOI: [10.1016/j.cropro.2011.11.009](http://dx.doi.org/10.1016/j.cropro.2011.11.009).
