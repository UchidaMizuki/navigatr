#' Rename key names
#'
#' @param .data A `navigatr_menu` or `navigatr_item` object.
#' @param ... For `navigatr_menu` objects, use `new_name = old_name`. For
#' `navigatr_item` objects, a scalar character of the new key name.
#'
#' @return A `navigatr_menu` or `navigatr_item` object.
#'
#' @export
rekey <- function(.data, ...) {
  UseMethod("rekey")
}

#' @rdname rekey
#' @export
rekey.navigatr_menu <- function(.data, ...) {
  keys <- set_names(.data$key)
  loc <- tidyselect::eval_rename(expr(c(...)), keys)
  .data$key[loc] <- names(loc)
  .data
}

#' @rdname rekey
#' @export
rekey.navigatr_item <- function(.data, ...) {
  if (is_menu(.data)) {
    rekey.navigatr_menu(.data, ...)
  } else {
    name <- vec_c(...)
    vec_assert(name, character(), 1L)

    item_key(.data) <- name
    .data
  }
}
