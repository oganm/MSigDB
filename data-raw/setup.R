library(rvest)
library(stringr)
library(magrittr)
library(purrr)
library(ogbox)
library(git2r)

url = "http://software.broadinstitute.org/gsea/downloads.jsp"
session <-session(url)               ## create session
form    <-html_form(session)[[1]]       ## pull form from session


filled_form = html_form_set(form, username = "ogan.mancarcii@gmail.com")

session = session_submit(session,filled_form)

dataList = html_nodes(session,'.lists1')

session %>% 
    html_node(xpath = '//*[@id="content_full"]/table[2]/tbody/tr[2]/td[2]/a')

msigdb_links = c(human = "https://www.gsea-msigdb.org/gsea/msigdb/download_file.jsp?filePath=/msigdb/release/2022.1.Hs/msigdb_v2022.1.Hs_files_to_download_locally.zip",
                 mouse = "https://www.gsea-msigdb.org/gsea/msigdb/download_file.jsp?filePath=/msigdb/release/2022.1.Mm/msigdb_v2022.1.Mm_files_to_download_locally.zip")


human = jump_to(session,url = "https://www.gsea-msigdb.org/gsea/msigdb/download_file.jsp?filePath=/msigdb/release/2022.1.Hs/msigdb_v2022.1.Hs_files_to_download_locally.zip")
human$response$content %>% writeBin('data-raw/human.zip')

mouse = jump_to(session, url = "https://www.gsea-msigdb.org/gsea/msigdb/download_file.jsp?filePath=/msigdb/release/2022.1.Mm/msigdb_v2022.1.Mm_files_to_download_locally.zip")
mouse$response$content %>% writeBin('data-raw/mouse.zip')


lapply(c('human','mouse'), function(x){
    unzip(glue::glue('data-raw/{x}.zip'),exdir = glue::glue('data-raw/{x}'))
    files = list.files(glue::glue('data-raw/{x}'),recursive = TRUE,full.names = TRUE)
    genes = files %>% grepl('xml',.) %>% {files[.]} %>% xml2::read_xml() %>% xml2::as_list()
    
    genes$MSIGDB
})-> data
names(data) = c('human','mouse')

data %>% lapply(function(x){
    categories = x %>% purrr::map_chr(function(y){
        attributes(y)$CATEGORY_CODE
    })
    genes = x %>% purrr::map(function(y){
        attributes(y)$MEMBERS_SYMBOLIZED %>% strsplit(',') %>% {.[[1]]}
    })
    name =  x %>% purrr::map_chr(function(y){
        attributes(y)$STANDARD_NAME
    })
    
    description = x %>% purrr::map_chr(function(y){
        attributes(y)$DESCRIPTION_BRIEF
    })
    
    categories %>% unique() %>% lapply(function(nm){
        out = genes[categories %in% nm]
        names(out) = name[categories %in% nm]
        
        for(i in seq_along(out)){
            attributes(out[[i]]) = list(description = description[categories %in% nm][i])
        }
        return(out)
    }) -> out
    
    names(out) = categories %>% unique()
    return(out)
}) -> MSigDB



data %>% lapply(function(x){
    categories = x %>% purrr::map_chr(function(y){
        attributes(y)$CATEGORY_CODE
    })
    entrez = x %>% purrr::map(function(y){
        attributes(y)$MEMBERS_EZID %>% strsplit(',') %>% {.[[1]]}
    })
    name =  x %>% purrr::map_chr(function(y){
        attributes(y)$STANDARD_NAME
    })
    
    description = x %>% purrr::map_chr(function(y){
        attributes(y)$DESCRIPTION_BRIEF
    })
    
    categories %>% unique() %>% lapply(function(nm){
        out = entrez[categories %in% nm]
        names(out) = name[categories %in% nm]
        
        for(i in seq_along(out)){
            attributes(out[[i]]) = list(description = description[categories %in% nm][i])
        }
        return(out)
    }) -> out
    
    
    names(out) = categories %>% unique()
    
    return(out)
}) -> MSigDB_entrez

usethis::use_data(MSigDB,overwrite = TRUE)
usethis::use_data(MSigDB_entrez,overwrite = TRUE)

