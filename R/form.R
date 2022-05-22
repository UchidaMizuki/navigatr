#' @export
new_form <- function(key = character(),
                     value = list(),
                     attrs = NULL, ...,
                     class = character()) {
  new_nav(key = key,
          value = value,
          attrs = attrs, ...,
          class = c(class, "navigatr_nav_form"))
}

is_form <- function(x) {
  inherits(x, "navigatr_nav_form")
}

#' @export
vec_ptype_abbr.navigatr_nav_form <- function(x) {
  "form"
}
