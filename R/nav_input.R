#' @export
new_nav_input <- function(key = character(),
                          value = list(list()), ...,
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
