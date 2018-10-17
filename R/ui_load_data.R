ui_load_data <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::column(
    2,
    shiny::h4("Available data"),
    shiny::uiOutput(ns("dataset_selection")),
    shiny::actionButton(
      "download_dataset", "Download data",
      icon = shiny::icon("download")
    ),
    shiny::br(), shiny::br(), shiny::br()
  )
  
  
}
