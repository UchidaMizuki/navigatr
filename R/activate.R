#' Activate/deactivate a menu item
#'
#' Activates a menu item with the same syntax as [dplyr::pull()].
#' Activating a menu item allows you to perform operations on the active item.
#' `activate()` turns a `navigatr_menu` object into an `navigatr_item` object,
#' and `deactivate()` turns it back.
#'
#' @param .data A `navigatr_menu` object.
#' @param ... In `activate()`, one or more variables passed to [dplyr::pull()].
#' In `deactivate()`, unused (for extensibility).
#' @param .add Whether to add new variables to the path indices.
#' If `FALSE` (default value), the menu will be deactivated first by [deactivate()].
#' @param x A `navigatr_menu` object.
#' @param deep If `TRUE` (default value), deactivate recursively.
#'
#' @return In `activate()`, An `navigatr_item` object.
#' If it inherits from class `navigatr_menu`, the menu will be displayed hierarchically.
#' Otherwise, the active data will be displayed.
#' In `deactivate()`, A `navigatr_menu` object.
#'
#' @examples
#' library(dplyr)
#'
#' mn1 <- new_menu(key = c("band_members", "band_instruments"),
#'                 value = list(band_members, band_instruments))
#'
#' mn1 %>%
#'   activate(band_members) %>%
#'   filter(band == "Beatles")
#'
#' # Items can also be specified as integers
#' mn1 %>%
#'   activate(2)
#'
#' mn1 %>%
#'   activate(-1) %>%
#'   deactivate()
#'
#' # To activate items in a nested menu, specify multiple variables
#' mn2 <- new_menu(key = c("key1", "key2"),
#'                 value = list(mn1, mn1))
#' mn2 %>%
#'   activate(key1, band_members)
#'
#' @export
activate <- function(.data, ..., .add = FALSE) {
  UseMethod("activate")
}

#' @rdname activate
#' @export
activate.navigatr_menu <- function(.data, ..., .add = FALSE) {
  vars <- enquos(...)

  if (!is_empty(vars)) {
    key <- .data$key
    loc <- which(key == tidyselect::vars_pull(key, !!vars[[1]]))

    # item
    child <- vec_slice(.data, loc)
    x <- child$value[[1]]
    attrs <- purrr::modify(as.list(child$attrs),
                           function(x) {
                             x[[1]]
                           })
    tree <- list(key = key[[loc]],
                 parent = .data,
                 path = c(item_path(.data), loc),
                 attr_names = names2(attrs))
    .data <- item(x,
                  attrs = attrs,
                  tree = tree)

    # activate recursively
    vars <- vars[-1]
    if (!is_empty(vars)) {
      .data <- activate(.data, !!!vars,
                        .add = TRUE)
    }
  }
  .data
}

#' @rdname activate
#' @export
activate.navigatr_item <- function(.data, ..., .add = FALSE) {
  if (!.add) {
    .data <- deactivate(.data)
  }

  stopifnot(
    is_menu(.data)
  )
  activate.navigatr_menu(.data, ...)
}

#' @rdname activate
#' @export
deactivate <- function(x, ..., deep = TRUE) {
  UseMethod("deactivate")
}

#' @rdname activate
#' @export
deactivate.navigatr_menu <- function(x, ..., deep = TRUE) {
  x
}

#' @rdname activate
#' @export
deactivate.navigatr_item <- function(x, ..., deep = TRUE) {
  key <- item_key(x)
  parent <- item_parent(x)
  path <- item_path(x)
  attr_names <- item_attr_names(x)

  loc <- path[[vec_size(path)]]

  parent$key[[loc]] <- key
  parent$value[[loc]] <- unitem(x)

  for (attr_name in attr_names) {
    parent$attrs[[attr_name]][[loc]] <- attr(x, attr_name)
    attr(x, attr_name) <- NULL
  }

  if (deep) {
    parent <- deactivate(parent)
  }
  parent
}
