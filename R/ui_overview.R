ui_overview <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::fluidPage(
    shiny::fluidRow(
      shiny::column(
        width = 6,
        shinydashboard::box(
          width = NULL
        )
      ),
      shiny::column(
        width = 6,
        shinydashboard::box(
          width = NULL
        )
      )
    ),
    shiny::fluidRow(
      shiny::column(
        width = 6,
        shinydashboard::box(
          width = NULL
        )
      ),
      shiny::column(
        width = 6,
        shinydashboard::box(
          width = NULL
        )
      )
    )
  )
  
}
