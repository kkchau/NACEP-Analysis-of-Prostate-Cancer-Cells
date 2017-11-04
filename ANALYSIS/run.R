# Script to run NACEP on given file

# Function Definition
# NACEP = function(filename, spcNum, Timelength, Knot, loop=500, compStart, compIntvl, alpha=50){

# Params
# filename          Data file input
# spcNum            Number of conditions
# Timelength        Number of time points in each experiment
# Knot              Knots for spline construction
# loop              Gibbs sampler loops (default=500)
# compStart         First loop that comparisons will be taken
# compIntvl         Inverval between two successfully chosen comparison results
# alpha             Clustering strength (default=50)

source("NACEP.r")
NACEP("DATA.txt", 2, 18, 15, 500, 200, 100, 50)
