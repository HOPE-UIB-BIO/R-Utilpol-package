#' @title Detect the newest version of the selected folder
#' @param folder_name Name of the object to save in quotes
#' @param dir Directory path
#' @return Object name of the most recent folder
#' @description look into the `dir` folder and find the version of the folder
#' with the most recent name
#' @export
get_latest_name_folder <-
    function(folder_name,
             dir = here::here()) {
        check_class("folder_name", c("character", "logical"))

        check_class("dir", "character")

        file_full_list <-
            list.files(dir)

        folder_list <-
            stringr::str_sort(file_full_list, decreasing = TRUE)

        newest_file <-
            folder_list[1]

        return(newest_file)
    }
