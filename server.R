library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)


read_fleet_metadata <- function (csv_path = 'fishing_effort/fishing_vessels') {
    read.csv(paste0(csv_path, '/', 'fishing_vessels.csv'))
}
fleet_metadata <- read_fleet_metadata()

read_fishing_effort <- function (date_start, date_end = date_start, csv_path = 'fishing_effort/fishing_effort_byvessel/daily_csvs') {
    # Make file paths for every day in given range
    file_paths <- paste0(csv_path, '/', format(seq(as.Date(date_start), as.Date(date_end), 1), '%Y-%m-%d'), '.csv')
    # Fetch them all, bind results together
    effort <- do.call("rbind", lapply(file_paths, read.csv))

    # Scale lat/lon
    effort$lat_bin <- effort$lat_bin / 10
    effort$lon_bin <- effort$lon_bin / 10

    # join on flag information
    effort$flag <- fleet_metadata[match(effort$mmsi, fleet_metadata$mmsi), c('flag')]

    return(effort)
}

function(input, output, session) {

  visible_effort <- reactive({
      effort <- read_fishing_effort(input$date_start, input$date_end)  # TODO: Cache?

      # Return all effort that's currently on-screen
      bounds <- input$map_bounds
      ve <- effort[ effort$lon_bin > bounds$west
                  & effort$lon_bin < bounds$east
                  & effort$lat_bin > bounds$south
                  & effort$lat_bin < bounds$north
                  , ]
      # TODO: input$MAPID_zoom is an integer that indicates the zoom level.
  })

  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
        attribution = '<a href="http://www.esri.com/">Esri</a> i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community',
      ) %>%
      setView(lng = -21.88, lat = -2.00, zoom = 4)
  })

  observe({
    ve <- visible_effort()
    pal <- colorFactor("inferno", ve$flag)

    leafletProxy("map", data = ve) %>%
        clearShapes() %>%
        addCircleMarkers(~lon_bin, ~lat_bin, radius=~fishing_hours,
            stroke=FALSE, fillOpacity=0.8, fillColor=pal(ve$flag)) %>%
        addLegend("bottomleft", pal=pal, values=~flag, title="Flag",
            layerId="colorLegend")
  })
}