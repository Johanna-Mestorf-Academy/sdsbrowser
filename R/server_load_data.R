server_load_data <- function(input, output, session) {
  
  ns <- session$ns
  
  output$dataset_selection <- shiny::renderUI({
    shiny::selectInput(
      ns("dataset_selection"), 
      "Select dataset",
      choices = sdsanalysis::get_available_datasets()
    )
  })
  
  current_dataset <- shiny::reactive({
    
    # wait for input to load
    shiny::req(
      input$dataset_selection
    )
    
    fb1 <- sdsanalysis::get_data(input$dataset_selection)
    
    fb1_decoded <- sdsanalysis::lookup_everything(fb1, 1)
    
    hu <- dplyr::mutate_if(
      fb1_decoded,
      .predicate = function(x) {!any(is.na(x)) & is.character(x) & length(unique(x)) > 1 & length(unique(x)) <= 8},
      .funs = as.factor
    )
    
    hu
    
    list(
      data = hu,
      description = sdsanalysis::get_description_HTML(input$dataset_selection)
    )
    
  })
  
  return(current_dataset)
  
}
