#' Activate/deactivate a menu item
#'
#' Activates a menu item with the same syntax as [dplyr::pull()].
#' Activating a menu item allows you to perform operations on the active item.
#' `activate()` turns a `menu` object into an `item` object,
#' and `deactivate()` turns it back.
#'
#' @param .data A menu.
#' @param ... In `activate()`, one or more variables passed to [dplyr::pull()].
#' In `deactivate()`, unused (for extensibility).
#' @param .add Whether to add new variables to the path indices.
#' If `FALSE` (default value), the menu will be deactivated first by [deactivate()].
#' @param x A `menu` object.
#' @param deep If `TRUE` (default value), deactivate recursively.
#'
#' @return In `activate()`, An `item` object.
#' If it inherits from class `menu`, the menu will be displayed hierarchically.
#' Otherwise, the active data will be displayed.
#' In `deactivate()`, A `menu` object.
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
activate.menu <- function(.data, ..., .add = FALSE) {
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
    attr_item <- list(parent = .data,
                      path = c(item_path(.data), loc),
                      attr_names = names2(attrs))
    .data <- item(x,
                  attrs = attrs,
                  attr_item = attr_item)

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
activate.item <- function(.data, ..., .add = FALSE) {
  if (!.add) {
    .data <- deactivate(.data)
  }

  stopifnot(
    is_menu(.data)
  )
  activate.menu(.data, ...)
}

#' @rdname activate
#' @export
deactivate <- function(x, ..., deep = TRUE) {
  UseMethod("deactivate")
}

#' @rdname activate
#' @export
deactivate.menu <- function(x, ..., deep = TRUE) {
  x
}

#' @rdname activate
#' @export
deactivate.item <- function(x, ..., deep = TRUE) {
  parent <- item_parent(x)
  path <- item_path(x)
  attr_names <- item_attr_names(x)

  loc <- path[[length(path)]]

  for (attr_name in attr_names) {
    parent$attrs[[loc]] <- attr(x, attr_name)
    attr(x, attr_name) <- NULL
  }

  parent$value[[loc]] <- unitem(x)

  if (deep) {
    parent <- deactivate(parent)
  }
  parent
}
