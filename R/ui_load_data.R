ui_load_data <- function(id) {
  
  ns <- shiny::NS(id)
  
  shinydashboard::box(
    width = 2,
    height = "200px",
    status = "primary",
    title = "Available data",
    shiny::uiOutput(ns("dataset_selection")),
    shiny::fluidRow(
      shiny::column(
        6,
        shiny::uiOutput(ns("raw_download_ui"))
      ),
      shiny::column(
        6,
        shiny::uiOutput(ns("decoded_download_ui"))
      )
    )
  )
  
  
}
