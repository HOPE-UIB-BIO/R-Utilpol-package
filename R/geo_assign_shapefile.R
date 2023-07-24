#' @title Extract data from shapefile and add to points
#' @param data_source Data.frame containing `long` and `lat`
#' @param shapefile Shapefile to use
#' @return Data.frame with additional columns
#' @description Extract data from shapefile and add to points provided based
#' on the data `lat` and `long`
#' @export
geo_assign_shapefile <-
  function(data_source,
           shapefile) {
    check_class("data_source", "data.frame")

    check_col_names("data_source", c("lat", "long"))

    check_class("shapefile", c("sf", "SpatialPolygonsDataFrame"))

    # extract the coordinates system
    data_coord <-
      data_source %>%
      dplyr::select("long", "lat") %>%
      as.data.frame()

    data_coord_sf <-
      sf::st_as_sf(
        data_coord,
        coords = c("long", "lat"),
        crs = "+proj=longlat +datum=WGS84"
      )

    # Check if the projection is "+proj=longlat +datum=WGS84"
    if (
      sf::st_crs(shapefile)$proj4string != "+proj=longlat +datum=WGS84"
    ) {
      # Change the projection to "+proj=longlat +datum=WGS84"
      shapefile <-
        sf::st_transform(shapefile, crs = "+proj=longlat +datum=WGS84")
    }

    shapefile <-
      sf::st_make_valid(shapefile)

    # Assign each row a value from the shapefile
    data_coord_with_values <-
      sf::st_join(
        data_coord_sf,
        shapefile,
        join = sf::st_within
      )

    # combine the extracted values and original data
    data_res <-
      data_source %>%
      dplyr::bind_cols(
        sf::st_drop_geometry(data_coord_with_values)
      ) %>%
      tibble::as_tibble()

    return(data_res)
  }
