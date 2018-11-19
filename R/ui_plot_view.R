ui_plot_view <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::uiOutput(ns("ui_plot_view"))
  
}
