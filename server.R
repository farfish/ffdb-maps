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
    date_start <- as.Date(date_start)
    date_end <- as.Date(date_end)

    # Make file paths for every day in given range
    file_paths <- paste0(csv_path, '/', format(seq(date_start, date_end, 1), '%Y-%m-%d'), '.csv')
    # Fetch them all, bind results together
    effort <- do.call("rbind", lapply(file_paths, read.csv))

    # Scale lat/lon
    effort$lat_bin <- effort$lat_bin / 10
    effort$lon_bin <- effort$lon_bin / 10

    # join on flag information
    effort$flag <- fleet_metadata[match(effort$mmsi, fleet_metadata$mmsi), c('flag')]

    # Scale the day the data point is on as an opacity
    days_total <- as.numeric(date_end - date_start)
    opacity_scale <- ifelse(days_total < 5, 0.4, 0.1)
    effort$day_ratio <- as.numeric(as.Date(effort$date, format='%Y-%m-%d') - date_start)
    # Scale ratio opacity_scale..1
    effort$day_ratio <- ((effort$day_ratio  / days_total) * (1 - opacity_scale)) + opacity_scale

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

  full_pal <- rep(c(brewer.pal(12, "Paired"),
                    brewer.pal(9, "Dark2"),
                    brewer.pal(12, "Set1")), 10)

  output$map <- renderLeaflet({
    leaflet(options = leafletOptions(zoomControl = TRUE)) %>%
      addProviderTiles("Esri.OceanBasemap") %>%
      addTiles(urlTemplate = "", attribution = '<a href="http://globalfishingwatch.org">Global Fishing Watch</a>') %>%
      setView(lng = -21.88, lat = -2.00, zoom = 4)
  })

  observe({
    ve <- visible_effort()
    pal <- colorFactor(full_pal, ve$flag)

    leafletProxy("map", data = ve) %>%
        clearMarkers() %>%
        addCircleMarkers(~lon_bin, ~lat_bin, radius=~fishing_hours, group=~paste0('<span style="color: ', pal(flag), '">', flag, '</span>'),
            stroke=FALSE, fillOpacity=~day_ratio, fillColor=~pal(flag), popup=~paste0('Flag: ', flag),
            options = pathOptions(className=~paste0("flag-", flag))) %>%
        addLayersControl(overlayGroups=~paste0('<span style="color: ', pal(flag), '">', flag, '</span>'), position="topright",
            options = layersControlOptions(collapsed = FALSE))
  })

  observeEvent(input$prev_day, {
      updateDateInput(session, "date_start", value = as.Date(input$date_start, format='%Y-%m-%d') - 1)
      updateDateInput(session, "date_end", value = as.Date(input$date_end, format='%Y-%m-%d') - 1)
  })

  observeEvent(input$next_day, {
      updateDateInput(session, "date_start", value = as.Date(input$date_start, format='%Y-%m-%d') + 1)
      updateDateInput(session, "date_end", value = as.Date(input$date_end, format='%Y-%m-%d') + 1)
  })
}
