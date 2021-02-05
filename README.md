
<!-- README.md is generated from README.Rmd. Please edit that file -->
# rutils

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental) [![R build status](https://github.com/RHReynolds/rutils/workflows/R-CMD-check-bioc/badge.svg)](https://github.com/RHReynolds/rutils/actions) [![Codecov test coverage](https://codecov.io/gh/RHReynolds/rutils/branch/master/graph/badge.svg)](https://codecov.io/gh/RHReynolds/rutils?branch=master) <!-- badges: end -->

The goal of `rutils` is to house some of my commonly used functions.

## Installation instructions

There is no plan to ever submit this code to `CRAN` or `Bioconductor`. This code was developed for personal use. If you would like to install the development version from [GitHub](https://github.com/) you can use the following command:

``` r
BiocManager::install("RHReynolds/rutils")
```

## Citation

Below is the citation output from using `citation('rutils')` in R. Please run this yourself to check for any updates on how to cite **rutils**.

``` r
print(citation("rutils"), bibtex = TRUE)
```

Please note that the `rutils` was only made possible thanks to many other R and bioinformatics software authors, which are cited either in the vignettes and/or the paper(s) describing this package.

## Code of Conduct

Please note that the `rutils` project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.

## Development tools

-   Continuous code testing is possible thanks to [GitHub actions](https://www.tidyverse.org/blog/2020/04/usethis-1-6-0/) through *[usethis](https://CRAN.R-project.org/package=usethis)*, *[remotes](https://CRAN.R-project.org/package=remotes)*, and *[rcmdcheck](https://CRAN.R-project.org/package=rcmdcheck)* customized to use [Bioconductor's docker containers](https://www.bioconductor.org/help/docker/) and *[BiocCheck](https://bioconductor.org/packages/3.10/BiocCheck)*.
-   Code coverage assessment is possible thanks to [codecov](https://codecov.io/gh) and *[covr](https://CRAN.R-project.org/package=covr)*.
-   The [documentation website](http://RHReynolds.github.io/rutils) is automatically updated thanks to *[pkgdown](https://CRAN.R-project.org/package=pkgdown)*.
-   The code is styled automatically thanks to *[styler](https://CRAN.R-project.org/package=styler)*.
-   The documentation is formatted thanks to *[devtools](https://CRAN.R-project.org/package=devtools)* and *[roxygen2](https://CRAN.R-project.org/package=roxygen2)*.

For more details, check the `dev` directory.

This package was developed using *[biocthis](https://github.com/lcolladotor/biocthis)*.
