#' @title Check if the selected object is a color
#' @param data_source Character. Name of the vector to check
#' @description The vector can contain both name of a color or a hex value
#' @seealso [is_color()]
#' @export
check_color <- function(data_source) {
  parent_frame <-
    sys.parent()

  parent_env <-
    sys.frame(which = parent_frame)

  data_source_obj <-
    get(
      data_source,
      envir = parent_env
    )

  check_class("data_source_obj", "character")

  assertthat::assert_that(
    is_color(data_source_obj),
    msg = paste0(
      "'", data_source, "' must be a valid color or hex"
    )
  )
}
