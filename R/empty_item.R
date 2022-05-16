#' @export
new_empty_item <- function(x = list(),
                           class = character()) {
  structure(vec_init(x, 0L),
            class = c(class, "navigatr_empty_item"))
}

#' @export
vec_ptype_abbr.navigatr_empty_item <- function(x) {
  "empty"
}

#' @export
print.navigatr_empty_item <- function(x, ...) {
  if (!is_empty(x)) {
    out <- x
    attributes(out) <- NULL
    print(out)
  }
  invisible(x)
}
