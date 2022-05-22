#' Build a new navigation menu
#'
#' To build a new navigation menu, give `new_menu()` unique keys and a list of their corresponding values.
#' The top row shows the menu items (keys on the left, value summaries on the right).
#' The summaries are [pillar::obj_sum] outputs, so you can change the printing methods.
#' Each menu item can be accessed by [activate()].
#'
#' @param key A unique character vector.
#' If the key is not a character vector, it is converted to a character vector by [as.character()].
#' @param value A list of values corresponding to the keys.
#' If the value is not a list, it is converted to a list by [as.list()].
#' @param attrs A data frame for additional attributes of items (an empty data frame by default).
#' When an item becomes active, the attrs will be added to its attributes.
#' @param ... Additional arguments passed to [vctrs::new_data_frame()].
#' @param class A character vector of subclasses passed to [vctrs::new_data_frame()].
#'
#' @return A `navigatr_nav_menu` object, a subclass of class `data.frame`.
#'
#' @seealso [activate()]
#'
#' @examples
#' library(dplyr)
#'
#' band <- new_menu(key = c("band_members", "band_instruments"),
#'                  value = list(band_members, band_instruments))
#' band
#'
#' # You can also build a nested menu
#' bands <- new_menu(key = c("key1", "key2"),
#'                   value = list(band, band))
#' bands
#'
#' @export
new_menu <- function(key = character(),
                     value = list(),
                     attrs = NULL, ...,
                     class = character()) {
  new_nav(key = key,
          value = value,
          attrs = attrs, ...,
          class = c(class, "navigatr_nav_menu"))
}

is_menu <- function(x) {
  inherits(x, "navigatr_nav_menu")
}

#' @export
vec_ptype_abbr.navigatr_nav_menu <- function(x) {
  "menu"
}
