#!/bin/bash
#SBATCH --job-name=wget_nasa
#SBATCH --output=logs/wget/wget_nasa_%A_%a.out
#SBATCH --error=logs/wget/wget_nasa_%A_%a.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --array=1-4

# This downloads NASA MERRA-2 data for 4 years at once, starting from the BASE_YEAR.
# Just set a URL and include the YEAR variable where it should be.
# Creates 4 jobs that download data for the years 2018, 2019, 2020, and 2021.

BASE_YEAR=2013
YEAR=$((BASE_YEAR + SLURM_ARRAY_TASK_ID))
OUTPUT_DIR="/scratch/wdt/data/MERRA2-M2I1NXASM.5.12.4/${YEAR}/"
URL="https://goldsmr4.gesdisc.eosdis.nasa.gov/data/MERRA2/M2I1NXASM.5.12.4/${YEAR}/"

# Create the output directory if it doesn't exist
mkdir -p "${OUTPUT_DIR}"

# Run wget command
wget --load-cookies /scratch/wdt/nasa_auth/.urs_cookies \
    --save-cookies /scratch/wdt/nasa_auth/.urs_cookies \
    --keep-session-cookies -r -c -nH -nd -np -A nc4,xml \
    --content-disposition "${URL}" -P "${OUTPUT_DIR}"