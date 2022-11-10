#' @title Detect the newest version of the selected file and load it
#' @param file_name Name of the object to save in quotes
#' @param dir Directory path
#' @return Object of latest version of the `file_name`
#' @description Look into the folder `dir` and find the version of the file with
#'  the most recent date and load it
#' @export
get_latest_file <-
    function(file_name,
             dir) {
        current_frame <-
            sys.nframe()
        current_env <-
            sys.frame(which = current_frame)

        check_class("file_name", "character")

        check_class("dir", "character")

        file_last_name <-
            get_latest_name_file(
                file_name = file_name,
                dir = dir
            )

        file_format <-
            get_format_from_name(file_last_name)

        if (
            is.na(file_format)
        ) {
            stop("File does not have a format of 'qs' or 'csv'")
        }

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
            }
        )

        # evaluate function (assign the table)
        eval(
            parse(text = fc_command),
            envir = current_env
        )

        usethis::ui_done(
            paste("Automatically loaded file", file_last_name)
        )

        return(data_object)
    }
