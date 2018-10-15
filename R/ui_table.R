ui_table <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::fluidPage(
    ui_load_data(id),
    shiny::fluidRow(
      lineupjs::lineupOutput(
        ns("lineup1"),
        width = "100%",
        height = "80vh"
      )
    )
  )
  
}
