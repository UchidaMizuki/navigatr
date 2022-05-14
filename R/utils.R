subtle_comment <- function(...) {
  pillar::style_subtle(paste0("# ", ...))
}

big_mark <- function(x, ...) {
  mark <- if (identical(getOption("OutDec"), ",")) "." else ","
  formatC(x, big.mark = mark, ...)
}
