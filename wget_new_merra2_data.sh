#!/bin/bash
#SBATCH --job-name=update_merra2_data 
#SBATCH --output=logs/wget/wget_current_%A_%a.out 
#SBATCH --error=logs/wget/wget_current_%A_%a.err
#SBATCH --ntasks=1

# This is a script one can use to download the latest MERRA-2 data from the NASA
# website. At the time of writing, it is downloading new data for the year 2025.
# To use it from the coeus cluster, submit it with the command `sbatch
# wget_new_merra2_data.sh`.

YEAR=2025

# List the URLs and corresponding directory names for the MERRA-2 data which you
# desire to download. They should map to each other in order so that the first
# URL corresponds to the first directory name, and so on. Here we are doing that
# for M2I1NXASM and M2I1NXLFO datasets.

URLS=(
    "https://goldsmr4.gesdisc.eosdis.nasa.gov/data/MERRA2/M2I1NXASM.5.12.4/${YEAR}"
    "https://goldsmr4.gesdisc.eosdis.nasa.gov/data/MERRA2/M2I1NXLFO.5.12.4/${YEAR}"
)

DIRNAMES=(
    "MERRA2-M2I1NXASM.5.12.4"
    "MERRA2-M2I1NXLFO.5.12.4"
)

# Loop through the list of URLs and download each dataset
for i in "${!URLS[@]}"; do
    url="${URLS[$i]}"  # current URL
    dirname="${DIRNAMES[$i]}" # current directory name to save the data into
    mkdir -p "/scratch/wdt/data/${dirname}/${YEAR}" # create the directory if it doesn't exist
    
    echo "Processing: $url into /scratch/wdt/data/${dirname}/${YEAR}"
    
    # Use wget to download the data, using the provided cookies for
    # authentication and save the files in the corresponding directory.
    wget --load-cookies /scratch/wdt/nasa_auth/.urs_cookies \
        --save-cookies /scratch/wdt/nasa_auth/.urs_cookies \
        --keep-session-cookies -r -c -nH -nd -np -A nc4,xml \
        --content-disposition "$url" -P "/scratch/wdt/data/${dirname}/${YEAR}"
done