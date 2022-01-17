first <- function(x) {
  `[[`(x, 1L)
}

`first<-` <- function(x, value) {
  `[[<-`(x, 1L, value)
}

last <- function(x) {
  `[[`(x, length(x))
}

remove_item_class <- function(x) {
  class(x) <- setdiff(class(x), "item")
  x
}

subtle_comment <- function(...) {
  pillar::style_subtle(paste0("# ", ...))
}
