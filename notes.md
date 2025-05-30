# WDT Orca Directory

> THIS FOLDER IS A GIT REPO. COMMIT YOUR CHANGES PLS <3

This file is for notes on putting the contents of this directory to work. Please contribute to this as we add to the directory so people don't get lost with utilizing its contents.

## Data Intake SLURM Jobs

Currently I have defined some basic SLURM jobs for intaking data and unpacking it. One can use my `wget_single.sh` job to generically submit via arguments a single wget request to the job cluster.

```bash
sbatch wget_node.sh [url] [output_directory]
```

If this data needs to be unpacked, one could use/modify the similar script I wrote called `decompress_tar.sh` to unpack tarballs as a SLURM job.

```sh
sbatch decompress_tar.sh [path] [output_directory]
``` 

### NASA MERRA-2 Focused Data Intake Jobs

One can use/modify the `wget_nasa_4_years.sh` SLURM job script to download multiple years of NASA MERRA-2 data in parallel with wget directly to our shared directory. It doesn't take any arguments, but it has some variables in it one would modify to wget the desired data.

```bash
sbatch wget_nasa_4_years.sh
```

The `wget_new_merra2_data.sh` SLURM job script is something one could run to trickle download all new MERRA2 data for all the directories we get as one job, running on one node. Currently, it is set to download 2025 data for the relevant directories. One could submit it as a job like so:

```bash
sbatch wget_nasa_4_years.sh
```