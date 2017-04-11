#    java -jar /home/omancarci/Downloads/selenium-server-standalone-3.3.1.jar -port 4445 



library(RSelenium)
library(stringr)
library(magrittr)


cprof<-makeFirefoxProfile(list(
    browser.download.dir = '/home/omancarci/git repos/MSigDB/data-raw/',
    browser.helperApps.neverAsk.saveToDisk='text/plain, text/xml,application/xml, application/vnd.ms-excel, text/csv, text/comma-separated-values, application/octet-stream',
    browser.download.manager.showWhenStarting = FALSE
))

remDr <- remoteDriver(remoteServerAddr = "localhost"
                      , port = 4445L
                      , browserName = "firefox",
                      extraCapabilities=cprof
                      
)

remDr$open()

remDr$navigate("http://software.broadinstitute.org/gsea/downloads.jsp")


webElem = remDr$findElement(using = 'id', value = "email")

webElem$sendKeysToElement(sendKeys = list('ogan.mancarcii@gmail.com'))
webElem = remDr$findElement(using = 'name', value = "login")
webElem$clickElement()

webElem = remDr$findElement(using = 'partial link text', value = ".xml")
text = webElem$getElementText()
version = text %>% str_extract('(?<=v).*?(?=.xml)')

link = webElem$getElementAttribute(attrName = 'href')[[1]]
webElem$clickElement()

remDr$navigate(link)

webElem$acceptAlert()

link = remDr$getPageSource()[[1]] %>% str_extract('Current MSigDB xml file.*\n.*\n') %>% str_extract('msigdb/download_file.*?.xml(?=")')

download.file(paste0('software.broadinstitute.org/gsea/',link),destfile = 'data-raw/msigdb.xml')

# above this part isn't complete yet ---------------------------------------------------
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
    
