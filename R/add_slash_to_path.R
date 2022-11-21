#' @title add `/` to the path if needed
#' @param data_source Character. path
#' @return Path with `/` at the end
#' @export
add_slash_to_path <-
  function(data_source) {
    check_class("data_source", "character")

    dir_last <-
      stringr::str_sub(
        data_source,
        start = stringr::str_length(data_source),
        stringr::str_length(data_source)
      )

    if (
      dir_last != "/"
    ) {
      data_source <-
        paste0(data_source, "/")
    }

    return(data_source)
  }
