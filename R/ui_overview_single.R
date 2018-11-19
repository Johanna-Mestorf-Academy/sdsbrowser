ui_plot_view_single <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::uiOutput(ns("ui_plot_view"))
  
}
