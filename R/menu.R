#' @export
new_menu <- function(key = character(),
                     value = list(),
                     attrs = NULL, ...,
                     class = character()) {
  new_data_frame(df_list(key = key,
                         value = value,
                         attrs = attrs), ...,
                 class = c(class, "menu"))
}

#' @export
is_menu <- function(x) {
  inherits(x, "menu")
}

#' @importFrom pillar tbl_sum
#' @export
tbl_sum.menu <- function(x) {
  key <- x$key
  out <- purrr::map_chr(key,
                        function(key) {
                          child <- activate(x, key,
                                            .add = TRUE)
                          child <- unitem(child)
                          pillar::obj_sum(child)
                        })
  names(out) <- key
  out
}

#' @export
format.menu <- function(x, ...) {
  subtle_comment(format_menu(x))
}

format_menu <- function(x, path = integer()) {
  out <- tbl_sum(x)

  loc <- first(path)
  checkbox <- ifelse(vec_equal(vec_seq_along(x), loc,
                               na_equal = TRUE),
                     cli::symbol$checkbox_on,
                     cli::symbol$checkbox_off)

  out <- paste0(checkbox, " ",
                pillar::align(paste0(names(out), ": ")),
                out)

  path <- tail(path)
  if (!is.na(loc)) {
    child <- activate(x, loc,
                      .add = TRUE)

    if (is_menu(child)) {
      out_child <- paste0("  ", format_menu(child, path))
      out <- append(out, out_child, loc)
    }
  }
  out
}

#' @export
print.menu <- function(x, ...) {
  writeLines(format(x))
  invisible(x)
}
