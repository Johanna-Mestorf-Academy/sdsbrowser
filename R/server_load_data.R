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
      
      # get metainformation
      description <- sdsanalysis::get_description(data_name)
      site <- sdsanalysis::get_site(data_name)
      coords <- sdsanalysis::get_coords(data_name)
      dating <- sdsanalysis::get_dating(data_name)
      creator <- sdsanalysis::get_creator(data_name)
      
      
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
        data_name = data_name,
        data = sds_decoded,
        raw_data = sds,
        data_type = data_type,
        description = description,
        site = site,
        coords = coords,
        dating = dating,
        creator = creator
      )
      
      shiny::incProgress(1, detail = "Ready")
      
    })
    
    return(res)
  
  })
  
  #### infoboxes #####
  output$DATA <- shinydashboard::renderInfoBox({
    shinydashboard::infoBox(
      title = "Data",
      icon = shiny::icon("database"),
      color = "purple",
      fill = TRUE,
      value = shiny::HTML(paste0(current_dataset()$data_name, "<br> by ", current_dataset()$creator))
    )
  })
  output$AMOUNT_OF_ARTEFACTS <- shinydashboard::renderInfoBox({
    shinydashboard::infoBox(
      title = "Amount of artefacts",
      icon = shiny::icon("bar-chart"),
      color = "purple",
      fill = TRUE,
      value = "testvalue - not implemented yet"
    )
  })
  
  # prepare description HTML text output
  output$dataset_description <- shiny::renderUI({
    shiny::HTML(paste(current_dataset()$description, collapse = "<br><br>"))
  })
  
  # prepare map
  output$sitemap <- leaflet::renderLeaflet({
    
    shiny::withProgress(message = 'Loading data', value = 0, {
    
      all_datasets <- sdsanalysis::get_available_datasets()
      all_coordinates <- sdsanalysis::get_coords(all_datasets)
      all_sites <- sdsanalysis::get_site(all_datasets)
      all_datings <- sdsanalysis::get_dating(all_datasets)
      
      possible_colours <- c(
        "purple", "red", "blue", "darkred", "orange", "beige", "green", 
        "darkgreen",  "darkblue", "black",
        "purple", "darkpurple", "pink", "cadetblue", "gray"
      )
      
      datings_factor <- as.factor(all_datings)
      levels(datings_factor) <- possible_colours[1:length(unique(all_datings))]
      colour_vector <- as.character(datings_factor)
      
      dating_icons <- leaflet::awesomeIcons(
        icon = 'ios-close',
        iconColor = 'black',
        library = 'ion',
        markerColor = colour_vector
      )
      
      shiny::incProgress(1, detail = "Preparing Map")
      
      resmap <- leaflet::addLegend(
        leaflet::addAwesomeMarkers(
          leaflet::addProviderTiles(
            leaflet::leaflet(), 
            leaflet::providers$Stamen.TonerLite,
            options = leaflet::providerTileOptions(noWrap = TRUE)
          ),
          lng = all_coordinates$lon, 
          lat = all_coordinates$lat, 
          popup = all_sites,
          icon = dating_icons
        ),
        labels = unique(all_datings),
        colors = levels(datings_factor)
      )
    
      shiny::incProgress(1, detail = "Ready")
      
    })
      
    return(resmap)
    
  })
  
  shiny::observeEvent(input$dataset_selection, {
    
    leaflet::addCircleMarkers(
      leaflet::clearGroup(leaflet::leafletProxy("sitemap"), "active_selection"),
      lng = sdsanalysis::get_coords(input$dataset_selection)[2], 
      lat = sdsanalysis::get_coords(input$dataset_selection)[1],
      radius = 20,
      color = "#605ca8",
      stroke = FALSE, 
      fillOpacity = 0.5,
      group = "active_selection"
    )
    
  })
  
  # data-download
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
