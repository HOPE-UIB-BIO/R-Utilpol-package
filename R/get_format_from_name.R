#' @title Get format of  file name
#' @param data_source string with file name
#' @return String with format
get_format_from_name <-
    function(data_source) {
        check_class("data_source", "character")

        name_length <-
            stringr::str_length(data_source)

        name_last_5 <-
            stringr::str_sub(
                data_source,
                end = name_length,
                start = max(
                    c(
                        0,
                        name_length - 5
                    )
                )
            )

        sel_format <-
            stringr::str_extract(
                name_last_5,
                "\\..*"
            ) %>%
            stringr::str_replace(
                .,
                "\\.",
                ""
            )

        return(sel_format)
    }
