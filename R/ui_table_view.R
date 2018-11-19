ui_table <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::fluidPage(
    shiny::fluidRow(
      shinydashboard::box(
        width = 12,
        shiny::uiOutput(ns("table_header")),
        shiny::hr(),
        lineupjs::lineupOutput(
          ns("lineup1"),
          width = "100%",
          height = "80vh"
        )
      )
    )
  )
  
}
