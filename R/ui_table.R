ui_table <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::fluidPage(
    shiny::fluidRow(
      ui_load_data(id)
    ),
    shiny::fluidRow(
      shiny::column(
        2,
        shiny::HTML("test2")
      ),
      shiny::column(
        10,
        shiny::HTML("test3")
      )
    )
  )
  
}
