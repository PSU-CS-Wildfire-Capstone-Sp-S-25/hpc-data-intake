#!/bin/bash
#SBATCH --job-name=globusconnectpersonal
#SBATCH --output=logs/globusconnect/globusconnect_%A_%a.out 
#SBATCH --error=logs/globusconnect/globusconnect_%A_%a.err
#SBATCH --ntasks=1
#SBATCH --time=24:00:00

/scratch/wdt/globus-connect-personal/globusconnectpersonal-3.2.7/globusconnectpersonal -start -restrict-paths "/scratch/wdt/"