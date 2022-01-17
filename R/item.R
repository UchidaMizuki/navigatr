#' @export
new_item <- function(parent, loc) {
  sliced <- vec_slice(parent, loc)

  out <- first(sliced$value)
  item <- list(parent = parent,
               path = c(item_path(parent), loc),
               attrs = purrr::modify(as.list(sliced$attrs), first))

  structure(out,
            item = item,
            class = c("item", class(out)))
}

#' @export
is_item <- function(x) {
  inherits(x, "item")
}

#' @export
format.item <- function(x, ...) {
  subtle_comment(format_menu(deactivate(x), item_path(x)))
}

#' @export
print.item <- function(x, ...) {
  writeLines(format(x))

  if (!is_menu(x)) {
    writeLines(subtle_comment())
    print(remove_item_class(x))
  }
  invisible(x)
}

#' @export
item_parent <- function(x) {
  attr(x, "item")$parent %||% new_tbl_menu()
}

#' @export
item_path <- function(x) {
  attr(x, "item")$path %||% integer()
}

#' @export
item_attrs <- function(x) {
  attr(x, "item")$attrs
}
