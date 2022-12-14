#' @title Confirm that the selected file is present in selected environment
#' @param file_name Name of the selected file
#' @param env The environment to test the presence of the file in
#' @param verbose Logical. Should there be output message?
#' @export
check_if_loaded <-
  function(file_name,
           env = rlang::current_env,
           verbose = TRUE) {
    check_class("file_name", "character")

    check_class("env", "environment")


    if (
      verbose == TRUE
    ) {
      stop_if_not(
        exists(
          eval(file_name),
          envir = env
        ),
        false_msg = paste(
          paste_as_vector(file_name), "was not loaded"
        ),
        true_msg = paste(
          paste_as_vector(file_name), "was successfully loaded"
        )
      )
    }

    if (
      !exists(
        eval(file_name),
        envir = env
      )
    ) {
      stop_quietly()
    }
  }
