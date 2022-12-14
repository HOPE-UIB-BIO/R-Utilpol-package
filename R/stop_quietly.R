#' @title Stop the script
#' @description  Stop the script without producing error
#' @export
stop_quietly <-
  function() {
    opt <-
      options(show.error.messages = FALSE)
    on.exit(options(opt))
    stop()
  }
