# BENG 183

Data and scripts for final BENG 183 project

Source data and study: Time-course differential expression of immortal prostate epithelial cells versus tumorigentic prostate epithelial cells 
https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE77460

Notes: 
* Read assignment with featureCounts, voom transformed
* Original differential expression done with limma.

R dependencies: splines

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

### SRA Study Download (R)
    source("https://bioconductor.org/biocLite.R")
    biocLite(c("DBI", "SRAdb"))
    library(DBI); library(SRAdb)
    srafile <- getSRAdbFile()       # downloads SRA database (SQLite)
    con <- dbConnect(RSQLite::SQLite(), srafile)
    listSRAfile("SRP069177", con)   # list runs for verification
    getSRAfile("SRP069177", con, fileType="sra")    # download SRA files
