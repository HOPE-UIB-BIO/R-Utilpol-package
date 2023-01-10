#' @title Extract data from TIF file and add as points
#' @param data_source  Data.frame containing `long` and `lat`
#' @param tif_file Name of a shape file to use
#' @param fill_na
#' Logical. If TRUE, function will search for the most common value
#'  in the increasing distance of 'distance_step'
#' @param values_as_na Use for values of tiff file, which should be treated as
#'  NA for the purposes of looking for additional value.
#' @param distance_step
#' Numeric. Distance in meters giving radius to increase the
#'  search radius
#' @param n_max_step Numeric. Maximum number of step increases.
#' @param raster_values_numeric Logical. are raster values numeric?
#' Flag as FALSE if values are levels and cannot be averaged.
#' @return Data.frame with additional columns
#' @description Extract data from tif file and add to points provided based
#'  on the data `lat` and `long`. If `fill_na` == TRUE, function will search for
#'  the most common value in the increasing distance of `distance_step`.
#'  Function will stop search if all values are found.
#' @export
geo_assign_tif <- function(data_source,
                           tif_file,
                           fill_na = FALSE,
                           values_as_na = NULL,
                           distance_step = 500,
                           n_max_step = 10,
                           raster_values_numeric = TRUE) {
  RUtilpol::check_class("data_source", "data.frame")

  RUtilpol::check_col_names("data_source", c("lat", "long"))

  RUtilpol::check_class("tif_file", "character")

  RUtilpol::check_class("fill_na", "logical")

  if (
    isTRUE(fill_na)
  ) {
    RUtilpol::check_class("distance_step", "numeric")

    RUtilpol::check_class("n_max_step", "numeric")

    RUtilpol::check_if_integer("n_max_step")

    RUtilpol::check_class("raster_values_numeric", "logical")
  } else {
    assertthat::assert_that(
      is.null(values_as_na),
      msg = "'fill_na' must be TRUE for 'values_as_na' to be set (not null)"
    )
  }

  # helper function
  summarise_values <- function(data_source,
                               raster_values_numeric = TRUE) {
    get_mode <- function(data_source) {
      uniq_vec <- unique(data_source)
      uniq_vec[which.max(tabulate(match(data_source, uniq_vec)))]
    }

    if (raster_values_numeric == TRUE) {
      res <- mean(data_source, na.rm = TRUE)
    } else {
      res <- get_mode(data_source)
    }

    return(res)
  }

  flag_na_values <- function(data_source) {
    data_source %>%
      dplyr::mutate(
        is_na = purrr::map_lgl(
          .x = est_value,
          .f = ~ any(is.na(.x))
        )
      ) %>%
      return()
  }

  replace_value_with_na <- function(data_source,
                                    values_as_na) {
    data_source %>%
      dplyr::mutate(
        est_value = ifelse(
          test = est_value == values_as_na,
          yes = NA,
          no = est_value
        )
      ) %>%
      return()
  }


  # Create a raster stack of your raster file
  raster_object <- terra::rast(tif_file)

  data_source_id <-
    data_source %>%
    dplyr::select(lat, long) %>%
    dplyr::mutate(
      # make a new unique ID using the row nuber
      ID = paste0("X_", dplyr::row_number())
    )

  # Extract raster value by points
  data_raster_extract <-
    data_source_id %>%
    dplyr::mutate(
      est_value = data_source_id %>%
        tibble::column_to_rownames("ID") %>%
        dplyr::relocate(long, lat) %>%
        terra::extract(
          x = raster_object,
          y = .,
          na.rm = TRUE,
          xy = TRUE
        ) %>%
        tibble::column_to_rownames("ID") %>%
        purrr::pluck(1)
    )

  # replace the selected value with NA
  if (
    isFALSE(is.null(values_as_na))
  ) {
    data_raster_extract <-
      replace_value_with_na(
        data_source = data_raster_extract,
        values_as_na = values_as_na
      )
  }

  # flagg NAs
  data_work <-
    flag_na_values(data_raster_extract)

  # search for the closest value for NAs
  if (
    any(data_work$is_na) && isTRUE(fill_na)
  ) {
    RUtilpol::output_comment(
      msg = "Searching for the closest value for NAs"
    )

    for (i in 1:n_max_step) {
      buffer_value <- distance_step * i

      cat(
        paste("distance =", buffer_value, "m"), "\n"
      )

      # subset data to only include NA
      data_work_sub <-
        data_work %>%
        dplyr::filter(is_na) %>%
        tibble::as_tibble()

      # turn into spatial points
      data_work_sub_coord_sp <-
        data_work_sub %>%
        dplyr::mutate(
          st_point = purrr::map2(
            .x = long,
            .y = lat,
            .f = ~ c(.x, .y) %>%
              sf::st_point(
                x = .,
                dim = "XY"
              )
          )
        )

      # create a buffer around the points
      data_work_sub_buffer <-
        data_work_sub_coord_sp %>%
        dplyr::mutate(
          st_buffer = purrr::map(
            .x = st_point,
            .f = ~ sf::st_buffer(
              x = .x,
              dist = buffer_value
            )
          )
        )

      data_work_sub_est_value <-
        data_work_sub_buffer %>%
        dplyr::mutate(
          raster_value_est_raw = purrr::map(
            .x = st_buffer,
            .f = ~ terra::vect(.x) %>% # conversion to SpatVector class
              terra::extract(
                x = raster_object,
                y = .
              ) %>%
              dplyr::select(-ID) %>%
              purrr::pluck(1)
          )
        )

      data_work_sub_est_value_sum <-
        data_work_sub_est_value %>%
        dplyr::mutate(
          est_value = purrr::map_dbl(
            .x = raster_value_est_raw,
            .f = ~ summarise_values(
              data_sourc = .x,
              raster_values_numeric = raster_values_numeric
            )
          )
        )

      # replace the selected value with NA
      if (
        isFALSE(is.null(values_as_na))
      ) {
        data_work_sub_est_value_sum <-
          replace_value_with_na(
            data_source = data_work_sub_est_value_sum,
            values_as_na = values_as_na
          )
      }

      # flagg NAs
      data_work_sub_na <-
        flag_na_values(data_work_sub_est_value_sum) %>%
        dplyr::filter(
          is_na == FALSE
        ) %>%
        dplyr::select(names(data_work))

      # now need to merge and add the new values (if any)
      data_work <-
        data_work %>%
        dplyr::filter(
          !(ID %in% data_work_sub_na$ID)
        ) %>%
        bind_rows(
          data_work_sub_na
        ) %>%
        dplyr::arrange(ID)

      if (
        all(data_work$is_na == FALSE)
      ) {
        break
      }
    }
  }

  data_with_values <-
    data_source # TODO


  RUtilpol::check_col_names("data_with_values", "raster_values")

  return(data_with_values)
}
