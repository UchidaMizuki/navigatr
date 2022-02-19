item <- function(x, attrs, tree) {
  exec(structure, x, !!!attrs,
       navigatr_tree = tree,
       class = c("navigatr_item", class(x)))
}

unitem <- function(x) {
  attr(x, "navigatr_tree") <- NULL
  class(x) <- setdiff(class(x), "navigatr_item")
  x
}

#' Test if an object is an item
#'
#' @param x An object.
#'
#' @return `TRUE` if the object inherits from the `navigatr_item` class.
#'
#' @export
is_item <- function(x) {
  inherits(x, "navigatr_item")
}

#' Rename a key
#'
#' @param data A `navigatr_item` object.
#' @param new_key New key name.
#'
#' @return A `navigatr_item` object.
#'
#' @export
rekey <- function(data, new_key) {
  item_key(data) <- new_key
  data
}

#' @export
format.navigatr_item <- function(x, ...) {
  subtle_comment(c(format_menu(deactivate(x), item_path(x)), ""))
}

#' @export
print.navigatr_item <- function(x, ...) {
  writeLines(format(x))

  if (is_menu(x)) {
    print_menu()
  } else {
    print(unitem(x))
  }
  invisible(x)
}

#' @export
vec_ptype_abbr.navigatr_item <- function(x) {
  "item"
}

navigatr_tree <- function(x) {
  attr(x, "navigatr_tree")
}

`navigatr_tree<-` <- function(x, value) {
  attr(x, "navigatr_tree") <- value
  x
}

item_key <- function(x) {
  navigatr_tree(x)$key %||% NA_character_
}

`item_key<-` <- function(x, value) {
  navigatr_tree(x)$key <- value
  x
}

item_parent <- function(x) {
  navigatr_tree(x)$parent %||% new_menu()
}

item_path <- function(x) {
  navigatr_tree(x)$path %||% integer()
}

item_attr_names <- function(x) {
  navigatr_tree(x)$attr_names %||% character()
}
