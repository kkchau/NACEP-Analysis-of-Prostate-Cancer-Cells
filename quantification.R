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
    return(tpm)
}


geneLength <- function(genes) {
    # Get gene lengths based on list of EntrezID
    # Input list of EntrezID
    # Returns list of gene lengths in order of EntrezID list
    # Note: Queries NCBI gene database for information using rentrez package
    
    lengths <- vector(mode='list', length=length(genes))
    names(lengths) <- as.character(genes)
    for (gene in names(lengths)) {
        refseq <- entrez_link(db='all', id=gene, dbfrom='gene')$links$gene_nuccore_refseqrna
        if (is.null(refseq)) {
            next
        } else {
            refseq <- entrez_summary(db='nuccore', id=refseq)
            lengths[[gene]] <- as.integer(refseq$slen)
            print(sprintf("%s.%s", gene, lengths[[gene]]))
        }
    }
    lengths <- lengths[!is.null(lengths)]        # skip discontinued/unfound genes

    return(lengths)
}


emp <- read.table(file="DATA/GSE77460_EMP-gene-count-matrix.tsv", header=T, sep='\t', row.names=1)
iprec <- read.table(file="DATA/GSE77460_iPrEC-gene-count-matrix.tsv", header=T, sep='\t', row.names=1)

gene.lengths <- geneLength(row.names(emp))      # doesn't matter which table, all same genes
emp.tpm <- calcTPM(emp, gene.lengths)
iprec.tpm <- calcTPM(iprec, gene.lengths)
