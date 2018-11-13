ui_table <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::fluidPage(
    shiny::fluidRow(
      shiny::column(
        width = 3,
        shinydashboard::infoBox(
          width = 12,
          title = "Data",
          icon = shiny::icon("table"),
          color = "purple",
          fill = TRUE,
          value = shiny::HTML("Wangels <br> by Jan Piet Brozio")
        ),
        shinydashboard::infoBox(
          width = 12,
          title = "Amount of artefacts",
          icon = shiny::icon("bar-chart"),
          color = "purple",
          fill = TRUE,
          value = "1145"
        )
      ),
      shinydashboard::box(
        width = 5,
        status = "info",
        height = "200px",
        shiny::htmlOutput(ns("dataset_description"))
      )
    ),
    shiny::fluidRow(
      shinydashboard::box(
        width = 12,
        shiny::uiOutput(ns("table_header")),
        shiny::hr(),
        lineupjs::lineupOutput(
          ns("lineup1"),
          width = "100%",
          height = "65vh"
        )
      )
    )
  )
  
}
