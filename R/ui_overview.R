ui_overview <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::fluidPage(
    shiny::fluidRow(
      shiny::column(
        width = 6,
        shinydashboard::box(
          width = NULL,
          plotly::plotlyOutput(
            ns("gf_plot")
          )
        )
      ),
      shiny::column(
        width = 6,
        shinydashboard::box(
          width = NULL,
          plotly::plotlyOutput(
            ns("IGerM_plot")
          )
        )
      )
    ),
    shiny::fluidRow(
      shiny::column(
        width = 6,
        shinydashboard::box(
          width = NULL,
          plotly::plotlyOutput(
            ns("proportion_mod_plot")
          )
        )
      ),
      shiny::column(
        width = 6,
        shinydashboard::box(
          width = NULL,
          plotly::plotlyOutput(
            ns("size_classes_plot")
          )
        )
      )
    )
  )
  
}
