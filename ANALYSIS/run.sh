#!/usr/bin/env bash
#SBATCH --job-name="NACEP"
#SBATCH --output="NACEP.LOG"
#SBATCH --partition=shared
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --export=ALL
#SBATCH -t 48:00:00
#SBATCH --mem=40G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=kkhaichau@gmail.com


module load R
Rscript run.R
