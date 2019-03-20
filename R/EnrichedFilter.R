#' Simplify the enrichment results based on Jaccard index
#'
#' @docType methods
#' @name EnrichedFilter
#' @rdname EnrichedFilter
#'
#' @param enrichment A data frame of enrichment result.
#' @param cutoff A numeric, specifying the cutoff of Jaccard index between two pathways.
#'
#' @return A data frame.
#'
#' @author Yihan Xiao
#' @examples
#' data(geneList, package = "DOSE")
#' enrichRes <- enrich.GSE(geneList)
#' EnrichedFilter(enrichment=slot(enrichRes, "result"))
#' @import data.table
#' @export

EnrichedFilter <- function(enrichment = enrichment, cutoff = 0.8){
  enrichment = enrichment[order(enrichment$p.adjust), ]
  genelist = strsplit(enrichment$geneID, "/")
  names(genelist) = enrichment$ID
  # Jaccard Index
  tmp1 = crossprod(table(stack(genelist)))
  tmp2 = outer(lengths(genelist), lengths(genelist), "+")
  ijc = tmp1 / (tmp2 - tmp1)
  diag(ijc) = 0
  idx <- which(ijc>cutoff, arr.ind = TRUE)
  colnames(idx) = c("row", "col")
  idx = as.data.table(idx)
  imat <- idx[, max_value:=max(row, col), by=1:nrow(idx)]
  enrichment <- enrichment[setdiff(1:nrow(enrichment), imat$max_value), ]
  # The second round simplification
  genelist = strsplit(enrichment$geneID, "/")
  names(genelist) = enrichment$ID
  tmp1 = crossprod(table(stack(genelist)))
  ijc2 = tmp1 / lengths(genelist)
  diag(ijc2) = 0
  idx <- which(ijc2>cutoff, arr.ind = TRUE)[,1]
  enrichment <- enrichment[setdiff(1:nrow(enrichment), idx), ]
  return(enrichment)
}