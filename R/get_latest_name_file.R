#' @title Detect the newest version of the selected file
#' @param file_name Name of the object to save in quotes
#' @param dir Directory path
#' @param silent. Logical. Should error message be ouput
#' @return Object name of the most recent file
#' @description look into the `dir` folder and find the version of the file
#' with the most recent name
#' @export
get_latest_name_file <-
    function(file_name,
             dir,
             silent = FALSE) {
        check_class("file_name", c("character", "logical"))

        check_class("dir", "character")

        file_full_list <-
            list.files(dir)

        file_list_selected_files <-
            subset(
                file_full_list,
                stringr::str_detect(file_full_list, file_name)
            )

        if (
            length(file_list_selected_files) == 0
        ) {
            newest_file <- NA

            if (
                silent == FALSE
            ) {
                usethis::ui_oops("Selected file not present")
            }
        } else {
            file_list_selected_files <-
                stringr::str_sort(file_list_selected_files, decreasing = TRUE)

            newest_file <- file_list_selected_files[1]
        }

        return(newest_file)
    }
