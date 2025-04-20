#' Build a new menu
#'
#' To build a new menu, give `new_nav_menu()` unique keys and a list of their
#' corresponding values.
#' Each line shows the menu items (keys on the left, value descriptions on the
#' right).
#' By default, the description from [pillar::obj_sum()] is displayed, but you
#' can set `description`.
#' Each menu item can be accessed by [activate()].
#'
#' @param key A unique character vector.
#' @param value A list of values corresponding to the keys.
#' @param description A character vector of descriptions for the keys. By
#' default, the description from [pillar::obj_sum()] is displayed.
#' @param attrs A data frame for additional attributes of items (an empty data
#' frame by default).
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
#' band <- new_nav_menu(
#'   key = c("band_members", "band_instruments"),
#'   value = list(band_members, band_instruments),
#'   description = c(
#'     "A data frame of band members",
#'     "A data frame of band instruments"
#'   )
#' )
#' band
#'
#' # You can also build a nested menu
#' bands <- new_nav_menu(
#'   key = c("key1", "key2"),
#'   value = list(band, band)
#' )
#' bands
#'
#' @export
new_nav_menu <- function(
  key = character(),
  value = list(data.frame()),
  description = NULL,
  attrs = NULL,
  ...,
  class = character()
) {
  value <- purrr::map(value, function(x) {
    if (is.data.frame(x) && !is_nav(x)) {
      if (stickyr::is_sticky_tibble(x)) {
        attr(x, "sticky_attrs") <- c(
          names(attrs),
          "navigatr_tree",
          attr(x, "sticky_attrs")
        )
        attr(x, "class_grouped_df") <- c(
          "navigatr_item",
          attr(x, "class_grouped_df")
        )
        attr(x, "class_rowwise_df") <- c(
          "navigatr_item",
          attr(x, "class_rowwise_df")
        )
      } else {
        x <- stickyr::new_sticky_tibble(
          x,
          attrs = c(names(attrs), "navigatr_tree"),
          class_grouped_df = "navigatr_item",
          class_rowwise_df = "navigatr_item"
        )
      }
    }
    x
  })

  new_nav(
    key = key,
    value = value,
    description = description,
    attrs = attrs,
    ...,
    class = c(class, "navigatr_nav_menu")
  )
}

is_nav_menu <- function(x) {
  inherits(x, "navigatr_nav_menu")
}

#' @export
tbl_sum.navigatr_nav_menu <- function(x) {
  key <- x$key
  out <- x$description %||%
    purrr::map_chr(key, function(key) {
      child <- activate(x, key, .add = TRUE)
      child <- unitem(child, remove_attrs = FALSE)
      pillar::obj_sum(child)
    })
  names(out) <- key
  out
}

#' @export
vec_ptype_abbr.navigatr_nav_menu <- function(x, ...) {
  "nav_menu"
}
