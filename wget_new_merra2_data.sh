#!/bin/bash
#SBATCH --job-name=update_merra2_data
#SBATCH --output=logs/wget/wget_current_%A_%a.out
#SBATCH --error=logs/wget/wget_current_%A_%a.err
#SBATCH --ntasks=1

# This is a script one can use to download the latest MERRA-2 data from the NASA website.
# At the time of writing, it is downloading new data for the year 2025.
# To use it from the coeus cluster, submit it with the command `sbatch wget_new_merra2_data.sh`.

YEAR=2025

URLS=(
    "https://goldsmr4.gesdisc.eosdis.nasa.gov/data/MERRA2/M2I1NXASM.5.12.4/${YEAR}"
    "https://goldsmr4.gesdisc.eosdis.nasa.gov/data/MERRA2/M2I1NXLFO.5.12.4/${YEAR}"
)

DIRNAMES=(
    "MERRA2-M2I1NXASM.5.12.4"
    "MERRA2-M2I1NXLFO.5.12.4"
)

for i in "${!URLS[@]}"; do
    url="${URLS[$i]}"
    dirname="${DIRNAMES[$i]}"
    mkdir -p "/scratch/wdt/data/${dirname}/${YEAR}"
    
    echo "Processing: $url into /scratch/wdt/data/${dirname}/${YEAR}"
    wget --load-cookies /scratch/wdt/nasa_auth/.urs_cookies \
        --save-cookies /scratch/wdt/nasa_auth/.urs_cookies \
        --keep-session-cookies -r -c -nH -nd -np -A nc4,xml \
        --content-disposition "$url" -P "/scratch/wdt/data/${dirname}/${YEAR}"
done