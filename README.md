
<!-- README.md is generated from README.Rmd. Please edit that file -->
# rutils

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental) [![R build status](https://github.com/RHReynolds/rutils/workflows/R-CMD-check-bioc/badge.svg)](https://github.com/RHReynolds/rutils/actions) [![Codecov test coverage](https://codecov.io/gh/RHReynolds/rutils/branch/master/graph/badge.svg)](https://codecov.io/gh/RHReynolds/rutils?branch=master) [![DOI](https://zenodo.org/badge/319682459.svg)](https://zenodo.org/badge/latestdoi/319682459) <!-- badges: end -->

The goal of `rutils` is to house some of my commonly used functions.

## Installation instructions

There is no plan to ever submit this code to `CRAN` or `Bioconductor`. This code was developed for personal use. If you would like to install the development version from [GitHub](https://github.com/) you can use the following command:

``` r
BiocManager::install("RHReynolds/rutils")
```

**Note:** If you are running R (&lt; 4.0), installation may return the error that `GOSemSim` (v2.16.1) and/or `rrvgo` are not available for your R version. However, these packages do not actually have a dependency on R (&gt;= 4.0) -- the error occurs because these packages cannot be found using your version of BioConductor (which is likely to be &lt; 3.12). A workaround to this issue is to install the development versions of these packages directly from GitHub, using the following command:

``` r
# If GOSemSim successfully installed, simply remove from command
remotes::install_github(c("GuangchuangYu/GOSemSim", "ssayols/rrvgo"))
```

The downside of this is, of course, that these are development versions, and thus may not be entirely stable, so be sure to check in on these packages every so often to see if there have been any major bug fixes.

## Citation

Below is the citation output from using `citation('rutils')` in R. Please run this yourself to check for any updates on how to cite **rutils**.

``` r
print(citation("rutils"), bibtex = TRUE)
#> 
#> RHReynolds (2022). _Common utility functions_. doi:
#> 10.5281/zenodo.6127446 (URL: https://doi.org/10.5281/zenodo.6127446),
#> https://github.com/RHReynolds/rutils - R package version 0.99.2, <URL:
#> https://github.com/RHReynolds/rutils>.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {Common utility functions},
#>     author = {{RHReynolds}},
#>     year = {2022},
#>     url = {https://github.com/RHReynolds/rutils},
#>     note = {https://github.com/RHReynolds/rutils - R package version 0.99.2},
#>     doi = {10.5281/zenodo.6127446},
#>   }
```

Please note that the `rutils` was only made possible thanks to many other R and bioinformatics software authors, which are cited either in the vignettes and/or the paper(s) describing this package.

## Code of Conduct

Please note that the `rutils` project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.

## Development tools

-   Continuous code testing is possible thanks to [GitHub actions](https://www.tidyverse.org/blog/2020/04/usethis-1-6-0/) through *[usethis](https://CRAN.R-project.org/package=usethis)*, *[remotes](https://CRAN.R-project.org/package=remotes)*, and *[rcmdcheck](https://CRAN.R-project.org/package=rcmdcheck)* customized to use [Bioconductor's docker containers](https://www.bioconductor.org/help/docker/) and *[BiocCheck](https://bioconductor.org/packages/3.12/BiocCheck)*.
-   Code coverage assessment is possible thanks to [codecov](https://codecov.io/gh) and *[covr](https://CRAN.R-project.org/package=covr)*.
-   The [documentation website](http://RHReynolds.github.io/rutils) is automatically updated thanks to *[pkgdown](https://CRAN.R-project.org/package=pkgdown)*.
-   The code is styled automatically thanks to *[styler](https://CRAN.R-project.org/package=styler)*.
-   The documentation is formatted thanks to *[devtools](https://CRAN.R-project.org/package=devtools)* and *[roxygen2](https://CRAN.R-project.org/package=roxygen2)*.

For more details, check the `dev` directory.

This package was developed using *[biocthis](https://github.com/lcolladotor/biocthis)*.
