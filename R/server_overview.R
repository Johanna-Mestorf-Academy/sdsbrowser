server_overview <- function(input, output, session, current_dataset) {
  
  ns <- session$ns
  
  if (TRUE) {
    shiny::callModule(server_overview_single, id = ns, current_dataset)
  } else if (FALSE) {
    shiny::callModule(server_overview_multi, id = ns, current_dataset)
  }
  
}
