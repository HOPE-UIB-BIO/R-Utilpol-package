#' @title Testing any criteria and open folder with msg if not true
#' @param ... Unnamed expressions that describe the conditions to be tested
#' @param env The environment in which to evaluate the test
#' @param msg Error message to be printed
#' @param dir Path to the selected folder
#' @description Test a selected criteria an open selected directory if not true
#' @export
open_dir_if_not <-
  function(...,
           env = parent.frame(),
           dir = here::here(),
           msg) {
    res <-
      assertthat::see_if(..., env = env, msg = msg)

    if (
      !res
    ) {
      cat("\n")
      usethis::ui_oops(
        paste("WARNING:", attr(res, "msg"))
      )
      cat("\n")

      dir <- add_slash_to_path(dir)

      # open the folder
      open_dir(dir)

      stop_quietly()
    }
  }
