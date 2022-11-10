#' @title Get SHA from file name
#' @param data_source Character with name of a file
#' @return Character with SHA code
get_sha_from_name <-
    function(data_source) {
        check_class("data_source", "character")

        data_source %>%
            stringr::str_extract(
                ., "__.*__"
            ) %>%
            return()
    }
