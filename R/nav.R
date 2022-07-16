new_nav <- function(key = character(),
                    value = list(),
                    attrs = data_frame(.size = 1L), ...,
                    class = character()) {
  key <- vec_cast(key, character())

  if (!is_list(value)) {
    value <- vec_chop(value)
  }

  stopifnot(
    !vec_duplicate_any(key)
  )

  new_data_frame(df_list(key = key,
                         value = value,
                         attrs = attrs %||% data_frame(.size = 1L),
                         .size = vec_size(key)), ...,
                 class = c(class, "navigatr_nav"))
}

is_nav <- function(x) {
  inherits(x, "navigatr_nav")
}

#' @export
format.navigatr_nav <- function(x, ...) {
  subtle_comment(c(format_nav(x), ""))
}

format_nav <- function(x, path = integer()) {
  out <- tbl_sum(x)

  if (is_menu(x)) {
    on <- cli::symbol$checkbox_on
    off <- cli::symbol$checkbox_off

    if (is_empty(path)) {
      loc <- NULL
      symbol <- off
    } else {
      loc <- path[[1L]]
      symbol <- ifelse(vec_equal(vec_seq_along(x), loc,
                                 na_equal = TRUE),
                       on,
                       off)
    }

    out <- paste0(symbol, " ",
                  pillar::align(paste0(names(out), ": ")),
                  out)

    if (!is.null(loc)) {
      path <- path[-1L]
      child <- activate(x, loc,
                        .add = TRUE)

      if (is_nav(child)) {
        out_child <- paste0("  ", format_nav(child, path))
        out <- append(out, out_child, loc)
      }
    }
  } else if (is_input(x)) {
    on <- cli::symbol$tick
    off <- cli::symbol$cross

    symbol <- ifelse(purrr::map_lgl(x$value, purrr::negate(is_empty)),
                     on,
                     off)
    out <- paste0(symbol, " ",
                  pillar::align(paste0(names(out), ": ")),
                  out)
  } else if (is_select(x)) {
    symbol <- cli::symbol$bullet
    out <- paste0(symbol, " ",
                  pillar::align(paste0(names(out), ": ")),
                  out)
  }
  out
}

#' @export
print.navigatr_nav <- function(x, ...) {
  writeLines(format(x))
  print_nav_msg(x)
  invisible(x)
}

print_nav_msg <- function(x) {
  if (is_menu(x)) {
    writeLines(subtle_comment("Please `activate()`."))
  } else if (is_input(x)) {
    writeLines(subtle_comment("Please `mutate()`."))
  } else if (is_select(x)) {
    writeLines(subtle_comment("Please `select()`."))
  }
}

#' @export
tbl_sum.navigatr_nav <- function(x) {
  key <- x$key
  out <- purrr::map_chr(key,
                        function(key) {
                          child <- activate(x, key,
                                            .add = TRUE)
                          pillar::obj_sum(unitem(child, remove_attrs = FALSE))
                        })
  names(out) <- key
  out
}

#' @export
size_sum.navigatr_nav <- function(x) {
  paste0("[", big_mark(vec_size(x)), "]")
}



#' Activate/deactivate a menu item
#'
#' Activates a menu item with the same syntax as [dplyr::pull()].
#' Activating a menu item allows you to perform operations on the active item.
#' `activate()` turns a `navigatr_nav` object into an `navigatr_item` object,
#' and `deactivate()` turns it back.
#'
#' @param .data A `navigatr_nav` object.
#' @param ... In `activate()`, one or more variables passed to [dplyr::pull()].
#' In `deactivate()`, unused (for extensibility).
#' @param .add Whether to add new variables to the path indices.
#' If `FALSE` (default value), the menu will be deactivated first by [deactivate()].
#' @param x A `navigatr_nav` object.
#' @param deep If `TRUE` (default value), deactivate recursively.
#'
#' @return In `activate()`, An `navigatr_item` object.
#' If it inherits from class `navigatr_nav`, the menu will be displayed hierarchically.
#' Otherwise, the active data will be displayed.
#' In `deactivate()`, A `navigatr_nav` object.
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
#'                     value = list(mn1, mn1))
#' mn2 %>%
#'   activate(key1, band_members)
#'
#' @export
activate <- function(.data, ...,
                     .add = FALSE) {
  UseMethod("activate")
}

#' @rdname activate
#' @export
activate.navigatr_nav <- function(.data, ...,
                                  .add = FALSE) {
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
activate.navigatr_item <- function(.data, ...,
                                   .add = FALSE) {
  if (!.add) {
    .data <- deactivate(.data)
  }

  if (!is_menu(.data)) {
    abort("Too many variables to activate.")
  }

  activate.navigatr_nav(.data, ...)
}

#' @rdname activate
#' @export
deactivate <- function(x, ...,
                       deep = TRUE) {
  UseMethod("deactivate")
}

#' @rdname activate
#' @export
deactivate.navigatr_nav <- function(x, ...,
                                    deep = TRUE) {
  x
}

#' @rdname activate
#' @export
deactivate.navigatr_item <- function(x, ...,
                                     deep = TRUE) {
  key <- item_key(x)
  parent <- item_parent(x)
  path <- item_path(x)
  attr_names <- item_attr_names(x)

  loc <- path[[vec_size(path)]]

  stopifnot(
    !key %in% parent$key[-loc]
  )

  parent$key[[loc]] <- key
  parent$value[[loc]] <- unitem(x)

  for (attr_name in attr_names) {
    parent$attrs[[attr_name]][[loc]] <- attr(x, attr_name)
  }

  if (deep) {
    parent <- deactivate(parent)
  }
  parent
}
