#    java -jar /home/omancarci/Downloads/selenium-server-standalone-3.3.1.jar -port 4445 
library(RSelenium)
library(stringr)
library(magrittr)
require(XML)
library(purrr)
library(dplyr)
library(RCurl)
library(ogbox)
library(git2r)

system('java -jar /home/omancarci/Downloads/selenium-server-standalone-3.3.1.jar -port 4445 &')



cprof<-makeFirefoxProfile(list(
    #browser.download.dir = '/home/omancarci/git repos/MSigDB/data-raw/', # this line doesn't work. not sure why
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

webElem = remDr$findElement(using = 'partial link text', value = "symbols.gmt")

text = webElem$getElementText()
MSigVersion = text %>% str_extract('(?<=v).*?(?=.symbols)')


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
        webElem = remDr$findElement(using = 'partial link text', value = paste0(x,'v',MSigVersion,".symbols.gmt"))
        webElem$clickElement()
        # wait for download to be completed
        Sys.sleep(3)
        file.copy(from=paste0('/home/omancarci/Downloads/',x,'v',MSigVersion,'.symbols.gmt'),
                  to =paste0('data-raw/',x,'symbols.gmt'),overwrite = TRUE)
    }
    
    
    
    HALLMARK = 'data-raw/h.all.symbols.gmt'
    C1_POSITIONAL = 'data-raw/c1.all.symbols.gmt'
    C2_CURATED = 'data-raw/c2.all.symbols.gmt'
    C3_MOTIF = 'data-raw/c3.all.symbols.gmt'
    C4_COMPUTATIONAL = 'data-raw/c4.all.symbols.gmt'
    C5_GENE_ONTOLOGY = 'data-raw/c5.all.symbols.gmt'
    C6_ONCOGENIC_SIGNATURES = 'data-raw/c6.all.symbols.gmt'
    C7_IMMUNOLOGIC_SIGNATURES = 'data-raw/c7.all.symbols.gmt'
    
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
    version = getVersion()
    version %<>% strsplit('\\.') %>% {.[[1]]}
    setVersion(paste(version[1],version[2],MSigVersion,sep='.'))
    

    writeLines(MSigVersion,con = 'data-raw/version')
    
    repo = repository('.')
    git2r::add(repo,path ='DESCRIPTION')
    git2r::add(repo,path = 'data/MSigDB.rda')
    git2r::add(repo,path = 'data-raw/*')
}


# auto kill server at the end
killPid = system(' ps ax  | grep selenium',intern = TRUE) %>% str_extract('^[0-9]*(?=\\s)')
killPid %>% sapply(function(x){
        system(paste('kill',x))
    }
)
    
