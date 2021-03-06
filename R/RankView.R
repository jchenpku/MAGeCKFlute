#' View the rank of gene points
#'
#' Rank all genes according to beta score deviation, and label top and bottom meaningful genes.
#' Some other interested genes can be labeled too.
#'
#' @docType methods
#' @name RankView
#' @rdname RankView
#' @aliases rankview
#'
#' @param rankdata Numeric vector, with gene as names.
#' @param genelist Character vector, specifying genes to be labeled in figure.
#' @param top Integer, specifying number of top genes to be labeled.
#' @param bottom Integer, specifying number of bottom genes to be labeled.
#' @param cutoff A two-length numeric vector, in which first value is bottom cutoff, and second value is top cutoff.
#' @param main As in 'plot'.
#' @param filename Figure file name to create on disk. Default filename="NULL", which means no output.
#' @param width As in ggsave.
#' @param height As in ggsave.
#' @param ... Other available parameters in function 'ggsave'.
#'
#'
#' @return An object created by \code{ggplot}, which can be assigned and further customized.
#'
#' @author Wubing Zhang
#'
#'
#' @examples
#' data(rra.gene_summary)
#' rra = ReadRRA(rra.gene_summary, organism = "hsa")
#' rankdata = rra$LFC
#' names(rankdata) = rra$Official
#' RankView(rankdata)
#'
#' @importFrom ggrepel geom_label_repel
#'
#' @export
#'

RankView <- function(rankdata, genelist=NA, top=20, bottom=20,
                     cutoff=c(-sd(rankdata), sd(rankdata)),
                     main=NULL, filename=NULL, width=5, height=4, ...){
  requireNamespace("ggrepel", quietly=TRUE) || stop("need ggrepel package")
  message(Sys.time(), " # Rank genes and plot...")
  data = data.frame(Gene = names(rankdata), diff = rankdata, stringsAsFactors=FALSE)
  data$Rank = rank(data$diff)
  data$group = "no"
  data$group[data$diff>cutoff[2]] = "up"
  data$group[data$diff<cutoff[1]] = "down"


  idx=(data$Rank<=bottom) | (data$Rank>(max(data$Rank)-top)) | (data$Gene %in% genelist)
  mycolour = c("no"="gray80",  "up"="#e41a1c","down"="#377eb8")
  p = ggplot()
  p = p + geom_point(aes(x=diff,y=Rank,color=factor(data$group)),data=data,size=0.5)
  p = p + scale_color_manual(values=mycolour)
  p = p + geom_jitter(width = 0.1, height = 0.1)
  p = p + theme(panel.background = element_rect(fill='white', colour='black'))
  p = p + geom_vline(xintercept = 0,linetype = "dotted")+geom_vline(xintercept = cutoff,linetype = "dotted")
  p = p + theme(text = element_text(colour="black",size = 14, family = "Helvetica"),
                plot.title = element_text(hjust = 0.5, size=18),
                axis.text = element_text(colour="gray10"))
  p = p + theme(axis.line = element_line(size=0.5, colour = "black"),
                panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                panel.border = element_blank(), panel.background = element_blank())
  p = p + geom_label_repel(aes(x=diff, y=Rank,fill=group,label = Gene),data=data[idx,],
                       fontface = 'bold', color = 'white',size = 2.5,
                       box.padding = unit(0.4, "lines"), segment.color = 'grey50',
                       point.padding = unit(0.3, "lines"), segment.size = 0.3)
  p = p + scale_fill_manual(values=mycolour)
  p = p + labs(x="Treatment-Control beta score",y="Rank",title=main)
  p = p + theme(legend.position="none")#+ylim(-1000,7000)

  if(!is.null(filename)){
    ggsave(plot=p, filename=filename, units = "in", width=width, height=height, ...)
  }
  return(p)
}
