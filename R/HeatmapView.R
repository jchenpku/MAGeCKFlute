#' Draw heatmap
#'
#' @docType methods
#' @name HeatmapView
#' @rdname HeatmapView
#'
#' @param mat Matrix like object, each row is gene and each column is sample.
#' @param limit Max value in heatmap
#' @param colPal colorRampPalette.
#' @param filename File path where to save the picture.
#' @param width Manual option for determining the output file width in inches.
#' @param height Manual option for determining the output file height in inches.
#' @param ... Other parameters in pheatmap.
#'
#' @return Invisibly a pheatmap object that is a list with components.
#' @author Wubing Zhang
#'
#' @examples
#' data(mle.gene_summary)
#' dd = ReadBeta(mle.gene_summary, organism="hsa")
#' gg = cor(dd[,3:ncol(dd)])
#' HeatmapView(gg, display_numbers = TRUE)
#'
#' @import pheatmap
#' @importFrom grDevices colorRampPalette
#' @export

HeatmapView <- function(mat, limit=c(-2, 2),
                        colPal = rev(colorRampPalette(c("#c12603", "white", "#0073B6"), space = "Lab")(199)),
                        filename = NA, width = NA, height = NA, ...){
  mat[is.na(mat)] = 0
  mat[mat>limit[2]] = limit[2]
  mat[mat< limit[1]] = limit[1]
  breaks = seq(limit[1], limit[2], length.out = 200)
  pheatmap::pheatmap(mat, color=colPal, breaks=breaks, border_color=NA,
                     fontfamily = "Helvetica", filename=filename,
                     width=width, height = height, ...)
}
