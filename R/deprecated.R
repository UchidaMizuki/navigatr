#' Deprecated functions
#'
#' @param key A unique character vector.
#' @param value A list of values corresponding to the keys.
#' @param attrs A data frame for additional attributes of items (an empty data frame by default).
#' When an item becomes active, the attrs will be added to its attributes.
#' @param ... Additional arguments passed to [vctrs::new_data_frame()].
#' @param class A character vector of subclasses passed to [vctrs::new_data_frame()].
#'
#' @return A `navigatr_nav_menu` object, a subclass of class `data.frame`.
#'
#' @export
new_menu <- function(
  key = character(),
  value = list(),
  attrs = NULL,
  ...,
  class = character()
) {
  lifecycle::deprecate_warn("1.0.0", "new_menu()", "new_nav_menu()")
  new_nav_menu(key = key, value = value, attrs = attrs, ..., class = class)
}
