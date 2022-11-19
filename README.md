
<!-- README.md is generated from README.Rmd. Please edit that file -->

# navigatr

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/navigatr)](https://CRAN.R-project.org/package=navigatr)
[![Codecov test
coverage](https://codecov.io/gh/UchidaMizuki/navigatr/branch/main/graph/badge.svg)](https://app.codecov.io/gh/UchidaMizuki/navigatr?branch=main)
[![R-CMD-check](https://github.com/UchidaMizuki/navigatr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/UchidaMizuki/navigatr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

navigatr provides navigation menus and input forms.

navigatr’s navigation menu allows piped data processing for hierarchical
data structures. By activating menu items, operations on each item can
be performed while maintaining the overall structure with attributes.

The core functions of this package are as follows,

- `new_nav_menu()` builds a new navigation menu.
  - `activate()` accesses a menu item.
- `new_nav_input()` builds a new input form.
  - `itemise()` enters values into the form.
- `rekey()` and `rekey_with()` renames the key of a menu item.

## Installation

You can install navigatr from CRAN.

``` r
install.packages("navigatr")
```

You can also install the development version from GitHub.

``` r
# install.packages("devtools")
devtools::install_github("UchidaMizuki/navigatr")
```

## Examples

``` r
library(navigatr)
library(dplyr)
```

### Build a navigation menu

To build a new navigation menu, give `new_menu()` unique keys and a list
of their corresponding values. The upper rows show the menu items (keys
on the left, value summaries on the right). By defining
`pillar::obj_sum()`, you can change the way the summaries are displayed.

``` r
band <- new_nav_menu(key = c("band_members", "band_instruments"),
                     value = list(band_members, band_instruments))
band
#> # ☐ band_members:     tibble [3 × 2]
#> # ☐ band_instruments: tibble [3 × 2]
#> # 
#> # Please `activate()`.
```

You can activate a menu item by `activate()`. Activating a menu item
allows you to perform operations on the active item. `activate()` turns
a `navigatr_new_menu` object into an `navigatr_nav_item` object, and
`deactivate()` turns it back.

``` r
band <- band |>
  activate(band_members) |>
  filter(band == "Beatles")
band
#> # ☒ band_members:     tibble [2 × 2]
#> # ☐ band_instruments: tibble [3 × 2]
#> # 
#> # A tibble: 2 × 2
#>   name  band   
#>   <chr> <chr>  
#> 1 John  Beatles
#> 2 Paul  Beatles
```

``` r
band <- band |> 
  deactivate()
band
#> # ☐ band_members:     tibble [2 × 2]
#> # ☐ band_instruments: tibble [3 × 2]
#> # 
#> # Please `activate()`.
```

The `rekey()` function is used to change the key of an activated menu
item.

``` r
band |> 
  activate(band_instruments) |> 
  rekey("new_band_instruments")
#> # ☐ band_members:         tibble [2 × 2]
#> # ☒ new_band_instruments: tibble [3 × 2]
#> # 
#> # A tibble: 3 × 2
#>   name  plays 
#>   <chr> <chr> 
#> 1 John  guitar
#> 2 Paul  bass  
#> 3 Keith guitar
```

You can also build a nested navigation menu. To activate the items,
specify multiple variables.

``` r
bands <- new_nav_menu(key = c("key1", "key2"),
                      value = list(band, band)) # A list of menu objects
bands |> 
  activate(key1, band_instruments) |> 
  select(name)
#> # ☒ key1: nav_menu [2]
#> #   ☐ band_members:     tibble [2 × 2]
#> #   ☒ band_instruments: tibble [3 × 1]
#> # ☐ key2: nav_menu [2]
#> # 
#> # A tibble: 3 × 1
#>   name 
#>   <chr>
#> 1 John 
#> 2 Paul 
#> 3 Keith
```

### Build a input form

``` r
input <- new_nav_input(key = c("key1", "key2"))
input
#> # ✖ key1: chr [0]
#> # ✖ key2: chr [0]
#> # 
#> # Please `itemise()`.
```

``` r
input |> 
  itemise(key1 = "value1",
          key2 = "value2")
#> # ✔ key1: chr [1]
#> # ✔ key2: chr [1]
#> # 
#> # Please `itemise()`.
```
