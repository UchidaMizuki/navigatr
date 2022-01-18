first <- function(x, default = vec_init(x)) {
  if (is_empty(x)) {
    default
  } else {
    x[[1L]]
  }
}

`first<-` <- function(x, value) {
  `[[<-`(x, 1L, value)
}

last <- function(x) {
  x[[length(x)]]
}

tail <- function(x) {
  x[-1]
}

unitem <- function(x) {
  attr(x, "item") <- NULL
  class(x) <- setdiff(class(x), "item")
  x
}

remove_item_attrs <- function(x) {
  attrs <- attributes(x)
  attr_names <- item_attr_names(x)
  `attributes<-`(x, attrs[setdiff(names(attrs), attr_names)])
}

subtle_comment <- function(...) {
  pillar::style_subtle(paste0("# ", ...))
}
