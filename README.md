# WDT HPC Data Intake

This is a repository containing some scripts for SLURM that we use to intake
NASA's MERRA-2 and other data on the [Orca HPC cluster](https://orca.pdx.edu) at
Portland State University.

These scripts were written by Ethel Arterberry during the Spring/Summer Computer
Science Capstone for the year 2025.

## Data Intake SLURM Jobs

Currently I have defined some basic SLURM jobs for intaking data and unpacking
it. One can use my `wget_single.sh` job to generically submit via arguments a
single wget request to the job cluster.

```bash
sbatch wget_node.sh [url] [output_directory]
```

If this data needs to be unpacked, one could use/modify the similar script I
wrote called `decompress_tar.sh` to unpack tarballs as a SLURM job.

```sh
sbatch decompress_tar.sh [path] [output_directory]
``` 

### NASA MERRA-2 Focused Data Intake Jobs

To download data properly from NASA's MERRA-2 datasets, one must go through the
proper steps by creating an [Earthdata account](https://urs.earthdata.nasa.gov)
and providing the authentication files to wget. For more info on how to create
these files, check out [this guide on generating the Earthdata authentication
files.](https://disc.gsfc.nasa.gov/information/howto?title=How%20to%20Generate%20Earthdata%20Prerequisite%20Files)

Once one has the authentication files, they are expected to be provided to wget
like so. One could modify my scripts as desired to point to the right place:

```sh
# change /scratch/wdt/nasa_auth/.urs_cookies to point at your .urs_cookies file
wget --load-cookies /scratch/wdt/nasa_auth/.urs_cookies \
    --save-cookies /scratch/wdt/nasa_auth/.urs_cookies \
    --keep-session-cookies -r -c -nH -nd -np -A nc4,xml \
    --content-disposition "${URL}" -P "${OUTPUT_DIR}"
```

One can use/modify the `wget_nasa_4_years.sh` SLURM job script to download
multiple years of NASA MERRA-2 data in parallel with wget directly to our shared
directory. It only takes one parameter, `base_year`, which signifies the year
one before the 4 years you want to download. It downloads (base_year + 1,
base_year + 4).

```sh
sbatch wget_nasa_4_years.sh [base_year]
```

I wrote an additional script `submit_nasa_jobs.sh` so I wouldn't have to come
back every hour to download the next batch of 4 years. It's a simple job runner
that runs on its own node and automatically submits the next batch afterwards.
You'll have to modify its contents, where you can set which year it starts and
ends at, but then you can run it either directly or with sbatch:

```bash
sbatch submit_nasa_jobs.sh
```

The `wget_new_merra2_data.sh` SLURM job script is something one could run to
trickle download all new MERRA2 data for all the directories we get as one job,
running on one node. Currently, it is set to download 2025 data for the relevant
directories. One could submit it as a job like so:

```sh
sbatch wget_nasa_4_years.sh
```