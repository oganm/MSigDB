require(XML)
data <- xmlParse("/home/omancarci/Downloads/msigdb_v5.2.xml")

xml_data <- xmlToList(data)

library(magrittr)
library(purrr)
library(dplyr)

library(RCurl)

msigdb = readLines('/home/omancarci/Downloads/msigdb.v5.2.symbols.gmt')
    
msigdb %<>% map(function(x){strsplit(x,'\t')[[1]]})
names = msigdb %>% map_chr(1)
links = msigdb %>% map_chr(2)


HALLMARK = 'data-raw/h.all.v5.2.symbols.gmt'
C1_POSITIONAL = 'data-raw/c1.all.v5.2.symbols.gmt'
C2_CURATED = 'data-raw/c2.all.v5.2.symbols.gmt'
C3_MOTIF = 'data-raw/c3.all.v5.2.symbols.gmt'
C4_COMPUTATIONAL = 'data-raw/c4.all.v5.2.symbols.gmt'
C5_GENE_ONTOLOGY = 'data-raw/c5.all.v5.2.symbols.gmt'
C6_ONCOGENIC_SIGNATURES = 'data-raw/c6.all.v5.2.symbols.gmt'
C7_IMMUNOLOGIC_SIGNATURES = 'data-raw/c7.all.v5.2.symbols.gmt'

MSigDB = list(HALLMARK = HALLMARK,
                C1_POSITIONAL = C1_POSITIONAL,
                C2_CURATED = C2_CURATED,
                C3_MOTIF = C3_MOTIF,
                C4_COMPUTATIONAL = C4_COMPUTATIONAL,
                C5_GENE_ONTOLOGY = C5_GENE_ONTOLOGY,
                C6_ONCOGENIC_SIGNATURES = C6_ONCOGENIC_SIGNATURES,
                C7_IMMUNOLOGIC_SIGNATURES = C7_IMMUNOLOGIC_SIGNATURES)

MSigDB %<>% 
    map(readLines) %>% 
    map(map,function(x){strsplit(x,'\t')[[1]]}) %>% 
    map(function(x){
        names(x) = map(x,1)
        x = map(x, function(y)y[-c(1,2)])
        return(x)})

devtools::use_data(MSigDB,overwrite = TRUE)
    
