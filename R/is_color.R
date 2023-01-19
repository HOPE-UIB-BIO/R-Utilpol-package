#' @title Test if a character is a color
#' @param data_source Character with name of a color. Can be aslo a hex value
#' @return Logical
#' @export
is_color <- function(data_source) {
  check_class("data_source", "character")

  tryCatch(
    is.matrix(
      grDevices::col2rgb(data_source)
    ),
    error = function(e) FALSE
  )
}
