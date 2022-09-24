#' Deprecated functions
#'
#' @name depricated
#' @export
new_menu <- function(key = character(),
                     value = list(),
                     attrs = NULL, ...,
                     class = character()) {
  lifecycle::deprecate_warn("1.0.0", "new_menu()", "new_nav_menu()")
  new_nav_menu(key = key,
               value = value,
               attrs = attrs, ...,
               class = class)
}
