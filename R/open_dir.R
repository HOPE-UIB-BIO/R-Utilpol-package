#' @title Open selected directory
#' @param dir Path to the directory
#' @return NULL
#' @export
open_dir <-
  function(dir = here::here()) {
    check_class("dir", "character")

    if (
      .Platform["OS.type"] == "windows"
    ) {
      shell.exec(dir)
    } else {
      system(
        paste(
          Sys.getenv("R_BROWSER"), dir
        )
      )
    }
  }
