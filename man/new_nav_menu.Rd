% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/nav_menu.R
\name{new_nav_menu}
\alias{new_nav_menu}
\title{Build a new menu}
\usage{
new_nav_menu(
  key = character(),
  value = list(data.frame()),
  description = NULL,
  attrs = NULL,
  ...,
  class = character()
)
}
\arguments{
\item{key}{A unique character vector.}

\item{value}{A list of values corresponding to the keys.}

\item{description}{A character vector of descriptions for the keys. By
default, the description from \code{\link[pillar:type_sum]{pillar::obj_sum()}} is displayed.}

\item{attrs}{A data frame for additional attributes of items (an empty data
frame by default).
When an item becomes active, the attrs will be added to its attributes.}

\item{...}{Additional arguments passed to \code{\link[vctrs:new_data_frame]{vctrs::new_data_frame()}}.}

\item{class}{A character vector of subclasses passed to \code{\link[vctrs:new_data_frame]{vctrs::new_data_frame()}}.}
}
\value{
A \code{navigatr_nav_menu} object, a subclass of class \code{data.frame}.
}
\description{
To build a new menu, give \code{new_nav_menu()} unique keys and a list of their
corresponding values.
Each line shows the menu items (keys on the left, value descriptions on the
right).
By default, the description from \code{\link[pillar:type_sum]{pillar::obj_sum()}} is displayed, but you
can set \code{description}.
Each menu item can be accessed by \code{\link[=activate]{activate()}}.
}
\examples{
library(dplyr)

band <- new_nav_menu(
  key = c("band_members", "band_instruments"),
  value = list(band_members, band_instruments),
  description = c(
    "A data frame of band members",
    "A data frame of band instruments"
  )
)
band

# You can also build a nested menu
bands <- new_nav_menu(
  key = c("key1", "key2"),
  value = list(band, band)
)
bands

}
\seealso{
\code{\link[=activate]{activate()}}
}
