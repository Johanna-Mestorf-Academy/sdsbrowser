ui_dynamic_plot <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::fluidPage(
    shiny::fluidRow(
      shiny::column(
        3,
        shiny::uiOutput(ns("var1_selection")),
        shiny::textOutput(ns("var1_complete_name")),
        shiny::tags$hr(),
        shiny::uiOutput(ns("var2_selection")),
        shiny::textOutput(ns("var2_complete_name")),
        shiny::tags$hr(),
        shiny::uiOutput(ns("var3_selection")),
        shiny::textOutput(ns("var3_complete_name"))
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