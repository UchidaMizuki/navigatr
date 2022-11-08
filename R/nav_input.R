#' Build a new input form
#'
#' To create a new input form, give `new_nav_input()` a unique key and the corresponding list of values.
#' By default, the values are empty characters.
#' Each line shows the menu items (keys on the left, value summaries on the right).
#' The summaries are [pillar::obj_sum] outputs, so you can change the printing methods.
#' Each menu item can be changed by [itemise()].
#'
#' @param key A unique character vector.
#' @param value A list of values corresponding to the keys. By default, the values are empty characters.
#' @param ... Additional arguments passed to [vctrs::new_data_frame()].
#' @param class A character vector of subclasses passed to [vctrs::new_data_frame()].
#'
#' @return A `navigatr_nav_input` object, a subclass of class `data.frame`.
#'
#' @seealso [itemise()]
#'
#' @export
new_nav_input <- function(key = character(),
                          value = list(character()), ...,
                          class = character()) {
  new_nav(key = key,
          value = value, ...,
          class = c(class, "navigatr_nav_input"))
}

is_nav_input <- function(x) {
  inherits(x, "navigatr_nav_input")
}

#' @export
tbl_sum.navigatr_nav_input <- function(x) {
  out <- purrr::map_chr(x$value,
                        pillar::obj_sum)
  names(out) <- x$key
  out
}

#' @export
vec_ptype_abbr.navigatr_nav_input <- function(x) {
  "nav_input"
}
