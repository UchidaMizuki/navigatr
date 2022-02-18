item <- function(x, attrs, attr_item) {
  exec(structure, x, !!!attrs,
       item = attr_item,
       class = c("item", class(x)))
}

unitem <- function(x) {
  attr(x, "item") <- NULL
  class(x) <- setdiff(class(x), "item")
  x
}

#' Test if an object is an item
#'
#' @param x An object.
#'
#' @return `TRUE` if the object inherits from the `item` class.
#'
#' @export
is_item <- function(x) {
  inherits(x, "item")
}

#' @export
format.item <- function(x, ...) {
  subtle_comment(c(format_menu(deactivate(x), item_path(x)), ""))
}

#' @export
print.item <- function(x, ...) {
  writeLines(format(x))

  if (is_menu(x)) {
    print_menu()
  } else {
    out <- unitem(x)

    # For tibble printing problems
    if (tibble::is_tibble(out) && !tibble::has_rownames(out)) {
      out <- tibble::remove_rownames(out)
    }
    print(out)
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
