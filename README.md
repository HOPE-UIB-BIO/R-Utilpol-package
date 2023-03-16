
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

The file management system is created in order to load the most latest
version of a file. In addition, while saving the file, it will overwrite
ONLY if the file changes since the latest version.

``` r
# load {RUtilpol}
library(RUtilpol, verbose = FALSE)
#> R-Utilpol version 0.0.0.9000 
#>  This package is under active development. Therefore, the package is subject to change.
# load {tidyverse}
library(tidyverse, verbose = FALSE)
#> ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
#> ✔ dplyr     1.1.0     ✔ readr     2.1.4
#> ✔ forcats   1.0.0     ✔ stringr   1.5.0
#> ✔ ggplot2   3.4.1     ✔ tibble    3.2.0
#> ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
#> ✔ purrr     1.0.1
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
# load {here} for better file navigation
library(here, verbose = FALSE)
#> here() starts at C:/Users/ondre/Documents/HOPE/GITHUB/R-Utilpol-package

# use the build-in dataset of `mtcars`
mtcars_to_use <- mtcars

RUtilpol::save_latest_file(
  object_to_save = mtcars_to_use,
  dir = here::here()
)
#> ✔ Have not find previous version of the file. Saving the file with rds format.
#> [1] "Done"

list.files(
  here::here()
) %>%
  stringr::str_subset(pattern = "mtcars_to_use")
#> [1] "mtcars_to_use_2023-03-16__d0487363db4e6cc64fdb740cb6617fc0__.rds"
```

Now we can load the file back and compare that it is truly the same
dataset

``` r
# load waldo to compare files
library(waldo, verbose = FALSE)

# load the data back to R
mtcars_loaded <-
  RUtilpol::get_latest_file(
    file_name = "mtcars_to_use",
    dir = here::here()
  )
#> ✔ Automatically loaded file
#> mtcars_to_use_2023-03-16__d0487363db4e6cc64fdb740cb6617fc0__.rds

# compare files
waldo::compare(
  x = mtcars_to_use,
  y = mtcars_loaded
)
#> ✔ No differences
```

Let’s alter the data and try to save it again.

``` r
# edit the `mtcars` datasets
mtcars_to_use$mpg <- mtcars_to_use$mpg - mean(mtcars_to_use$mpg)  

# save
RUtilpol::save_latest_file(
  object_to_save = mtcars_to_use,
  dir = here::here()
)
#> ✔ Found older file, overwriting it with new changes.
#> [1] "Done"
```

The function will overwrite the file unless there is a change of date,
in which case, it will create a new file

``` r
# edit the `mtcars` datasets
mtcars_to_use$disp <- mtcars_to_use$disp - mean(mtcars_to_use$disp)  

# save
RUtilpol::save_latest_file(
  object_to_save = mtcars_to_use,
  dir = here::here(),
  current_date = "3000-01-01"
)
#> ✔ Found older file, overwriting it with new changes.
#> [1] "Done"

# check the files
list.files(
  here::here()
) %>%
  stringr::str_subset(pattern = "mtcars_to_use")
#> [1] "mtcars_to_use_2023-03-16__f2c54b73b4ed92edb5f94bb241d8e4ec__.rds"
#> [2] "mtcars_to_use_3000-01-01__43110f6a7f53a7572ed11d06db9f854f__.rds"

# load the data back to R. It will load the one with the most recent date
mtcars_loaded <-
  RUtilpol::get_latest_file(
    file_name = "mtcars_to_use",
    dir = here::here()
  )
#> ✔ Automatically loaded file
#> mtcars_to_use_3000-01-01__43110f6a7f53a7572ed11d06db9f854f__.rds
```

A user can also specify several arguments as the name of the file (it is
the same as the object name by default), the format of the file (`rds`
as default), etc. Check the function documentation by calling
`?RUtilpol::save_latest_file()`

``` r
# save the file with the `qs` format (fast and well-compressed)
RUtilpol::save_latest_file(
 object_to_save = mtcars_to_use,
 file_name = "mtcars_qs",
 prefered_format = "qs"
)
#> ✔ Have not find previous version of the file. Saving the file with qs format.
#> [1] "Done"

list.files(
  here::here()
) %>%
  stringr::str_subset(pattern = "mtcars_qs")
#> [1] "mtcars_qs_2023-03-16__43110f6a7f53a7572ed11d06db9f854f__.qs"
```

### Extraction of spatial information
