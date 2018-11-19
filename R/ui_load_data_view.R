ui_load_data <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::fluidPage(
    shiny::fluidRow(
      shiny::column(
        width = 5,
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
        ),
        shiny::conditionalPanel(
          paste0("input['", ns("load_data_button"), "'] == 0 "),
          shinydashboard::infoBox(
            title = "Information",
            value = "No data loaded.", 
            width = 12,
            color = "orange",
            fill = TRUE,
            icon = shiny::icon("exclamation-triangle")
          )
        ),
        shinydashboard::infoBoxOutput(ns("DATA"), width = 12),
        shinydashboard::infoBoxOutput(ns("AMOUNT_OF_ARTEFACTS"), width = 12),
        shiny::conditionalPanel(
          paste0("input['", ns("load_data_button"), "'] >= 1 "),
          shinydashboard::box(
            width = 12,
            status = "info",
            title = "Description",
            shiny::htmlOutput(ns("dataset_description"))
          )
        )
      ),
      shiny::column(
        width = 7,
        shinydashboard::box(
          width = 12,
          title = "Map of sites",
          leaflet::leafletOutput(
            ns("sitemap"),
            width = "100%",
            height = "80vh"
          )
        )
      )
    )
  )
  
  
}
