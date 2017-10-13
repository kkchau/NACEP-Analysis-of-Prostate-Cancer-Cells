"""
    Convert raw read counts to TPM using gene2accession.gz data
"""
import gzip
import pandas as pd


EMP_FILE = "DATA/GSE77460_EMP-gene-count-matrix.tsv"
IPR_FILE = "DATA/GSE77460_iPrEC-gene-count-matrix.tsv"


# build dictionary for genes and associated lengths
with gzip.open("DATA/gene2accession.gz", 'rt') as access:
    header = next(access).strip().split('\t')
    gIdx, sIdx, eIdx = (header.index("GeneID"), header.index("start_position_on_the_genomic_accession"), header.index("end_position_on_the_genomic_accession"))
    coordinates = {}
    for line in [_.strip().split('\t') for _ in access]:
        coordinates[line[gIdx]] = abs(int(line[sIdx]) - int(line[eIdx])) 


# tpm for EMP
emp_df = pd.read_csv(EMP_FILE, sep='\t', index_col=0)
emp_df['lengths'] = pd.Series([coordinates[gene] for gene in emp_df.index], index=emp_df.index)
emp_df = emp_df.div(emp_df.lengths, axis=0)
emp_df = emp_df.div(emp_df.sum(axis=1), axis=1)
