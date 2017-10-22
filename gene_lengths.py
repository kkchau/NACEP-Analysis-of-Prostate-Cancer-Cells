import subprocess, time
import pandas as pd


genes = list(pd.read_table("./DATA/GSE77460_iPrEC-gene-count-matrix.tsv", index_col=0).index)
genes = genes[:11]

with open("DATA/geneCoordinates.txt", 'w') as ofile:
    for g in [str(_) for _ in genes]:
        gene_id, start_coord, end_coord = subprocess.check_output([
            './generateLengths.sh', g
        ]).decode('utf-8').strip().split()

        ofile.write('\t'.join([gene_id, start_coord, end_coord, '\n']))
