#' @importFrom dplyr group_by
#' @export
group_by.item <- function(.data, ...) {
  item_wrap(group_by)(.data, ...)
}

#' @importFrom dplyr rowwise
#' @export
rowwise.item <- function(.data, ...) {
  item_wrap(rowwise)(.data, ...)
}

#' @importFrom dplyr summarise
#' @export
summarise.item <- function(.data, ...,
                           .groups = NULL) {
  item_wrap(summarise)(.data, ...,
                       .groups = .groups)
}

item_wrap <- function(.f) {
  function(.data, ...) {
    attr_item <- attr(.data, "item")
    attrs <- attributes(.data)[attr_item$attr_names]

    .data <- .f(unitem(.data), ...)

    item(.data,
         attrs = attrs,
         attr_item = attr_item)
  }
}
