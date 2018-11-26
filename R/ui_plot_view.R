# ui module function for the Tab: "Plot View"

ui_plot_view <- function(id) {
  
  ns <- shiny::NS(id)
  
  # ui is dynamically prepared in the server function(s)
  shiny::uiOutput(ns("ui_plot_view"))
  
}
