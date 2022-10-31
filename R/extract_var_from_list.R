#' @title Helper function to extract data safely
#' @param var Name of the variable
#' @param dataset A list
#' @export
extract_var_from_list <-
  function(var, dataset) {
    check_class("var", "character")

    check_class("dataset", "list")

    ifelse(var %in% names(dataset),
      replace_null_with_na(dataset[[var]]),
      NA
    )
  }
