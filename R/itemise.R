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
                    .homonyms = "last")
  nms <- names(args)
  args <- unname(args)

  keys <- .data$key
  stopifnot(
    nms %in% keys
  )

  locs <- vec_match(nms, keys)

  for (i in vec_seq_along(locs)) {
    loc <- locs[[i]]

    value <- .data$value[[loc]]
    attrs_value <- attributes(value)

    arg <- args[[i]]
    attrs_arg <- attributes(arg)

    mostattributes(arg) <- c(attrs_arg,
                             attrs_value[!names(attrs_value) %in% names(attrs_arg)])
    if (is_empty_item(.data$value[[loc]])) {
      class(arg) <- c(purrr::head_while(class(.data$value[[loc]]),
                                        purrr::negate(is_empty_item)),
                      "navigatr_empty_item",
                      class(arg))
    }

    .data$value[[loc]] <- arg
  }
  .data
}

#' @rdname itemise
#' @export
itemise.navigatr_item <- function(.data, ...) {
  if (is_menu(.data)) {
    itemise.navigatr_menu(.data, ...)
  } else {
    args <- list2(...)
    vec_assert(args,
               size = 1L)

    attrs_value <- attributes(.data)

    arg <- args[[1L]]
    attrs_arg <- attributes(arg)

    mostattributes(arg) <- c(attrs_arg,
                             attrs_value[!names(attrs_value) %in% names(attrs_arg)])
    if (is_empty_item(.data)) {
      class(arg) <- c(purrr::head_while(class(.data),
                                        purrr::negate(is_empty_item)),
                      "navigatr_empty_item",
                      class(arg))
    }
    arg
  }
}
