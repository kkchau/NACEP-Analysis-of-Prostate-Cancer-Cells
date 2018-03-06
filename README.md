# NACEP Analysis of Tumorigenic prostate epithelial cells
Written as a final project for BENG 183: "Applied Genomic Technologies"

Source data and study: Time-course differential expression of immortal prostate epithelial cells versus tumorigentic prostate epithelial cells  
Accessed via the NCBI Gene Expression Omnibus at:  
https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE77460

See "docs/final essay.pdf" for report. 

## Overall Process:

1. Data downloaded from NCBI GEO into files "GSE77460_EMP-gene-count-matrix" and "GSE77460_iPrEC-gene-count-matrix"
2. Gene lengths compiled using script "generateCoordinates.sh" and "discontinuedGeneLengths.py"
    - Employs NCBI E-UTILITIES
3. Conversion from count matrix to tpm matrix with "quantification.R"
4. Filtering performed with "DATA/filter/filterMethods.R"
    - expressionFilter params: expressionFilter(<filename>, 0.17, 39)
    - varianceFilter params: varianceFilter(<filename>, 2.4, T)
    - Output: "ANALYSIS/dataFilter.txt"
5. NACEP run: "run.sh" calls "run.R" which calls "NACEP.R"
    - Output: Distances.txt, sorted by statistical significance

### INSTALLING NCBI EDIRECT (E-UTILITIES)
    cd ~
    perl -MNet::FTP -e \
      '$ftp = new Net::FTP("ftp.ncbi.nlm.nih.gov", Passive => 1);
       $ftp->login; $ftp->binary;
       $ftp->get("/entrez/entrezdirect/edirect.tar.gz");'
    gunzip -c edirect.tar.gz | tar xf -
    rm edirect.tar.gz
    export PATH=$PATH:$HOME/edirect
    ./edirect/setup.sh

### QUERYING NCBI FOR GENE UID
    esearch -db gene -query "<EntrezID> [UID] AND human [ORGN]" | efetch -format docsum | xtract -pattern GenomicInfoType -element ChrAccVer ChrStart ChrStop

## References
1.  Huang, W., Cao, X., & Zhong, S. (2010). Network-based comparison of temporal gene expression patterns. Bioinformatics, 26(23), 2944–2951. http://doi.org/10.1093/bioinformatics/btq561
2.  Berger, P. L., Winn, M. E., Miranti, C. K. (2016). Miz1, a Novel Target of ING4, Can Drive Prostate Luminal Epithelial Cell Differentiation. The Prostate. 77(1), 49-59. http://doi.org/10.1002/pros.23249
