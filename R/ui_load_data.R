ui_load_data <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::fluidRow(
    shiny::column(
      3,
      shiny::fileInput(
        "file_upload", "Choose CSV File",
        multiple = FALSE,
        accept = c(
          "text/csv",
          "text/comma-separated-values,text/plain",
          ".csv"
        )
      )
    ),
    shiny::column(
      3,
      shiny::selectInput(
        "dataset_selection", "Select dataset",
        choices = c(
          "Kuesterberg",
          "Kaesebrot",
          "etc."
        )
      )
    )
  )
  
}
