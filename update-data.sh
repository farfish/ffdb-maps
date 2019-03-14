#!/bin/sh
set -eu

URL_BASE="${1-}"
[ -n "$URL_BASE" ] || { echo "Usage: $0 (URL base of zip files)"; exit 1; }

(
    # Recreate gfw_data if it was moved out the way
    mkdir -p gfw_data
    echo "#" > gfw_data/.dir
    cd gfw_data

    for n in fishing_vessels fishing_effort_byvessel; do
        wget -c "$URL_BASE/$n/$n.zip"
        unzip -o "$n.zip"
    done
)
