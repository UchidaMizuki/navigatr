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
                          activated <- activate(x, key,
                                                .add = TRUE)
                          activated <- remove_item_class(activated)
                          pillar::obj_sum(activated)
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

  if (is_empty(path)) {
    checkbox <- cli::symbol$checkbox_off
  } else {
    loc <- path[[1]]
    checkbox <- ifelse(vec_seq_along(x) == loc,
                       cli::symbol$checkbox_on,
                       cli::symbol$checkbox_off)

    # TODO


  }

  out <- paste0(checkbox, " ",
                pillar::align(paste0(names(out), ": ")),
                out)

}

#' @export
print.menu <- function(x, ...) {
  writeLines(format(x))
  invisible(x)
}
