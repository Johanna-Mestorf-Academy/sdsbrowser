ui_table <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::fluidPage(
    shiny::fluidRow(
      shinydashboard::box(
        width = 2,
        height = "200px",
        title = "Upload",
        shiny::fileInput(
          "file_upload", "Upload CSV File",
          multiple = FALSE,
          accept = c(
            "text/csv",
            "text/comma-separated-values,text/plain",
            ".csv"
          )
        )
      ),
      ui_load_data(ns("load_data")),
      shinydashboard::box(
        width = 8,
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
          height = "70vh"
        )
      )
    )
  )
  
}
