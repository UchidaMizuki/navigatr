#' @export
activate <- function(.data, ..., .add = FALSE) {
  UseMethod("activate")
}

#' @export
activate.menu <- function(.data, ..., .add = FALSE) {
  vars <- enquos(...)

  if (!is_empty(vars)) {
    key <- .data$key
    loc <- tidyselect::vars_pull(key, !!vars[[1]])
    loc <- which(key == loc)
    vars <- vars[-1]

    .data <- new_item(.data, loc)

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
  attrs <- item_attrs(x)

  loc <- last(path)

  attr(x, "item") <- NULL
  x <- remove_item_class(x)

  first(vec_slice(parent, loc)$value) <- x

  nms <- names(attrs)
  for (nm in nms) {
    first(vec_slice(parent, loc)$attrs[[nm]]) <- attrs[[nm]]
  }

  if (deep) {
    parent <- deactivate(parent)
  }
  parent
}
