#' Get or set navigation description
#'
#' These functions get or set descriptions of items in menus and input forms.
#' Description is used to print a description of each item in the menu or form.
#' If no description is set, the result of [pillar::obj_sum()] is used for the
#' description.
#'
#' @param x An object to get or set the description for.
#' @param value A character string to set as the description.
#'
#' @return `nav_description()` returns the description of the object, or `NULL`
#' if no description is set. `nav_description<-` and `set_nav_description()`
#' return the modified object.
#'
#' @export
nav_description <- function(x) {
  attr(x, "navigatr_description", exact = TRUE)
}

#' @export
#' @rdname nav_description
`nav_description<-` <- function(x, value) {
  attr(x, "navigatr_description") <- value
  x
}

#' @export
#' @rdname nav_description
set_nav_description <- function(x, value) {
  nav_description(x) <- value
  x
}
