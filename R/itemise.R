#' Update items
#'
#' @param .data A `navigatr_nav` or `navigatr_item` object.
#' @param ... For `navigatr_nav` objects, use `key_name = item_value`. For
#' `navigatr_item` objects, new item value.
#'
#' @return A `navigatr_nav` or `navigatr_item` object.
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
itemise.navigatr_nav <- function(.data, ...) {
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

    arg <- args[[i]]
    navigatr_tree(arg) <- navigatr_tree(value)
    for (attr_name in item_attr_names(value)) {
      attr(arg, attr_name) <- attr(value, attr_name)
    }

    if (is_empty_item(value)) {
      class(arg) <- c(purrr::head_while(class(value),
                                        purrr::partial(`!=`, "navigatr_empty_item")),
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
  args <- list2(...)

  if (is_nav(.data) && is_named(args)) {
    itemise.navigatr_nav(.data, ...)
  } else {
    vec_assert(args,
               size = 1L)

    arg <- args[[1L]]
    navigatr_tree(arg) <- navigatr_tree(.data)
    for (attr_name in item_attr_names(.data)) {
      attr(arg, attr_name) <- attr(.data, attr_name)
    }

    if (is_empty_item(.data)) {
      class(arg) <- c(purrr::head_while(class(.data),
                                        purrr::partial(`!=`, "navigatr_empty_item")),
                      "navigatr_empty_item",
                      class(arg))
    }

    arg
  }
}
