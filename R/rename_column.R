#' @title Change the name of a column id data.frame
#' @param data_source Data.frame to use
#' @param old_name Character. The old name of a column
#' @param new_name Character. The new name of a column
#' @return Data.frame with the new name
#' @description Detect if a table has a column with `old_name` and replace
#' it with `new_name`
#' @export
rename_column <-
  function(data_source,
           old_name,
           new_name) {
    check_class("data_source", "data.frame")

    check_class("old_name", "character")

    check_class("new_name", "character")

    # if there is an old_name in the data
    if (
      any(names(data_source) %in% old_name)
    ) {
      data_new <-
        data_source %>%
        dplyr::rename(!!new_name := dplyr::all_of(old_name))

      return(data_new)
    } else {
      return(data_source)
    }
  }
