theme_sds <- function(background_colour = "white") {
  ggplot2::theme_bw() +
    ggplot2::theme(
      # background
      panel.background = ggplot2::element_rect(fill = background_colour, color = "black"),
      plot.background = ggplot2::element_rect(fill = background_colour, color = "black"),
      # grid lines
      panel.grid.minor = ggplot2::element_line(colour = "darkgrey", size = 0.5),
      panel.grid.major = ggplot2::element_line(colour = "darkgrey", size = 1),
      # axis
      axis.text.x = ggplot2::element_text(angle = 45, vjust = 1, hjust = 1), 
      axis.text.y = ggplot2::element_text(angle = 45, vjust = -1, hjust = 1.5),
      # legend
      legend.key = ggplot2::element_rect(fill = background_colour),
      legend.background = ggplot2::element_rect(fill = background_colour)
    )
}

# colour palette
d3.schemeCategory10 <- function() {
  return(c(
    "#1f77b4",
    "#ff7f0e", 
    "#2ca02c", 
    "#d62728",
    "#9467bd",
    "#8c564b",
    "#e377c2",
    "#7f7f7f",
    "#bcbd22",
    "#17becf"
  ))
}
  
  