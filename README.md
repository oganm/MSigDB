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

    ## [1] "HALLMARK"                  "C1_POSITIONAL"            
    ## [3] "C2_CURATED"                "C3_MOTIF"                 
    ## [5] "C4_COMPUTATIONAL"          "C5_GENE_ONTOLOGY"         
    ## [7] "C6_ONCOGENIC_SIGNATURES"   "C7_IMMUNOLOGIC_SIGNATURES"

``` r
names(MSigDB$human)
```

    ## NULL

``` r
head(names(MSigDB$human$H))
```

    ## NULL

``` r
MSigDB$human$H$HALLMARK_PEROXISOME
```

    ## NULL

`getMSigInfo` function simply navigates to the broad institute website
with the relevant data

``` r
getMSigInfo('HALLMARK_PEROXISOME',)
```
