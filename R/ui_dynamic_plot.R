ui_dynamic_plot <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::fluidPage(
    shiny::fluidRow(
      shiny::column(
        3,
        shiny::uiOutput(ns("var1_selection")),
        shiny::uiOutput(ns("var2_selection"))
      ),
      shiny::column(
        9,
        plotly::plotlyOutput(
          ns("rendered_dynamic_plot"),
          width = "100%",
          height = "90vh"
        )
      )
    )
  )
}