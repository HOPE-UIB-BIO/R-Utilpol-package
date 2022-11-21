#' @title Detect the newest version of the selected file
#' @param file_name Name of the object to save in quotes
#' @param dir Directory path
#' @param folder Logical. Is the selected file a folder?
#' @param verbose Logical. Should there be output error message?
#' @return Object name of the most recent file
#' @description look into the `dir` folder and find the version of the file
#' with the most recent name
#' @export
get_latest_file_name <-
    function(file_name,
             dir = here::here(),
             folder = FALSE,
             verbose = TRUE) {
        check_class("file_name", c("character", "logical"))

        check_class("dir", "character")

        check_class("folder", "logical")

        check_class("verbose", "logical")

        # helper functions
        check_vector_length <-
            function(sel_vec) {
                if (
                    length(sel_vec) == 0
                ) {
                    if (
                        verbose == TRUE
                    ) {
                        usethis::ui_oops("Selected file not present")
                    }
                    return()
                }
            }

        if (
            folder == TRUE
        ) {
            file_full_list <-
                list.dirs(dir, recursive = FALSE, full.names = FALSE)
        } else {
            file_full_list <-
                list.files(dir, recursive = FALSE, full.names = FALSE)
        }

        file_list_selected_files <-
            subset(
                file_full_list,
                stringr::str_detect(file_full_list, file_name)
            )

        check_vector_length(file_list_selected_files)

        if (
            folder == FALSE
        ) {
            date_apend <-
                paste0(
                    ".",
                    get_date_from_name(file_list_selected_files),
                    ".*"
                )

            file_list_striped <-
                stringr::str_replace(
                    string = file_list_selected_files,
                    pattern = date_apend,
                    ""
                )

            file_list_exact_names <-
                subset(
                    file_list_selected_files,
                    file_list_striped == file_name
                )
        } else {
            file_list_exact_names <- file_list_selected_files
        }

        check_vector_length(file_list_exact_names)

        if (
            length(file_list_exact_names) == 1
        ) {
            return(file_list_exact_names)
        }

        if (
            length(file_list_exact_names) > 1
        ) {
            file_list_exact_names <-
                stringr::str_sort(file_list_exact_names, decreasing = TRUE)

            newest_file <- file_list_exact_names[1]

            return(newest_file)
        }

        return(NA_character_)
    }
