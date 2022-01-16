#' @export
new_deactivated <- function(x, ..., class = character()) {
  x <- as.list(x)
  structure(x,
            ...,
            class = c(class, "deactivated", "list"))
}

#' @export
is_deactivated <- function(x) {
  inherits(x, "deactivated")
}

#'

#' @importFrom pillar tbl_sum
#' @export
tbl_sum.deactivated <- function(x) {

}

#' @export
format.deactivated <- function(x, ...) {
  x
}
