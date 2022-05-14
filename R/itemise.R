#' Update items
#'
#' @param .data A `navigatr_menu` or `navigatr_item` object.
#' @param ... For `navigatr_menu` objects, use `key_name = item_value`. For
#' `navigatr_item` objects, new item value.
#'
#' @return A `navigatr_menu` or `navigatr_item` object.
#'
#' @export
itemise <- function(.data, ...) {
  UseMethod("itemise")
}

#' @rdname itemise
#' @export
itemize <- itemise

#' @rdname itemise
#' @export
itemise.navigatr_menu <- function(.data, ...) {
  args <- dots_list(...,
                    .named = TRUE,
                    .homonyms = "first")
  nms <- names(args)
  args <- unname(args)

  keys <- .data$key
  stopifnot(
    nms %in% keys
  )

  locs <- vec_match(nms, keys)

  for (i in vec_seq_along(locs)) {
    .data$value[[locs[[i]]]] <- args[[i]]
  }
  .data
}

#' @rdname itemise
#' @export
itemise.navigatr_item <- function(.data, ...) {
  if (is_menu(.data)) {
    itemise.navigatr_menu(.data, ...)
  } else {
    value <- list2(...)
    vec_assert(value,
               size = 1L)

    .data[] <- value[[1L]]
    .data
  }
}
