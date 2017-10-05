library(ggplot2)
options(stringsAsFactors=F)


SAVE_IMAGE = TRUE


# load("genes_matrix_csv/BrainSpanExpressions.RData")
# datExpr <- read.csv("genes_matrix_csv/expression_matrix.csv", header=F)[-1]
# rownames(datExpr) <- read.csv("genes_matrix_csv/rows_metadata.csv", header=T)$ensembl_gene_id
# colData <- read.csv("genes_matrix_csv/columns_metadata.csv", header=T)
# rownames(colData) <- sprintf("%s|%s|%s", colData$donor_name, colData$age, colData$structure_acronym)
# names(datExpr) <- rownames(colData)


pca=prcomp(datExpr, scale=T, center=F)      # principal component analysis
pcadata=data.frame(scale(pca$rotation))            
pcadata$period <- colData$period[match(rownames(pcadata), rownames(colData))]
pcadata$region <- colData$structure_acronym[match(rownames(pcadata), rownames(colData))]

if (SAVE_IMAGE) {
    png("brainSpanPCA_byPeriod.png", width=1920, height=1080)
}
print(ggplot(pcadata) + geom_point(aes(PC1, PC2, col=period)) + ggtitle("Gene Sample PCA") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour="black")))
if (SAVE_IMAGE) {
    dev.off()
}
