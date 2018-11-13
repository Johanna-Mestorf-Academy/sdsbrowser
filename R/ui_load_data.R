ui_load_data <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::fluidPage(
    shiny::fluidRow(
      shiny::column(
        width = 3,
        shinydashboard::box(
          width = 12,
          height = "200px",
          status = "primary",
          title = "Available data",
          shiny::fluidRow(
            shiny::column(
              6,
              shiny::uiOutput(ns("dataset_selection")),
              shiny::uiOutput(ns("dataset_type_selection"))
            ),
            shiny::column(
              6,
              shiny::actionButton(ns("load_data_button"), "Load data", class = "load_data_button"),
              shiny::uiOutput(ns("raw_download_ui")),
              shiny::uiOutput(ns("decoded_download_ui"))
            )
          )
        )
      )
    )
  )
  
  
}
