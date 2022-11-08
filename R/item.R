item <- function(x, attrs, tree) {
  exec(structure, x, !!!attrs,
       navigatr_tree = tree,
       class = c("navigatr_item", class(x)))
}

unitem <- function(x,
                   remove_attrs = TRUE) {
  if (remove_attrs) {
    for (attr_name in item_attr_names(x)) {
      attr(x, attr_name) <- NULL
    }
  }

  navigatr_tree(x) <- NULL
  class(x) <- setdiff(class(x), "navigatr_item")
  x
}

is_item <- function(x) {
  inherits(x, "navigatr_item")
}

#' @export
format.navigatr_item <- function(x, ...) {
  subtle_comment(c(format_nav(deactivate(x), item_path(x)), ""))
}

#' @export
print.navigatr_item <- function(x, ...) {
  writeLines(format(x))

  if (is_nav(x)) {
    print_nav_msg(x)
  } else {
    print(unitem(x))
  }
  invisible(x)
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
  navigatr_tree(x)$parent %||% new_nav_menu()
}

item_path <- function(x) {
  navigatr_tree(x)$path %||% integer()
}

item_attr_names <- function(x) {
  navigatr_tree(x)$attr_names %||% character()
}
