# ui module function for the Tab: "Load Data View"

ui_load_data_view <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::fluidPage(
    shiny::fluidRow(
      #### left column: navigation and description ####
      shiny::column(
        width = 4,
        shinydashboard::box(
          width = 12,
          status = "primary",
          title = "Available data",
          # separation in two columns within box
          shiny::fluidRow(
            shiny::column(
              width = 12,
              # dataset selection dropdown menus
              shiny::uiOutput(ns("dataset_selection")),
              shiny::uiOutput(ns("dataset_type_selection")),
              # (download) buttons
              shiny::actionButton(ns("load_data_button"), "Load data", class = "load_data_button"),
              shiny::uiOutput(ns("raw_download_ui")),
              shiny::uiOutput(ns("decoded_download_ui")),
              shiny::uiOutput(ns("all_data_download_ui"))
            )
          )
        ),
        # if no data loaded: show orange box
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
        # if data loaded: show purple info boxes
        shinydashboard::infoBoxOutput(ns("DATA"), width = 12),
        shinydashboard::infoBoxOutput(ns("AMOUNT_OF_ARTEFACTS"), width = 12),
        # if data loaded: show dataset description box
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
      #### right column: map ####
      shiny::column(
        width = 8,
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
