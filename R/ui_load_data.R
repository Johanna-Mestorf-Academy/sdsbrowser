ui_load_data <- function(id) {
  
  ns <- shiny::NS(id)
  
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
    shiny::column(
      2,
      shiny::h4("Available data"),
      shiny::selectInput(
        "dataset_selection", "Select dataset",
        choices = c(
          "Kuesterberg",
          "Kaesebrot",
          "etc."
        )
      ),
      shiny::actionButton(
        "download_dataset", "Download data",
        icon = shiny::icon("download")
      ),
      shiny::br(), shiny::br(), shiny::br()
    ),
    shiny::column(
      8,
      shiny::h4("Dataset"),
      shiny::textOutput(ns("dataset_intro")),
      shiny::br(), shiny::br()
    )
  )
  
}
