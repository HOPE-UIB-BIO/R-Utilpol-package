#' @title Replace NULL with N
#' @param data_source Any R object
#' @description Helper function. If `data_source` is `NULL` then replace with `NA`
#' @export
replace_null_with_na <-
  function(data_source) {
    ifelse(is.null(data_source) == TRUE, NA, data_source) %>%
      return()
  }
