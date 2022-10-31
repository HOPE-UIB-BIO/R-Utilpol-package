#' @title Output boxed message in console
#' @param msg String with the message that should be printed
#' @param size Select the hierarchy of the heading (1-3)
#' @return NULL
#' @export
output_heading <-
  function(msg = "",
           size = c("h1", "h2", "h3")) {
    assertthat::assert_that(
      assertthat::is.string(msg),
      msg = "'msg' must be a 'string'"
    )

    check_class("size", "character")

    check_vector_values("size", c("h1", "h2", "h3"))

    sep_line <-
      switch(size,
        h1 = "#----------------------------------------------------------#",
        h2 = "#--------------------------------------------------#",
        h3 = "#----------------------------------------#"
      )

    cat("\n")
    usethis::ui_line(sep_line)
    output_comment(msg = msg)
    usethis::ui_line(sep_line)
    cat("\n")
  }
