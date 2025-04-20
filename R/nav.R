new_nav <- function(
  key = character(),
  value = list(list()),
  description = NULL,
  attrs = data_frame(.size = 1L),
  ...,
  class = character()
) {
  key <- vec_cast(key, character())

  if (vec_duplicate_any(key)) {
    abort("`key` must not be duplicated.")
  }

  if (!is_list(value)) {
    abort("`value` must be a list.")
  }

  new_data_frame(
    df_list(
      key = key,
      value = value,
      description = description,
      attrs = attrs %||% data_frame(.size = 1L),
      .size = vec_size(key)
    ),
    ...,
    class = c(class, "navigatr_nav")
  )
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

  if (is_nav_menu(x)) {
    on <- cli::symbol$checkbox_on
    off <- cli::symbol$checkbox_off

    if (is_empty(path)) {
      loc <- NULL
      symbol <- off
    } else {
      loc <- path[[1L]]
      symbol <- vec_equal(vec_seq_along(x), loc, na_equal = TRUE)
      symbol <- ifelse(symbol, on, off)
    }

    out <- paste0(
      symbol,
      " ",
      pillar::align(paste0(names(out), ": ")),
      out,
      recycle0 = TRUE
    )

    if (!is.null(loc)) {
      path <- path[-1L]
      child <- activate(x, loc, .add = TRUE)

      if (is_nav(child)) {
        out_child <- paste0("  ", format_nav(child, path), recycle0 = TRUE)
        out <- append(out, out_child, loc)
      }
    }
  } else if (is_nav_input(x)) {
    on <- cli::symbol$tick
    off <- cli::symbol$cross

    symbol <- ifelse(purrr::map_lgl(x$value, purrr::negate(is_empty)), on, off)
    out <- paste0(
      symbol,
      " ",
      pillar::align(paste0(names(out), ": ")),
      out,
      recycle0 = TRUE
    )
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
  if (is_nav_menu(x)) {
    writeLines(subtle_comment("Please `activate()`."))
  } else if (is_nav_input(x)) {
    writeLines(subtle_comment("Please `itemise()`."))
  }
}

#' @export
size_sum.navigatr_nav <- function(x) {
  paste0("[", big_mark(vec_size(x)), "]")
}
