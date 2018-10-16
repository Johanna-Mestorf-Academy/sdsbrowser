theme_sds <- function(background_colour = "#ECF0F5") {
  ggplot2::theme_bw() +
    ggplot2::theme(
      panel.background = ggplot2::element_rect(fill = background_colour, color = "black"),
      plot.background = ggplot2::element_rect(fill = background_colour, color = "black"),
      panel.grid.minor = ggplot2::element_line(colour = "darkgrey", size = 0.5),
      panel.grid.major = ggplot2::element_line(colour = "darkgrey", size = 1),
      axis.text.x = ggplot2::element_text(angle = 45, vjust = 1, hjust = 1), 
      axis.text.y = ggplot2::element_text(angle = 45, vjust = -1, hjust = 1.5)
    )
}