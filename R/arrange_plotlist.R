#' @title Arrange list of ggplots into single figure
#' @description A warpper around `ggpubr::ggarrange()`
#' @param plotlist List of plots to display.
#' @param ncol (optional) number of columns in the plot grid.
#' @param nrow (optional) number of rows in the plot grid.
#' @param labels (optional) list of labels to be added to the plots. You can
#'   also set labels="AUTO" to auto-generate upper-case labels or labels="auto"
#'   to auto-generate lower-case labels.
#' @param widths (optional) numerical vector of relative columns widths. For
#'   example, in a two-column grid, widths = c(2, 1) would make the first column
#'   twice as wide as the second column.
#' @param heights same as \code{widths} but for column heights.
#' @param legend character specifying legend position. Allowed values are one of
#'   c("top", "bottom", "left", "right", "none"). To remove the legend use
#'   legend = "none".
#' @param common_legend logical value. Default is FALSE. If TRUE, a common
#'   unique legend will be created for arranged plots.
#' @seealso [ggpubr::ggarrange()]
#' @export
arrange_plotlist <- function(plotlist,
                             ncol = NULL,
                             nrow = NULL,
                             labels = NULL,
                             widths = 1,
                             heights = 1,
                             legend = NULL,
                             common_legend = FALSE) {
  ggpubr::ggarrange(
    plotlist = plotlist,
    ncol = ncol,
    nrow = nrow,
    labels = labels,
    widths = widths,
    heights = heights,
    legend = legend,
    common.legend = common_legend
  ) %>%
    return()
}
