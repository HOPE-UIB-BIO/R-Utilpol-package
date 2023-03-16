
# RUtilpol

<!-- badges: start -->

[![CRAN-status](https://www.r-pkg.org/badges/version/RUtilpol.png)](https://CRAN.R-project.org/package=RUtilpol)
[![R-CMD-check](https://github.com/HOPE-UIB-BIO/R-Utilpol-package/workflows/R-CMD-check/badge.svg)](https://github.com/HOPE-UIB-BIO/R-Utilpol-package/actions)
<!-- badges: end -->

R-Utilpol is an R package proving utility functions for package
development.

## WARNING

:bangbang: This package is under active development. Therefore, the
package is subject to change. :bangbang:

## Installation

You can install the development version of RUtilpol from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("HOPE-UIB-BIO/R-Utilpol-package")
```

## Usage

The main purpose of {RUtilpol} is to provide utility (helper) functions.
All functions can be grouped into 3 main categories:

1.  **Package development** - Function used within other packages (e.g.,
    `RUtilpol::check_class()` for safety check,
    `RUtilpol::output_warning()` - for console message,
    `RUtilpol::replace_null_with_na()` for data wrangling ,…).

2.  [**File management**](#file-management) - Functions for saving and
    loading functions for better handling of files in large projects
    (see examples below).

3.  [**Extraction of spatial
    information**](#extraction-of-spatial-information) - Functions to
    assign information to points based on a raster of shapefile (see
    examples below).

### File management

### Extraction of spatial information
