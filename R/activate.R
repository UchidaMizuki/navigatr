#' @export
activate <- function(.data, ..., .add = FALSE) {
  UseMethod("activate")
}

#' @export
activate.menu <- function(.data, ..., .add = FALSE) {
  vars <- enquos(...)

  if (!is_empty(vars)) {
    key <- .data$key
    loc <- which(key == tidyselect::vars_pull(key, !!first(vars)))
    .data <- new_item(.data, loc)

    vars <- tail(vars)
    if (!is_empty(vars)) {
      .data <- activate(.data, !!!vars,
                        .add = TRUE)
    }
  }
  .data
}

#' @export
activate.item <- function(.data, ..., .add = FALSE) {
  if (!.add) {
    .data <- deactivate(.data)
  }
  activate.menu(.data, ...)
}

#' @export
deactivate <- function(x, ..., deep = TRUE) {
  UseMethod("deactivate")
}

#' @export
deactivate.default <- function(x, ..., deep = TRUE) {
  x
}

#' @export
deactivate.item <- function(x, ..., deep = TRUE) {
  parent <- item_parent(x)
  path <- item_path(x)
  attr_names <- item_attr_names(x)

  loc <- last(path)

  for (attr_name in attr_names) {
    first(vec_slice(parent, loc)$attrs[[attr_name]]) <- attr(x, attr_name)
  }

  x <- remove_item_attrs(x)
  x <- unitem(x)
  first(vec_slice(parent, loc)$value) <- x

  if (deep) {
    parent <- deactivate(parent)
  }
  parent
}
