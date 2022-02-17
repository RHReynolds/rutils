# rutils 0.99.2

NEW FEATURES

* Added `md5_check()`, which can be used to generate md5s on copied files and check these match with md5s from the original file

SIGNIFICANT USER-VISIBLE CHANGES

* `go_reduce()`: added argument for (i) selection of semantic similarity measure (`measure`) and (ii) org.* Bioconductor package to be used (`orgdb`). Both have defaults set such that the function is backwards compatible with previous versions.

# rutils 0.99.1

NEW FEATURES

* Added `go_reduce()`, which can be used to reduce the redundancy of human GO terms
* Added `go_plot()`, which can be used to plot GO terms following use of `go_reduce()`
* Added `liftover_coord()`, which can be used to lift genomic co-ordinates from one genome build to another

# rutils 0.99.0

NEW FEATURES

* Added a `NEWS.md` file to track changes to the package.

