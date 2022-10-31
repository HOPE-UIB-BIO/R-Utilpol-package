#' @title Flatten the list by one level
#' @param data_source A list
#' @description Return list without the first h-level. The names of the h1 and
#' h2 are merged
#' @export
flatten_list_by_one <-
    function(data_source) {
        
        check_class("data_source", "list")
        
        len <-
            length(data_source)

        names_high <-
            names(data_source)

        y <-
            vector("list", 0)

        for (i in 1:len) {
            sel_item <-
                data_source[[i]]

            names_low <-
                names(sel_item)

            names(sel_item) <-
                paste(names_high[i], names_low, sep = "-")

            y <-
                c(y, sel_item)
        }
        return(y)
    }
