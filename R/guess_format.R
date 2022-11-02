guess_format <-
    function(data_source) {
        if (
            stringr::str_detect(data_source, ".rds")
        ) {
            sel_format <- "rds"
        } else if (
            stringr::str_detect(data_source, ".csv")
        ) {
            sel_format <- "csv"
        } else {
            sel_format <- "NA_char"
        }

        return(sel_format)
    }
