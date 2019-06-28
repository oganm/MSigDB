library(rvest)
library(stringr)
library(magrittr)
library(purrr)
library(ogbox)

url = "http://software.broadinstitute.org/gsea/downloads.jsp"
session <-html_session(url)               ## create session
form    <-html_form(session)[[1]]       ## pull form from session


filled_form = set_values(form, j_username = "ogan.mancarcii@gmail.com")

session = submit_form(session,filled_form)

dataList = html_nodes(session,'.lists1')[[2]]


session %>%
    html_node(xpath = '//*[@id="content_full"]/table[2]//*[contains(text(),"symbols.gmt")]') %>% 
    html_text() %>% 
    str_extract('(?<=v).*?(?=.symbols)') -> 
    MSigVersion

groupsToDownload= c('h.all.',
                    'c1.all.',
                    'c2.all.',
                    'c3.all.',
                    'c4.all.',
                    'c5.all.',
                    'c6.all.',
                    'c7.all.')


if(MSigVersion!=readLines('data-raw/version')){
    for(x in groupsToDownload){
        datalinks = dataList %>% html_nodes(glue::glue('a[href*="{x}"]'))
        datalinks %<>% sapply(html_attr,'href')
        symbolLink = datalinks[grepl('symbols',datalinks)]
        entrezLink = datalinks[grepl('entrez',datalinks)]
        
        symbols = rvest::jump_to(session,url = glue::glue('http://software.broadinstitute.org/gsea/{symbolLink}'))
        entrez = rvest::jump_to(session,url = glue::glue('http://software.broadinstitute.org/gsea/{entrezLink}'))
        
        writeLines(symbols$response %>% as.character,paste0('data-raw/',x,'symbols.gmt'))
        writeLines(entrez$response %>% as.character,paste0('data-raw/',x,'entrez.gmt'))
    }
    
    
    
    HALLMARK = 'data-raw/h.all.symbols.gmt'
    C1_POSITIONAL = 'data-raw/c1.all.symbols.gmt'
    C2_CURATED = 'data-raw/c2.all.symbols.gmt'
    C3_MOTIF = 'data-raw/c3.all.symbols.gmt'
    C4_COMPUTATIONAL = 'data-raw/c4.all.symbols.gmt'
    C5_GENE_ONTOLOGY = 'data-raw/c5.all.symbols.gmt'
    C6_ONCOGENIC_SIGNATURES = 'data-raw/c6.all.symbols.gmt'
    C7_IMMUNOLOGIC_SIGNATURES = 'data-raw/c7.all.symbols.gmt'
    
    HALLMARK_entrez = 'data-raw/h.all.entrez.gmt'
    C1_POSITIONAL_entrez = 'data-raw/c1.all.entrez.gmt'
    C2_CURATED_entrez = 'data-raw/c2.all.entrez.gmt'
    C3_MOTIF_entrez = 'data-raw/c3.all.entrez.gmt'
    C4_COMPUTATIONAL_entrez = 'data-raw/c4.all.entrez.gmt'
    C5_GENE_ONTOLOGY_entrez = 'data-raw/c5.all.entrez.gmt'
    C6_ONCOGENIC_SIGNATURES_entrez = 'data-raw/c6.all.entrez.gmt'
    C7_IMMUNOLOGIC_SIGNATURES_entrez = 'data-raw/c7.all.entrez.gmt'
    
    MSigDB = list(HALLMARK = HALLMARK,
                  C1_POSITIONAL = C1_POSITIONAL,
                  C2_CURATED = C2_CURATED,
                  C3_MOTIF = C3_MOTIF,
                  C4_COMPUTATIONAL = C4_COMPUTATIONAL,
                  C5_GENE_ONTOLOGY = C5_GENE_ONTOLOGY,
                  C6_ONCOGENIC_SIGNATURES = C6_ONCOGENIC_SIGNATURES,
                  C7_IMMUNOLOGIC_SIGNATURES = C7_IMMUNOLOGIC_SIGNATURES)
    
    MSigDB_entrez = list(HALLMARK = HALLMARK_entrez,
                         C1_POSITIONAL = C1_POSITIONAL_entrez,
                         C2_CURATED = C2_CURATED_entrez,
                         C3_MOTIF = C3_MOTIF_entrez,
                         C4_COMPUTATIONAL = C4_COMPUTATIONAL_entrez,
                         C5_GENE_ONTOLOGY = C5_GENE_ONTOLOGY_entrez,
                         C6_ONCOGENIC_SIGNATURES = C6_ONCOGENIC_SIGNATURES_entrez,
                         C7_IMMUNOLOGIC_SIGNATURES = C7_IMMUNOLOGIC_SIGNATURES_entrez)
    
    MSigDB %<>% 
        map(readLines) %>% 
        map(map,function(x){strsplit(x,'\t')[[1]]}) %>% 
        map(function(x){
            names(x) = map(x,1)
            x = map(x, function(y)y[-c(1,2)])
            return(x)})
    
    MSigDB_entrez %<>%  
        map(readLines) %>% 
        map(map,function(x){strsplit(x,'\t')[[1]]}) %>% 
        map(function(x){
            names(x) = map(x,1)
            x = map(x, function(y)y[-c(1,2)])
            return(x)})
    
    devtools::use_data(MSigDB,overwrite = TRUE)
    devtools::use_data(MSigDB_entrez,overwrite = TRUE)
    
    version = getVersion()
    version %<>% strsplit('\\.') %>% {.[[1]]}
    setVersion(paste(version[1],version[2],MSigVersion,sep='.'))
    

    writeLines(MSigVersion,con = 'data-raw/version')
    
    repo = repository('.')
    git2r::add(repo,path ='DESCRIPTION')
    git2r::add(repo,path = 'data/MSigDB.rda')
    git2r::add(repo,path = 'data-raw/*')
    git2r::commit(repo,message = paste('Automatic update to version',MSigVersion))
    
    pass = readLines('data-raw/auth')
    cred = git2r::cred_user_pass('OganM',pass)
    git2r::push(repo,credentials = cred)
} else{
    print('Update not required')
}

