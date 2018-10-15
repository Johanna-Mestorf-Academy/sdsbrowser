ui_dynamic_plot <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::fluidPage(
    shiny::fluidRow(
      shiny::column(
        3,
        shiny::uiOutput(ns("var1_selection"))
      ),
      shiny::column(
        3,
        shiny::uiOutput(ns("var2_selection"))
      )
    ),
    shiny::fluidRow(
      plotly::plotlyOutput(
        ns("rendered_dynamic_plot")
      )
    )
  )
  
}