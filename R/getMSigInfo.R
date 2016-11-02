#' Get information about the gene set
#' @description Navigates to the relevant web page about the molecular signature
#' @param Msig name of the molecular signature
#' @export
getMSigInfo = function(Msig){
    link = paste0("http://software.broadinstitute.org/gsea/msigdb/cards/",Msig,'.html')
    utils::browseURL(link)
}


#' MSigDB signature sets
#' @description This object houses gene lists from Broad Institute Molecular Signatures
"MSigDB"
