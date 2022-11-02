#' @title Helper function to extract data safely
#' @param data_source_var Name of the data_source_variable
#' @param data_source_list A list
#' @export
extract_var_from_list <-
  function(data_source_var,
           data_source_list) {
    check_class("data_source_var", "character")

    check_class("data_source_list", "list")

    ifelse(data_source_var %in% names(data_source_list),
      replace_null_with_na(data_source_list[[data_source_var]]),
      NA
    )
  }
