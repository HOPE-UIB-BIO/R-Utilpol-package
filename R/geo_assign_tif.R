#' @title Extract data from TIF file and add as points
#' @param data_source  Data.frame containing `long` and `lat`
#' @param tif_file_name Name of a shape file to use
#' @param fill_na Logical. If TRUE, function will search for the most common value
#'  in the increasing distance of 'distance_step'
#' @param na_as_value Use for values of tiff file, which should be treated as
#'  NA for the purposes of looking for additional value.
#' @param distance_step Numeric. Distance in meters giving radius to increase the
#'  search radius
#' @param n_max_step Numeric. Maximum number of step increases.
#' @return Data.frame with additional columns
#' @description Extract data from tif file and add to points provided based
#'  on the data `lat` and `long`. If `fill_na` == TRUE, function will search for
#'  the most common value in the increasing distance of `distance_step`.
#'  Function will stop search if all values are found.
#' @export
geo_assign_tif <-
  function(data_source,
           tif_file_name = "",
           fill_na = FALSE,
           na_as_value = NULL,
           distance_step = 500,
           n_max_step = 10) {
    check_class("data_source", "data.frame")

    check_col_names("data_source", c("lat", "long"))

    check_class("tif_file_name", "character")

    check_class("fill_na", "logical")

    if (
      isTRUE(fill_na)
    ) {
      check_class("distance_step", "numeric")

      check_class("n_max_step", "numeric")

      check_if_integer("n_max_step")
    } else {
      assertthat::assert_that(
        is.null(na_as_value),
        msg = "'fill_na' must be TRUE for 'na_as_value' to be set (not null)"
      )
    }

    data_source_coord <-
      data_source %>%
      dplyr::select("lat", "long")

    # Create a raster stack of your raster file
    raster_object <- terra::rast(tif_file_name)

    # Read point data, and convert them into spatial points data frame.
    point_df <-
      terra::vect(data_source_coord, geom = c("long", "lat"))

    # Extract raster value by points
    raster_value <-
      terra::extract(raster_object, point_df) %>%
      tibble::column_to_rownames("ID") %>%
      dplyr::pull(1)

    # replace the selected value with NA
    if (
      isFALSE(is.null(na_as_value)) && isTRUE(fill_na)
    ) {
      raster_value[raster_value == na_as_value] <- NA
    }

    data_with_values <-
      data_source %>%
      dplyr::mutate(
        raster_values = raster_value
      )

    # search for the closest value for NAs
    if (
      any(is.na(raster_value)) && isTRUE(fill_na)
    ) {
      output_comment(
        msg = "Searching for the closest value for NAs"
      )

      for (i in 1:n_max_step) {
        buffer_value <- distance_step * i

        cat(
          paste("distance =", buffer_value, "m"), "\n"
        )

        data_with_values <-
          data_with_values %>%
          dplyr::mutate(
            raster_values = purrr::pmap(
              .progress = "Searching for closest value",
              .l = list(
                long,
                lat,
                raster_values
              ),
              .f = ~ {
                if (
                  isFALSE(is.na(..3))
                ) {
                  return(..3)
                }

                # Create a small buffer around the point to search for non-NA values
                search_window <-
                  terra::buffer(
                    terra::vect(
                      data.frame(
                        long = ..1,
                        lat = ..2
                      ),
                      geom = c("long", "lat")
                    ),
                    width = 500
                  )
                # Extract values within the search window
                window_values <- terra::extract(raster_object, search_window)

                # Find the nearest non-NA value
                non_na_indices <- which(!is.na(window_values[, 2]))

                raster_value_est <-
                  table(non_na_indices) %>%
                  sort(., decreasing = TRUE) %>%
                  names() %>%
                  purrr::pluck(1) %>%
                  as.double()

                # replace the selected value with NA
                if (
                  isFALSE(is.null(na_as_value))
                ) {
                  raster_value_est <-
                    purrr::map(
                      .x = raster_value_est,
                      .f = ~ {
                        .x[.x == na_as_value] <- NA

                        return(.x)
                      }
                    )
                }

                return(raster_value_est)
              }
            )
          )

        if (
          all(!is.na(data_with_values$raster_value))
        ) {
          break
        }
      }
    }

    check_col_names("data_with_values", "raster_values")

    return(data_with_values)
  }
