#!/bin/bash
#SBATCH --job-name=decompress_tar
#SBATCH --output=logs/decompress_tar/decompress_tar_%j.log
#SBATCH --error=logs/decompress_tar/decompress_tar_%j.err
#SBATCH --ntasks=1

# Usage: sbatch decompress_tar.sh <url> <output_directory>

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <tar_file> <destination_directory>"
    exit 1
fi

# Path to the tar.bz2 file (argument 1)
TAR_FILE="$1"

# Destination directory for extraction (argument 2)
DEST_DIR="$2"

# Decompress the tar.bz2 file
mkdir -p "$DEST_DIR"
tar xvfj "$TAR_FILE" -C "$DEST_DIR" --strip-components=1