ui_load_data <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::column(
    2,
    shiny::h4("Available data"),
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
    ),
    shiny::br(), shiny::br()
  )
  
  
}
