if (!require(devtools))
    install.packages("devtools")
if (!require(leaflet))
    devtools::install_github("rstudio/leaflet")

# Develpoment dependencies
if (!require(unittest))
    install.packages('unittest')
