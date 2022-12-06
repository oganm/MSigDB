#' Get information about the gene set
#' @description Navigates to the relevant web page about the molecular signature
#' @param Msig name of the molecular signature
#' @param species Species that the signature belongs to
#' @export
getMSigInfo = function(Msig,species){
    link = paste0("https://www.gsea-msigdb.org/gsea/msigdb/",species,"/geneset/",Msig,".html")
    utils::browseURL(link)
}


#' MSigDB signature sets
#' @description This object houses gene lists from Broad Institute Molecular Signatures
"MSigDB"
