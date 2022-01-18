#' @export
new_item <- function(parent, loc) {
  child <- vec_slice(parent, loc)

  out <- first(child$value)
  attrs <- purrr::modify(as.list(child$attrs), first)
  item <- list(parent = parent,
               path = c(item_path(parent), loc),
               attr_names = names2(attrs))
  exec(structure, out, !!!attrs,
       item = item,
       class = c("item", class(out)))
}

#' @export
is_item <- function(x) {
  inherits(x, "item")
}

unitem <- function(x) {
  attr(x, "item") <- NULL
  class(x) <- setdiff(class(x), "item")
  x
}

#' @export
format.item <- function(x, ...) {
  subtle_comment(c(format_menu(deactivate(x), item_path(x)), ""))
}

#' @export
print.item <- function(x, ...) {
  writeLines(format(x))

  if (!is_menu(x)) {
    print(unitem(x))
  } else {
    print_menu()
  }
  invisible(x)
}

item_parent <- function(x) {
  attr(x, "item")$parent %||% new_menu()
}

item_path <- function(x) {
  attr(x, "item")$path %||% integer()
}

item_attr_names <- function(x) {
  attr(x, "item")$attr_names %||% character()
}
