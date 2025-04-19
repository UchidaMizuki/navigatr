#' Set items
#'
#' @param .data A `navigatr_nav_input` object.
#' @param ... Key-value pairs.
#'
#' @return A `navigatr_nav_input` object.
#'
#' @export
itemise <- function(.data, ...) {
  args <- dots_list(..., .named = TRUE, .homonyms = "first")
  nms <- names(args)
  args <- unname(args)

  keys <- .data$key
  stopifnot(nms %in% keys)

  locs <- vec_match(nms, keys)

  for (i in vec_seq_along(locs)) {
    description <- nav_description(.data$value[[locs[[i]]]]) %||%
      nav_description(args[[i]])

    .data$value[[locs[[i]]]] <- vec_cast(args[[i]], .data$value[[locs[[i]]]])
    nav_description(.data$value[[locs[[i]]]]) <- description
  }
  .data
}

#' @rdname itemise
#' @export
itemize <- itemise
