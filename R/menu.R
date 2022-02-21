#' Build a new navigation menu
#'
#' To build a new navigation menu, give `new_menu()` unique keys and a list of their corresponding values.
#' The top row shows the menu items (keys on the left, value summaries on the right).
#' The summaries are [pillar::obj_sum] outputs, so you can change the printing methods.
#' Each menu item can be accessed by [activate()].
#'
#' @param key A unique character vector.
#' If the key is not a character vector, it is converted to a character vector by [as.character()].
#' @param value A list of values corresponding to the keys.
#' If the value is not a list, it is converted to a list by [as.list()].
#' @param attrs A data frame for additional attributes of items (an empty data frame by default).
#' When an item becomes active, the attrs will be added to its attributes.
#' @param ... Additional arguments passed to [vctrs::new_data_frame()].
#' @param class A character vector of subclasses passed to [vctrs::new_data_frame()].
#'
#' @return A `navigatr_menu` object, a subclass of class `data.frame`.
#'
#' @seealso [activate()]
#'
#' @examples
#' library(dplyr)
#'
#' band <- new_menu(key = c("band_members", "band_instruments"),
#'                  value = list(band_members, band_instruments))
#' band
#'
#' # You can also build a nested menu
#' bands <- new_menu(key = c("key1", "key2"),
#'                   value = list(band, band))
#' bands
#'
#' @export
new_menu <- function(key = character(),
                     value = list(),
                     attrs = data_frame(.size = 1), ...,
                     class = character()) {
  key <- as.character(key)
  value <- as.list(value)
  stopifnot(
    !vec_duplicate_any(key),
    is.data.frame(attrs)
  )

  new_data_frame(df_list(key = key,
                         value = value,
                         attrs = attrs), ...,
                 class = c(class, "navigatr_menu"))
}

#' Test if the object is a menu
#'
#' @param x An object.
#'
#' @return `TRUE` if the object inherits from the `navigatr_menu` class.
#'
#' @export
is_menu <- function(x) {
  inherits(x, "navigatr_menu")
}

#' @importFrom pillar tbl_sum
#' @export
tbl_sum.navigatr_menu <- function(x) {
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
format.navigatr_menu <- function(x, ...) {
  subtle_comment(c(format_menu(x), ""))
}

format_menu <- function(x, path = integer()) {
  out <- tbl_sum(x)

  if (is_empty(path)) {
    loc <- NULL
    checkbox <- cli::symbol$checkbox_off
  } else {
    loc <- path[[1]]
    checkbox <- ifelse(vec_equal(vec_seq_along(x), loc,
                                 na_equal = TRUE),
                       cli::symbol$checkbox_on,
                       cli::symbol$checkbox_off)
  }

  out <- paste0(checkbox, " ",
                pillar::align(paste0(names(out), ": ")),
                out)

  if (!is.null(loc)) {
    path <- path[-1]
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
print.navigatr_menu <- function(x, ...) {
  writeLines(format(x))
  print_menu()
  invisible(x)
}

print_menu <- function() {
  writeLines(subtle_comment("Please `activate()` an item."))
}

#' @export
vec_ptype_abbr.navigatr_menu <- function(x) {
  "menu"
}
