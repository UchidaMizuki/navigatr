#' @importFrom dplyr select
#' @export
select.navigatr_nav <- function(.data, ...) {
  keys <- set_names(.data$key)
  loc <- tidyselect::eval_select(expr(c(...)), keys)
  vec_slice(.data, loc)
}

#' @importFrom dplyr select
#' @export
select.navigatr_item <- function(.data, ...) {
  item_wrap(select)(.data, ...)
}

#' @importFrom dplyr group_by
#' @export
group_by.navigatr_item <- function(.data, ...) {
  item_wrap(group_by)(.data, ...)
}

#' @importFrom dplyr rowwise
#' @export
rowwise.navigatr_item <- function(.data, ...) {
  item_wrap(rowwise)(.data, ...)
}

#' @importFrom dplyr summarise
#' @export
summarise.navigatr_item <- function(.data, ...,
                           .groups = NULL) {
  item_wrap(summarise)(.data, ...,
                       .groups = .groups)
}

item_wrap <- function(.f) {
  function(.data, ...) {
    tree <- navigatr_tree(.data)
    attrs <- attributes(.data)[tree$attr_names]

    .data <- .f(unitem(.data), ...)

    item(.data,
         attrs = attrs,
         tree = tree)
  }
}
