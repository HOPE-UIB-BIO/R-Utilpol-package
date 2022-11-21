#' @title Open selected directory
#' @param dir Path to the directory
#' @return NULL
#' @export
open_dir <-
  function(dir = here::here()) {
    check_class("dir", "character")

    dir <- add_slash_to_path(dir)

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
