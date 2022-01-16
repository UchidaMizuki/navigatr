new_tbl_menu <- function(x, ..., class) {
  new_data_frame(x, ...,
                 class = c(class, "tbl_menu"))
}

#' @export
tbl_menu <- function(key, data, attrs, ..., class) {
  vec_assert(key, character())

  x <- df_list(key = key,
               data = data,
               attrs = attrs)
  new_tbl_menu(x, ...,
               class = class)
}

#' @importFrom pillar tbl_sum
#' @export
tbl_sum.tbl_menu <- function(x) {

}

#' @export
format.tbl_menu <- function(x, ...) {

}

