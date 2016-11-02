
MSigDB
======

Houses gene lists from [Broad Institute Molecular Signatures](http://software.broadinstitute.org/gsea/msigdb/index.jsp) Database. They do want to keep track of their user counts so you might want to log in there as well.

Usage
=====

``` r
library(MSigDB)
names(MSigDB)
```

    ## [1] "HALLMARK"                  "C1_POSITIONAL"            
    ## [3] "C2_CURATED"                "C3_MOTIF"                 
    ## [5] "C4_COMPUTATIONAL"          "C5_GENE_ONTOLOGY"         
    ## [7] "C6_ONCOGENIC_SIGNATURES"   "C7_IMMUNOLOGIC_SIGNATURES"

``` r
head(names(MSigDB$HALLMARK))
```

    ## [1] "HALLMARK_TNFA_SIGNALING_VIA_NFKB"   
    ## [2] "HALLMARK_HYPOXIA"                   
    ## [3] "HALLMARK_CHOLESTEROL_HOMEOSTASIS"   
    ## [4] "HALLMARK_MITOTIC_SPINDLE"           
    ## [5] "HALLMARK_WNT_BETA_CATENIN_SIGNALING"
    ## [6] "HALLMARK_TGF_BETA_SIGNALING"

``` r
head(MSigDB$HALLMARK$HALLMARK_COMPLEMENT)
```

    ## [1] "C2"       "C1S"      "CFB"      "C1R"      "SERPINE1" "MMP14"

`getMSigInfo` function simply navigates to the broad institute website with the relevant data

``` r
getMSigInfo('HALLMARK_COMPLEMENT')
```
