#!/bin/bash
#SBATCH --job-name=nasa_job_submitter
#SBATCH --output=logs/submit_nasa_jobs_%j.out
#SBATCH --error=logs/submit_nasa_jobs_%j.err
#SBATCH --ntasks=1
#SBATCH --time=24:00:00

# This is a job runner that submits 4 jobs at a time to download NASA MERRA-2 data.
# It starts from a base year and submits jobs for 4 consecutive years at a time.
# The jobs will be submitted sequentially, waiting for each to complete before
# submitting the next one.

START_YEAR=1980
END_YEAR=2000
YEARS_PER_JOB=4

current_year=$START_YEAR

while [ $current_year -le $END_YEAR ]; do
    # Calculate the base year for this job (subtract 1 because script adds SLURM_ARRAY_TASK_ID)
    base_year=$((current_year - 1))
    
    echo "Submitting job for years $current_year to $((current_year + YEARS_PER_JOB - 1))"
    
    # Submit job and wait for completion
    job_id=$(sbatch --parsable wget_nasa_4_years.sh $base_year)
    echo "Submitted job ID: $job_id"
    
    # Wait for this job to complete before submitting the next
    while squeue -j $job_id 2>/dev/null | grep -q $job_id; do
        sleep 60  # Check every minute
    done
    
    echo "Job $job_id completed, moving to next batch"
    current_year=$((current_year + YEARS_PER_JOB))
done

echo "All jobs completed successfully"