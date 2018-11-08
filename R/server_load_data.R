server_load_data <- function(input, output, session) {
  
  ns <- session$ns

  output$dataset_selection <- shiny::renderUI({
    shiny::selectInput(
      ns("dataset_selection"), 
      "Select dataset",
      choices = sdsanalysis::get_available_datasets(),
      width = "100%"
    )
  })
  
  output$dataset_type_selection <- shiny::renderUI({
    shiny::req(
      input$dataset_selection
    )
    shiny::selectInput(
      ns("dataset_type_selection"), 
      "Select type",
      choices = sdsanalysis::get_type_options(input$dataset_selection),
      width = "100%"
    )
  })
  
  current_dataset <- shiny::eventReactive(input$load_data_button, {
    
    # wait for input to load
    shiny::req(
      input$dataset_type_selection,
      input$dataset_selection
    )
    
    shiny::withProgress(message = 'Loading data', value = 0, {
    
      data_type <- input$dataset_type_selection
      data_name <- input$dataset_selection
      
      shiny::incProgress(0.1, detail = "Downloading")
      
      # get description
      description <- sdsanalysis::get_description(data_name)
  
      # check if selected data type is available for this dataset
      if (!(data_type %in% sdsanalysis::get_type_options(data_name))) {
        data_type <- sdsanalysis::get_type_options(data_name)[1]
      }
      
      # get data based on selected data type
      if (data_type == "single_artefacts") {
        sds <- sdsanalysis::get_single_artefact_data(data_name)
      } else {
        sds <- sdsanalysis::get_multi_artefact_data(data_name)
      }
      
      shiny::incProgress(0.3, detail = "Decoding")
      
      # decode data
      sds_decoded <- sdsanalysis::lookup_everything(sds)
      
      # prepare output list
      res <- list(
        data = sds_decoded,
        raw_data = sds,
        data_type = data_type,
        description = description
      )
      
      shiny::incProgress(1, detail = "Ready")
      
    })
    
    res
    
  })
  
  #data-download
  output$raw_download_ui <- shiny::renderUI({
    shiny::downloadButton(
      ns("raw_download"), "Download raw data",
      icon = shiny::icon("download"),
      class = "download_button"
    )
  })
  output$decoded_download_ui <- shiny::renderUI({
    shiny::downloadButton(
      ns("decoded_download"), "Download decoded data",
      icon = shiny::icon("download"),
      class = "download_button"
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
