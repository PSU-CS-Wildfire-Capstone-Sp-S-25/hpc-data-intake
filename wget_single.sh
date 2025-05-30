#!/bin/bash
#SBATCH --job-name=wget_single
#SBATCH --output=logs/wget/wget_job_%j.out
#SBATCH --error=logs/wget/wget_job_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1

# Usage: sbatch wget_node.sh <url> <output_directory>

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <url> <output_directory>"
    exit 1
fi

url="$1"
output_dir="$2"

mkdir -p "$output_dir"
wget -P "$output_dir" "$url"