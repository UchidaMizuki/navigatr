#' @export
new_empty_item <- function(class = character()) {
  structure(list(),
            class = c(class, "navigatr_empty_item"))
}

is_empty_item <- function(x) {
  inherits(x, "navigatr_empty_item")
}

#' @export
vec_ptype_abbr.navigatr_empty_item <- function(x) {
  "empty"
}

# print.navigatr_empty_item <- function(x, ...) {
#   out <- x
#   for (attr_name in item_attr_names(out)) {
#     attr(out, attr_name) <- NULL
#   }
#   navigatr_tree(out) <- NULL
#   class(out) <- setdiff(class(out), "navigatr_empty_item")
#   print(out)
#
#   invisible(x)
# }
