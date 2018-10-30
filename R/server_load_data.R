server_load_data <- function(input, output, session) {
  
  ns <- session$ns

  output$dataset_type_selection <- shiny::renderUI({
    shiny::selectInput(
      ns("dataset_type_selection"), 
      "Select type",
      choices = c("single", "multi")
    )
  })
  
    
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
      input$dataset_type_selection,
      input$dataset_selection
    )
    
    if (input$dataset_type_selection == "single") {
      sds <- sdsanalysis::get_single_artefact_data(input$dataset_selection)
    } else if (input$dataset_type_selection == "multi") {
      sds <- sdsanalysis::get_single_artefact_data(input$dataset_selection)
    }
    
    sds_decoded <- sdsanalysis::lookup_everything(sds)
    
    hu <- dplyr::mutate_if(
      sds_decoded,
      .predicate = function(x) {!any(is.na(x)) & is.character(x) & length(unique(x)) > 1 & length(unique(x)) <= 8},
      .funs = as.factor
    )
    
    hu
    
    list(
      data = hu,
      raw_data = sds,
      description = sdsanalysis::get_description(input$dataset_selection)
    )
    
  })
  
  #data-download
  output$raw_download_ui <- shiny::renderUI({
    shiny::downloadButton(
      ns("raw_download"), "raw",
      icon = shiny::icon("download")
    )
  })
  output$decoded_download_ui <- shiny::renderUI({
    shiny::downloadButton(
      ns("decoded_download"), "decoded",
      icon = shiny::icon("download")
    )
  })
  output$raw_download <- shiny::downloadHandler(
    filename = function() {
      shiny::req(input$dataset_selection)
      paste0("raw_", input$dataset_selection, ".csv")
    },
    content = function(file) {
      utils::write.table(
        current_dataset()$raw_data, 
        file,
        dec = ".",
        sep = ',',
        col.names = TRUE,
        row.names = FALSE,
        eol = "\n",
        quote = TRUE,
        qmethod = "escape",
        fileEncoding = "UTF-8"
      )
    }
  )
  output$decoded_download <- shiny::downloadHandler(
    filename = function() {
      shiny::req(input$dataset_selection)
      paste0("decoded_", input$dataset_selection, ".csv")
    },
    content = function(file) {
      utils::write.table(
        current_dataset()$data, 
        file,
        dec = ".",
        sep = ',',
        col.names = TRUE,
        row.names = FALSE,
        eol = "\n",
        quote = TRUE,
        qmethod = "escape",
        fileEncoding = "UTF-8"
      )
    }
  )
  
  
  return(current_dataset)
  
}
