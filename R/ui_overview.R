ui_overview <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::fluidPage(
    shiny::fluidRow(
      shiny::column(
        width = 4,
        shinydashboard::box(
          width = NULL,
          title = "Modified artefacts",
          plotly::plotlyOutput(
            ns("proportion_mod_plot")
          )
        )
      ),
      shiny::column(
        width = 8,
        shinydashboard::box(
          width = NULL,
          title = "IGerM - Indexgeraetemodifikation",
          plotly::plotlyOutput(
            ns("IGerM_plot")
          )
        )
      )
    ),
    shiny::fluidRow(
      shiny::column(
        width = 7,
        shinydashboard::box(
          width = NULL,
          title = "Amount of basic forms",
          plotly::plotlyOutput(
            ns("gf_plot")
          )
        )
      ),
      shiny::column(
        width = 5,
        shinydashboard::box(
          width = NULL,
          title = "Size classes",
          plotly::plotlyOutput(
            ns("size_classes_plot")
          )
        )
      )
    )
  )
  
}
