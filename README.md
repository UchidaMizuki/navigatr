
<!-- README.md is generated from README.Rmd. Please edit that file -->

# navigatr

<!-- badges: start -->
<!-- badges: end -->

navigatr provides a navigation menu that allows easy data processing for
each item. Only two functions, `new_menu()` and `activate()`, are the
core functions of this package. The roles of these functions are as
follows,

-   `new_menu()` builds a navigation menu that can use `activate()` (for
    developers).
-   `activate()` makes it easy to perform hierarchical data processing
    (for users).

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

## Example

``` r
library(navigatr)
library(dplyr)
```

To build a new menu, give `new_menu()` unique keys and a list of their
corresponding values. The upper rows show the menu items (keys on the
left, value summaries on the right). By defining `pillar::obj_sum`, you
can change the way the summaries are displayed.

``` r
mn1 <- new_menu(key = c("band_members", "band_instruments"),
                value = list(band_members, band_instruments))
mn1
#> # [ ] band_members:     tibble [3 x 2]
#> # [ ] band_instruments: tibble [3 x 2]
#> # 
#> # Please `activate()` the item.
```

You can activate a menu item by `activate()`. Activating a menu item
allows you to perform operations on the active item. `activate()` turns
a `menu` object into an `item` object, and `deactivate()` turns it back.

``` r
mn1_1 <- mn1 %>%
  activate(band_members) %>%
  filter(band == "Beatles")
mn1_1
#> # [x] band_members:     tibble [2 x 2]
#> # [ ] band_instruments: tibble [3 x 2]
#> # 
#> # A tibble: 2 x 2
#>   name  band   
#>   <chr> <chr>  
#> 1 John  Beatles
#> 2 Paul  Beatles
```

``` r
mn1_1 %>% 
  deactivate()
#> # [ ] band_members:     tibble [2 x 2]
#> # [ ] band_instruments: tibble [3 x 2]
#> # 
#> # Please `activate()` the item.
```

You can also build a nested menu. To activate items in a nested menu,
specify multiple variables.

``` r
mn2 <- new_menu(key = c("key1", "key2"),
                value = list(mn1, mn1))
mn2 %>% 
  activate(key1, band_instruments) %>% 
  select(name)
#> # [x] key1: menu [2 x 3]
#> #   [ ] band_members:     tibble [3 x 2]
#> #   [x] band_instruments: tibble [3 x 1]
#> # [ ] key2: menu [2 x 3]
#> # 
#> # A tibble: 3 x 1
#>   name 
#>   <chr>
#> 1 John 
#> 2 Paul 
#> 3 Keith
```
