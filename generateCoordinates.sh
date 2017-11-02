#!/usr/bin/env bash
# quick and dirty script to generate coordinates for passed uid
coordinates=$(./edirect/esearch -db gene -query "$1 [UID] AND human [ORGN]" | ./edirect/efetch -format docsum | ./edirect/xtract -pattern GenomicInfoType -element ChrStart ChrStop);
echo "$1    $coordinates"
