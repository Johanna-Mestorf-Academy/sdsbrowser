ui_dynamic_plot <- function(id) {
  
  ns <- shiny::NS(id)
  
  plotly::plotlyOutput(
    ns("rendered_dynamic_plot")
  )
  
}