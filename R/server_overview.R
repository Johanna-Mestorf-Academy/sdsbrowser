server_overview <- function(input, output, session, current_dataset) {
  
  ns <- session$ns
  
  output$ui_overview <- shiny::reactive({

    if (current_dataset()$data_type == "single_artefacts") {
      ui_overview <- shiny::callModule(server_overview_single, id = "overview", current_dataset)
    } else if (current_dataset()$data_type == "multi_artefacts") {
      ui_overview <- shiny::callModule(server_overview_multi, id = "overview", current_dataset)
    } 

    return(ui_overview())
    
  })

  
}
