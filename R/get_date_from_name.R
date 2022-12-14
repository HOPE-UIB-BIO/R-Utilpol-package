#' @title Get date from file name
#' @param data_source Character with name of a file
#' @return Character with date
get_date_from_name <-
    function(data_source) {
        check_class("data_source", "character")

        stringr::str_extract(
            data_source,
            "[:digit:][:digit:][:digit:][:digit:]-[:digit:][:digit:]-[:digit:][:digit:]"
        ) %>%
            return()
    }
