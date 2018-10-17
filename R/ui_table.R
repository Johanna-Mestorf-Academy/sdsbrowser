ui_table <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::fluidPage(
    shiny::fluidRow(
      shiny::column(
        2,
        shiny::h4("Upload"),
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
      shiny::column(
        8,
        shiny::h4("Dataset"),
        shiny::htmlOutput(ns("dataset_description")),
        shiny::br(), shiny::br()
      )
    ),
    shiny::fluidRow(
      lineupjs::lineupOutput(
        ns("lineup1"),
        width = "100%",
        height = "70vh"
      )
    )
  )
  
}
