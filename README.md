MSigDB
================

Houses gene lists from [Broad Institute Molecular
Signatures](http://software.broadinstitute.org/gsea/msigdb/index.jsp)
Database. They do want to keep track of their user counts so you might
want to log in there as well. Note that there is an
[msigdbr](https://github.com/igordot/msigdbr) package that is also
uploaded to CRAN that provides similar funcitonality.

# Installation

``` r
devtools::install_github('oganm/MSigDB')
```

# Usage

``` r
library(MSigDB)
names(MSigDB)
```

    ## [1] "human" "mouse"

``` r
names(MSigDB$human)
```

    ##  [1] "C1"       "C2"       "C3"       "C4"       "C6"       "C7"      
    ##  [7] "C8"       "ARCHIVED" "C5"       "H"

``` r
head(names(MSigDB$human$H))
```

    ## [1] "HALLMARK_TNFA_SIGNALING_VIA_NFKB"    "HALLMARK_HYPOXIA"                   
    ## [3] "HALLMARK_CHOLESTEROL_HOMEOSTASIS"    "HALLMARK_MITOTIC_SPINDLE"           
    ## [5] "HALLMARK_WNT_BETA_CATENIN_SIGNALING" "HALLMARK_TGF_BETA_SIGNALING"

``` r
MSigDB$human$H$HALLMARK_PEROXISOME
```

    ##   [1] "ABCD3"    "ACOT8"    "ACOX1"    "ACSL1"    "ECH1"     "ECI2"    
    ##   [7] "EHHADH"   "GSTK1"    "HSD17B4"  "MLYCD"    "PEX11A"   "RETSAT"  
    ##  [13] "SLC27A2"  "PEX13"    "PEX14"    "SCP2"     "HSD3B7"   "GNPAT"   
    ##  [19] "ABCD2"    "SLC25A17" "PEX2"     "ACAA1"    "HAO2"     "HSD17B11"
    ##  [25] "CRAT"     "PEX11B"   "LONP2"    "IDH1"     "FIS1"     "PEX6"    
    ##  [31] "ABCB4"    "SOD1"     "ABCB1"    "ISOC1"    "YWHAH"    "EPHX2"   
    ##  [37] "ABCD1"    "HMGCL"    "ACSL5"    "ALDH9A1"  "DHCR24"   "ELOVL5"  
    ##  [43] "NUDT19"   "PRDX5"    "CTPS1"    "IDE"      "SLC23A2"  "PEX5"    
    ##  [49] "BCL10"    "NR1I2"    "TSPO"     "CNBP"     "MSH2"     "DHRS3"   
    ##  [55] "DIO1"     "SLC25A4"  "PRDX1"    "IDI1"     "HRAS"     "MVP"     
    ##  [61] "ABCC8"    "CLN6"     "CAT"      "ACSL4"    "IDH2"     "ABCC5"   
    ##  [67] "SOD2"     "SLC35B2"  "FDPS"     "ALB"      "FADS1"    "STS"     
    ##  [73] "SMARCC1"  "ITGB1BP1" "SIAH1"    "SLC25A19" "CDK7"     "RXRG"    
    ##  [79] "ALDH1A1"  "UGT2B17"  "CADM1"    "SERPINA6" "CLN8"     "RDH11"   
    ##  [85] "CTBP1"    "HSD11B2"  "TTR"      "ERCC3"    "ATXN1"    "SULT2B1" 
    ##  [91] "CRABP2"   "CRABP1"   "TOP2A"    "SCGB1A1"  "ERCC1"    "DLG4"    
    ##  [97] "PABPC1"   "FABP6"    "ABCB9"    "CACNA1B"  "SEMA3C"   "VPS4B"   
    ## [103] "CEL"      "ESR2"    
    ## attr(,"description")
    ##                                    GENESET 
    ## "Genes encoding components of peroxisome."

`getMSigInfo` function simply navigates to the broad institute website
with the relevant data

``` r
getMSigInfo('HALLMARK_PEROXISOME','human')
```
