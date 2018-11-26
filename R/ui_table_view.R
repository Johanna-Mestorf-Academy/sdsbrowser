# ui module function for the Tab: "Table View"

ui_table_view <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::fluidPage(
    shiny::fluidRow(
      shinydashboard::box(
        width = 12,
        # text above table
        shiny::uiOutput(ns("table_header")),
        shiny::hr(),
        # table
        lineupjs::lineupOutput(
          ns("lineup1"),
          width = "100%",
          height = "80vh"
        )
      )
    )
  )
  
}
