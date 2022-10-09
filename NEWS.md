# Epicrop.jl Release Notes

## v1.0.0

### Major changes

* Enforce data types for user-provided inputs

* Helper functions now use positional arguments rather than keyword for greater simplicty

* Helper functions allow for the use of season durations but default to 120 days

* Remove CSV.jl from package examples for quicker compilation times

* `emergence` no longer must be encoded as a `Dates.Date` but rather just an `AbstractString` value

### Bug fixes

* Update Interpolations.jl to remove the uses of the deprecated function `LinearInterpolation()` and use `linear_interpolation()` instead.
This fixes a bug (that did not appear to affect the functionality) and should be more performant.

### Minor changes

* Include example weather data set from the NASA POWER data base for examples and testing

* Reformat code

## v0.1.2

* Remove `Using Plots` from `hlipmodel` example

* Separate kernel functions for better performance.
The `for loop` in `hlipmodel` is now its own internal function called from `hlipmodel`.

* Add CITATION.bib file to repository.

## v0.1.1

* Update CSV compat to "0.9, 0.10" from "0.9"

## v0.1.0

* Initial release
