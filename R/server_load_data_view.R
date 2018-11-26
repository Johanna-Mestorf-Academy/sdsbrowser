# server module function for the Tab: "Load Data View"

server_load_data_view <- function(input, output, session) {
  
  ns <- session$ns

  #### data selection dropdown menus ####
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
  
  #### data preparation: triggered by "Load data" button ####
  current_dataset <- shiny::eventReactive(input$load_data_button, {
    
    # wait for input to load
    shiny::req(
      input$dataset_type_selection,
      input$dataset_selection
    )
    
    # show progressbar for the following steps
    shiny::withProgress(message = 'Loading data', value = 0, {
    
      data_type <- input$dataset_type_selection
      data_name <- input$dataset_selection
      
      # update progressbar
      shiny::incProgress(0.1, detail = "Downloading")
      
      # get sds data metainformation
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
      
      # update progressbar
      shiny::incProgress(0.3, detail = "Decoding")
      
      # decode sds data
      sds_decoded <- sdsanalysis::lookup_everything(sds)
      
      # count artefacts
      if (data_type == "single_artefacts") {
        amount_of_artefacts <- nrow(sds_decoded)
      } else {
        amount_of_artefacts <- sum(sds_decoded$sammel_anzahl_artefakte, na.rm = TRUE)
      }
      
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
        creator = creator,
        amount_of_artefacts = amount_of_artefacts
      )
      
      # update progressbar
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
      value = current_dataset()$amount_of_artefacts
    )
  })
  
  #### prepare description HTML text output ####
  output$dataset_description <- shiny::renderUI({
    shiny::HTML(paste(current_dataset()$description, collapse = "<br>"))
  })
  
  #### prepare map ####
  output$sitemap <- leaflet::renderLeaflet({
    
    # show progressbar for the following steps
    shiny::withProgress(message = 'Loading data', value = 0, {
    
      # get relevant information abou the datasets
      all_datasets <- sdsanalysis::get_available_datasets()
      all_coordinates <- sdsanalysis::get_coords(all_datasets)
      all_sites <- sdsanalysis::get_site(all_datasets)
      all_datings <- sdsanalysis::get_dating(all_datasets)
      
      # prepare objects for leaflet map
      possible_colours <- c(
        "orange", "darkred", "purple", "blue", "red", "beige", "green", 
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
      
      # update progressbar
      shiny::incProgress(1, detail = "Preparing Map")
      
      # prepare leaflet map
      resmap <- leaflet::addLegend(
        leaflet::addAwesomeMarkers(
          leaflet::addProviderTiles(
            leaflet::leaflet(), 
            leaflet::providers$OpenStreetMap.HOT,
            options = leaflet::providerTileOptions(noWrap = TRUE)
          ),
          lng = all_coordinates$lon, 
          lat = all_coordinates$lat, 
          label = all_sites,
          icon = dating_icons
        ),
        labels = unique(all_datings),
        colors = levels(datings_factor)
      )
    
      # update progressbar
      shiny::incProgress(1, detail = "Ready")
      
    })
      
    return(resmap)
    
  })
  
  #### update map depending on selected dataset: blue circle ####
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
  
  #### current dataset download ####
  
  # raw download button
  output$raw_download_ui <- shiny::renderUI({
    shiny::downloadButton(
      ns("raw_download"), "Download current source dataset (.csv)",
      icon = shiny::icon("download"),
      class = "download_button"
    )
  })
  
  # decoded download button
  output$decoded_download_ui <- shiny::renderUI({
    shiny::downloadButton(
      ns("decoded_download"), "Download current decoded dataset (.csv)",
      icon = shiny::icon("download"),
      class = "download_button"
    )
  })
  
  # prepare raw download data
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
  
  # prepare decoded download data
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
  
  #### all data download ####
  
  # all data download button
  output$all_data_download_ui <- shiny::renderUI({
    shiny::downloadButton(
      ns("all_data_download"), "Download all data (.zip)",
      icon = shiny::icon("file-archive"),
      class = "download_button"
    )
  })
  
  # prepare all data download data
  output$all_data_download <- shiny::downloadHandler(
    filename = function() {
      "sds_data.zip"
    },
    content = function(file) {
      # download files
      urls_to_download <- sdsanalysis::get_all_sds_data_urls()
      download_directory <- file.path(tempdir(), "sdsdownloads")
      dir.create(download_directory)
      file_paths <- file.path(download_directory, basename(urls_to_download))
      utils::download.file(urls_to_download, file_paths)
      # prepare readme
      readme_path <- file.path(download_directory, "README.txt")
      writeLines(
        text = paste0(
          "If you want to use one of the data collections for your research, ",
          "you must abide by the terms of the the individual dataset's license ",
          "to be found on the Johanna Mestorf Academy Data Exchange Platform. ",
          "If no license is defined on the special download page, you'll have to ",
          "contact the dataset authors and ask for permission."
        ),
        con = readme_path
      )
      # put everything in a .zip archive
      utils::zip(
        zipfile = file,
        files = c(file_paths, readme_path),
        flags = "-r9Xj"
      )
    }
  )
  
  #### return dataset reactive to be passed to other modules ####
  return(current_dataset)
  
}
