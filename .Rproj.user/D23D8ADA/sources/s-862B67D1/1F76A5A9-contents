#' @export
activate <- function(.data, ..., .add = FALSE) {
  UseMethod("activate")
}

#' @export
activate.default <- function(.data, ..., .add = FALSE) {
  vars <- enquos(...)

  key <- tidyselect::vars_pull(.data$key, !!vars[[1]])
  vars <- vars[-1]

  out <- new_activated(.x, key)

  if (!is_empty(vars)) {
    out <- activate(out, !!!vars)
  }
  out
}

#' #' @export
#' deactivate <- function(x, ..., deep = TRUE) {
#'   UseMethod("deactivate")
#' }
#'
#' #' @export
#' deactivate.default <- function(x, ..., deep = TRUE) {
#'   x
#' }
#'
#' #' @export
#' deactivate.activated <- function(x, ..., deep = TRUE) {
#'   key <- attr(x, "key")
#'   parent <- attr(x, "parent")
#'
#'   attr(x, "key") <- NULL
#'   attr(x, "parent") <- NULL
#'   class(x) <- class(purrr::chuck(parent, key))
#'
#'   parent[[key]] <- x
#'
#'   if (deep) {
#'     parent <- deactivate(parent)
#'   }
#'   parent
#' }
