server_table <- function(input, output, session) {
  
  shiny::callModule(server_load_data, id = "table")
  
}
