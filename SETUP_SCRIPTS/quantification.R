# Quantification of expression data
# Conversion from count data to expression data
options(stringsAsFactors=F)
library(rentrez)


calcTPM <- function(counts, lengths) {
    # Calculate TPM for a counts matrix
    # Input: counts matrix with rownames=EntrezID and colnames=Sample
    #        lengths vector with names=genes and values=gene lengths
    # Returns TPM matrix
    # Note: TPM = ((count)/(length)) / sum_over_sample((count)/(length))
    tpm <- counts / lengths
    tpm <- sweep(counts, 2, colSums(counts), '/')
    tpm <- tpm*(10**6)
    return(tpm)
}


emp <- read.table(file="DATA/GSE77460_EMP-gene-count-matrix.tsv", header=T, sep='\t', row.names=1)
iprec <- read.table(file="DATA/GSE77460_iPrEC-gene-count-matrix.tsv", header=T, sep='\t', row.names=1)
gene.lengths <- read.table(file="DATA/geneLengths.tsv", header=F, sep='\t', row.names=1)

emp.tpm <- calcTPM(emp, gene.lengths$V2)
iprec.tpm <- calcTPM(iprec, gene.lengths$V2)

write.table(emp.tpm, file="DATA/GSE77460_EMP-gene-tpm-matrix.tsv", sep='\t', quote=F)
write.table(iprec.tpm, file="DATA/GSE77460_iPrEC-gene-tpm-matrix.tsv", sep='\t', quote=F)
