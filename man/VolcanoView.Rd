% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/VolcanoView.R
\docType{methods}
\name{VolcanoView}
\alias{VolcanoView}
\title{Volcano View}
\usage{
VolcanoView(df, x = "logFC", y = "adj.P.Val", Label = NA, top = 5,
  topnames = NULL, filename = NULL, x_cutoff = log2(1.5),
  y_cutoff = 0.05, main = NULL, xlab = "Log2 Fold Change",
  ylab = "-Log10(Adjust.P)", ...)
}
\arguments{
\item{df}{Data frame}

\item{x}{Colname of df specifying x-axis in Volcanno figure, 'logFC' (default).}

\item{y}{Colname of df specifying y-axis in Volcanno figure, 'adj.P.Val' (default).}

\item{Label}{Colname of df specifying labeled terms in Volcanno figure.}

\item{top}{Interger, the number of top significant terms to be labeled.}

\item{topnames}{Character vector, indicating interested terms to be labeled.}

\item{filename}{Figure file name to create on disk. Default filename="NULL",
which means don't save the figure on disk.}

\item{x_cutoff}{Cutoff of x-axis.}

\item{y_cutoff}{Cutoff of y-axis.}

\item{main}{Title of volcano figure.}

\item{xlab}{Label of x-axis in figure.}

\item{ylab}{Label of y-axis in figure.}

\item{...}{Other available parameters in ggsave.}
}
\value{
An object created by \code{ggplot}, which can be assigned and further customized.
}
\description{
Volcano plot
}
\examples{
data(rra.gene_summary)
rra = ReadRRA(rra.gene_summary)
VolcanoView(rra, x = "LFC", y = "FDR", Label = "Official")

}
\author{
Wubing Zhang
}
