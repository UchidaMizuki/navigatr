#' @export
activate <- function(.data, ..., .add = FALSE) {
  UseMethod("activate")
}

#' @export
activate.menu <- function(.data, ..., .add = FALSE) {
  vars <- enquos(...)

  if (!is_empty(vars)) {
    key <- .data$key
    loc <- which(key == tidyselect::vars_pull(key, !!vars[[1]]))
    .data <- new_item(.data, loc)

    vars <- vars[-1]
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

  loc <- path[[length(path)]]

  for (attr_name in attr_names) {
    vec_slice(parent, loc)$attrs[[attr_name]][[1]] <- attr(x, attr_name)
    attr(x, attr_name) <- NULL
  }

  x <- unitem(x)
  vec_slice(parent, loc)$value[[1]] <- x

  if (deep) {
    parent <- deactivate(parent)
  }
  parent
}
