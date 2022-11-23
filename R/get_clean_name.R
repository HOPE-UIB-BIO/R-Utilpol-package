#' @title get a name of clean name of file
#' @param data_source Character. Name of a file
#' @return Name of a file without date and SHA code
#' @export
get_clean_name <-
  function(data_source) {

    # detect dates
    data_source_date_apend <-
      paste0(
        ".",
        get_date_from_name(data_source),
        ".*"
      )

    # remove dates
    data_source_striped <-
      stringr::str_replace(
        string = data_source,
        pattern = data_source_date_apend,
        ""
      )

    return(data_source_striped)
  }
