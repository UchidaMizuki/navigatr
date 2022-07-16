#' Rename key names
#'
#' @param .data For `rekey()`, A `navigatr_nav` or `navigatr_item` object. For
#' `rekey_with()`, A `navigatr_nav` object.
#' @param ... For `navigatr_nav` objects, use `new_name = old_name`. For
#' `navigatr_item` objects, a scalar character of the new key name.
#' @param .fn A function used to transform the selected `.keys`.
#' @param .keys Keys to rename; defaults to all keys.
#'
#' @return A `navigatr_nav` or `navigatr_item` object.
#'
#' @export
rekey <- function(.data, ...) {
  UseMethod("rekey")
}

#' @rdname rekey
#' @export
rekey.navigatr_nav <- function(.data, ...) {
  keys <- set_names(.data$key)
  loc <- tidyselect::eval_rename(expr(c(...)), keys)
  .data$key[loc] <- names(loc)
  .data
}

#' @rdname rekey
#' @export
rekey.navigatr_item <- function(.data, ...) {
  if (is_nav(.data) && is_named(enquos(...))) {
    rekey.navigatr_nav(.data, ...)
  } else {
    name <- vec_c(!!!list2(...))
    vec_assert(name, character(), 1L)

    item_key(.data) <- name
    .data
  }
}

#' @rdname rekey
#' @export
rekey_with <- function(.data, .fn,
                       .keys = dplyr::everything(), ...) {
  stopifnot(
    is_nav(.data)
  )

  .fn <- as_function(.fn)

  keys <- set_names(.data$key)
  cols <- tidyselect::eval_select(enquo(.keys), keys)

  keys[cols] <- .fn(keys[cols], ...)
  keys <- vec_as_names(keys,
                       repair = "check_unique")
  .data$key <- unname(keys)
  .data
}
