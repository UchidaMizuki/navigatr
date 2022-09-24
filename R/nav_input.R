#' @export
new_nav_input <- function(key = character(),
                          value = list(),
                          attrs = NULL, ...,
                          class = character()) {
  new_nav(key = key,
          value = value,
          attrs = attrs, ...,
          class = c(class, "navigatr_nav_input"))
}

is_nav_input <- function(x) {
  inherits(x, "navigatr_nav_input")
}

#' @export
vec_ptype_abbr.navigatr_nav_input <- function(x) {
  "nav_input"
}

#' #' @importFrom dplyr mutate
#' #' @export
#' mutate.navigatr_nav_input <- function(.data, ...) {
#'   args <- dots_list(...,
#'                     .named = TRUE,
#'                     .homonyms = "last")
#'   nms <- names(args)
#'   args <- unname(args)
#'
#'   keys <- .data$key
#'   stopifnot(
#'     nms %in% keys
#'   )
#'
#'   locs <- vec_match(nms, keys)
#'
#'   for (i in vec_seq_along(locs)) {
#'     loc <- locs[[i]]
#'
#'     value <- .data$value[[loc]]
#'
#'     arg <- args[[i]]
#'     navigatr_tree(arg) <- navigatr_tree(value)
#'     for (attr_name in item_attr_names(value)) {
#'       attr(arg, attr_name) <- attr(value, attr_name)
#'     }
#'
#'     .data$value[[loc]] <- arg
#'   }
#'   .data
#' }
