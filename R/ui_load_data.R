ui_load_data <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::column(
    2,
    shiny::h4("Available data"),
    shiny::uiOutput(ns("dataset_selection")),
    fluidRow(
      shiny::column(
        6,
        shiny::actionButton(
          "download_dataset", "Download raw",
          icon = shiny::icon("download")
        )
      ),
      shiny::column(
        6,
        shiny::actionButton(
          "download_dataset", "decoded",
          icon = shiny::icon("download")
        )
      )
    ),
    shiny::br(), shiny::br()
  )
  
  
}
