#' @title Compare two datasets
#' @param file_a The object A to compare
#' @param file_b The object B to compare
#' @description Compare the two files and return if same
#' @return Logical. Are those file the same?
compare_files <-
    function(file_a,
             file_b,
             file_a_envir = NULL,
             file_b_envir = NULL) {

        # assume that data is different
        is_data_same <- FALSE

        # use `waldo` to compare
        waldo_result <-
            waldo::compare(
                file_a,
                file_b
            )

        if (
            length(waldo_result) == 0
        ) {
            is_data_same <- TRUE
        }

        return(is_data_same)
    }
