#' @title Detect the newest version of the selected file and load it
#' @param file_name Name of the object to save in quotes
#' @param dir Directory path
#' @param verbose Logical. Should there be output message?
#' @return Object of latest version of the `file_name`
#' @description Look into the folder `dir` and find the version of the file with
#'  the most recent date and load it
#' @export
get_latest_file <-
    function(file_name,
             dir = here::here(),
             verbose = TRUE) {
        current_frame <-
            sys.nframe()
        current_env <-
            sys.frame(which = current_frame)

        check_class("file_name", "character")

        check_class("dir", "character")

        file_last_name <-
            get_latest_file_name(
                file_name = file_name,
                dir = dir
            )

        if (
            is.na(file_last_name)
        ) {
            if (
                verbose == TRUE
            ) {
                stop(
                    paste(
                        "Did not detect file",
                        paste_as_vector(file_name),
                        "in",
                        paste_as_vector(dir)
                    )
                )
            } else {
                stop_quietly()
            }
        }

        file_format <-
            get_format_from_name(file_last_name)

        if (
            is.na(file_format)
        ) {
            if (
                verbose == TRUE
            ) {
                stop("Cannot extract file format")
            } else {
                stop_quietly()
            }
        }

        # assing NULL to prevent the R-CMD-check to fail
        data_object <- NULL

        # choose function based on the 'file_format'
        #   and create a function call
        switch(file_format,
            "csv" = {
                # create a function call
                fc_command <-
                    paste0(
                        "data_object <- readr::read_csv(",
                        "'", dir, "/", file_last_name, "',",
                        "show_col_types = FALSE",
                        ")"
                    )
            },
            "qs" = {
                fc_command <-
                    paste0(
                        "data_object <- qs::qread(",
                        "'", dir, "/", file_last_name, "'",
                        ")"
                    )
            },
            "rds" = {
                fc_command <-
                    paste0(
                        "data_object <- readr::read_rds(",
                        "'", dir, "/", file_last_name, "'",
                        ")"
                    )
            },
            {
                stop("File does not have supported format.")
            }
        )

        # evaluate function (assign the table)
        eval(
            parse(text = fc_command),
            envir = current_env
        )

        if (
            verbose == TRUE
        ) {
            usethis::ui_done(
                paste("Automatically loaded file", file_last_name)
            )
        }

        return(data_object)
    }
