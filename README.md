# BENG 183

Data and scripts for final BENG 183 project

Source data and study: Time-course differential expression of immortal prostate epithelial cells versus tumorigentic prostate epithelial cells 
https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE77460

R dependencies: splines

Overall Process:

Data downloaded from NCBI GEO into files "GSE77460_EMP-gene-count-matrix" and "GSE77460_iPrEC-gene-count-matrix"

Gene lengths compiled using script "generateCoordinates.sh" and "discontinuedGeneLengths.py"
 - Employs NCBI E-UTILITIES
 
 Conversion from count matrix to tpm matrix with "quantification.R"
 
Filtering performed with "DATA/filter/filterMethods.R"
  - expressionFilter params: expressionFilter(<filename>, 0.17, 39)
  - varianceFilter params: varianceFilter(<filename>, 2.4, T)
  - Output: "ANALYSIS/dataFilter.txt"
  
NACEP run: "run.sh" calls "run.R" which calls "NACEP.R"
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

