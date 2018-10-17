ui_load_data <- function(id) {
  
  ns <- shiny::NS(id)
  
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
  )
  
  
}
