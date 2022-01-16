new_menu <- function(parent, key) {
  stopifnot(
    is_scalar_integer(key)
  )

  out <- parent$data[[key]]
  structure(out,
            activated = list(parent = parent,
                             key = key,
                             attrs = parent$attrs[[key]]),
            class = c(setdiff(class(parent), c("tbl_menu", "data.frame")),
                      class(out)))
}

#' @export
is_activated <- function(x) {
  inherits(x, "activated")
}
