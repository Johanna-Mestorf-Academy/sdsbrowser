ui_table <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::fluidPage(
    shiny::fluidRow(
      ui_load_data(ns("load_data")),
      shinydashboard::box(
        width = 8,
        status = "info",
        height = "200px",
        title = "Dataset",
        shiny::htmlOutput(ns("dataset_description"))
      )
    ),
    shiny::fluidRow(
      shinydashboard::box(
        width = 12,
        lineupjs::lineupOutput(
          ns("lineup1"),
          width = "100%",
          height = "65vh"
        )
      )
    )
  )
  
}
