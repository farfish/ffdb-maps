library(leaflet)

navbarPage("FFDB maps", id="nav",
  tabPanel("GFW data",
    div(class="outer",
      leafletOutput("map", width="100%", height="100%"),

      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
        draggable = TRUE, top = "auto", left = 20, right = "auto", bottom = "0",
        width = 200, height = "auto",

        radioButtons("plot_type", "Plot type", c(
            "Fishing hours" = "fishing_hours",
            "Hours per Engine Power" = "hours_per_engine_power",
            "Hours per Tonnage" = "hours_per_tonnage")),
        dateInput(
            "date_start", "Start Date",
            min = "2012-01-01",
            max = "2016-12-31",
            value = "2015-01-01"),

        dateInput(
            "date_end", "End Date",
            min = "2012-01-01",
            max = "2016-12-31",
            value = "2015-01-03"),

        actionButton("prev_day", "Prev"),
        actionButton("next_day", "Next", class = 'float-right'),
        br(),
        br(),
        downloadButton("download_data", "Download raw data")

      )
    )
  ),

  header = tags$head(
      # Include our custom CSS
      includeCSS("styles.css")
  ),
  conditionalPanel("false", icon("crosshair"))
)
