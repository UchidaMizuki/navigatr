#' Rename key names
#'
#' @param .data For `rekey()`, A `navigatr_menu` or `navigatr_item` object. For
#' `rekey_with()`, A `navigatr_menu` object.
#' @param ... For `navigatr_menu` objects, use `new_name = old_name`. For
#' `navigatr_item` objects, a scalar character of the new key name.
#' @param .fn A function used to transform the selected `.keys`.
#' @param .keys Keys to rename; defaults to all keys.
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
  args <- list2(...)

  if (is_menu(.data) && is_named(args)) {
    rekey.navigatr_menu(.data, ...)
  } else {
    name <- vec_c(!!!args)
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
    is_menu(.data)
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
