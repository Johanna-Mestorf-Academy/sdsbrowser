ui_table <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::fluidPage(
    shiny::fluidRow(
      shiny::column(
        2,
        shiny::HTML("test2")
      ),
      shiny::column(
        10,
        ui_load_data(id)
      )
    )
  )
  
}
