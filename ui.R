library(leaflet)

# Choices for drop-downs
vars <- c(
  "Is SuperZIP?" = "superzip",
  "Centile score" = "centile",
  "College education" = "college",
  "Median income" = "income",
  "Population" = "adultpop"
)


navbarPage("FFDB maps", id="nav",

  tabPanel("Fishing effort by flag",
    tags$head(
      # Include our custom CSS
      includeCSS("styles.css")
    ),

    div(class="outer",
      leafletOutput("map", width="100%", height="100%"),

      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
        draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
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
            value = "2015-01-01")

      )
    )
  ),

  conditionalPanel("false", icon("crosshair"))
)
