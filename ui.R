library(leaflet)

navbarPage("FFDB maps", id="nav",

  tabPanel("Fishing effort by flag",
    tags$head(
      # Include our custom CSS
      includeCSS("styles.css")
    ),

    div(class="outer",
      leafletOutput("map", width="100%", height="100%"),

      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
        draggable = TRUE, top = 65, left = 10, right = "auto", bottom = "auto",
        width = 330, height = "auto",

        h2("Fishing effort by flag"),

        dateInput(
            "date_start", "Start Date",
            min = "2012-01-01",
            max = "2016-12-31",
            value = "2015-01-01"),

        dateInput(
            "date_end", "End Date",
            min = "2012-01-01",
            max = "2016-12-31",
            value = "2015-01-01"),

        actionButton("prev_day", "Prev"),
        actionButton("next_day", "Next", class = 'float-right')

      )
    )
  ),

  conditionalPanel("false", icon("crosshair"))
)
