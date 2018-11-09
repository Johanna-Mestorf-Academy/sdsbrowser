ui_overview_single <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::uiOutput(ns("ui_overview"))
  
}
