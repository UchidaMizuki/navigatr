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

subtle_comment <- function(...) {
  pillar::style_subtle(paste0("# ", ...))
}
