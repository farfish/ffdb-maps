# FFDB Maps shiny app

Shiny leaflet-based presentation of fishing effort data.

## Prerequisites

Install required operating system packages:

    sudo apt install libpng-dev

R and shiny server need to be installed, follow instructions at https://www.rstudio.com/products/shiny/download-server/

## Installation

Check out this repository, and install required R packages with:

    Rscript ./install-deps.R

...or study the script and perform equivalent steps.

Symlink this directory into the shiny server root, for example:

    ln -rs . /srv/shiny-server/ffdb-maps

## Data download

This application requires the ``fishing_vessels`` and ``fishing_effort_byvessel`` datasets, these can be downloaded from
[globalfishingwatch](https://globalfishingwatch.force.com/gfw/s/data-download).

Both of these should be uncompressed into the ``gfw_data`` directory. There is a helper script, [update-data.sh](update-data.sh)
to help with this.

More information on the datasets:

* https://github.com/GlobalFishingWatch/paper-global-footprint-of-fisheries/blob/master/data_documentation/fishing_vessels.md
* https://github.com/GlobalFishingWatch/paper-global-footprint-of-fisheries/blob/master/data_documentation/fishing_effort_byvessel.md

## Authors

* [Jamie Lentin](https://github.com/lentinj) - jamie.lentin@shuttlethread.com
* [Margarita Rincón Hidalgo](https://github.com/mmrinconh) - margarita.rincon@csic.es
* Javier Ruiz - javier.ruiz@csic.es

## License

This project is GPL-3.0 licensed - see the LICENSE file for details

## Acknowledgements

This project has received funding from the European Union’s Horizon 2020 research and innovation programme under grant agreement no. 727891.
