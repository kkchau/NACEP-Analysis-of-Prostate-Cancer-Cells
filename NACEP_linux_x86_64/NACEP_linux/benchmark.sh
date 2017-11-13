#!/usr/bin/env bash
#SBATCH --job-name="benchNACEP"
#SBATCH --output="benchNACEP.LOG"
#SBATCH --partition=shared
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --export=ALL
#SBATCH -t 48:00:00
#SBATCH --mem=10G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=kkhaichau@gmail.com

module load R
(time Rscript Example10.R) &>> benchmark.txt
(time Rscript Example100.R) &>> benchmark.txt
(time Rscript Example200.R) &>> benchmark.txt
(time Rscript Example500.R) &>> benchmark.txt
(time Rscript Example750.R) &>> benchmark.txt
(time Rscript Example1000.R) &>> benchmark.txt
