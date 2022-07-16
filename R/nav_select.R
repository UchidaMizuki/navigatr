#' @export
new_select <- function(key = character(),
                       value = list(),
                       attrs = NULL, ...,
                       class = character()) {
  new_nav(key = key,
          value = value,
          attrs = attrs, ...,
          class = c(class, "navigatr_nav_select"))
}

is_select <- function(x) {
  inherits(x, "navigatr_nav_select")
}

#' @export
vec_ptype_abbr.navigatr_nav_select <- function(x) {
  "select"
}

#' @importFrom dplyr select
#' @export
select.navigatr_nav_select <- function(.data, ...) {
  keys <- set_names(.data$key)
  loc <- tidyselect::eval_select(expr(c(...)), keys)
  vec_slice(.data, loc)
}
