server_table <- function(input, output, session) {
  
  #shiny::callModule(server_load_data, id = "table")
  
  current_dataset <- reactive({
    
    fb1 <- tibble::as.tibble(data.table::fread(
      "../sdsmeta/example_data/Kuesterberg_fb1_test.csv", 
      encoding = "Latin-1"
    ))
    
    names(fb1) <- sdsanalysis::lookup_vars(names(fb1), 1)
    
    fb1_decoded <- purrr::map2_df(fb1, names(fb1), .f = sdsanalysis::lookup_attrs)
    
    # fb1_decoded <- dplyr::mutate_if(
    #   fb1_decoded,
    #   sapply(fb1_decoded, is.character),
    #   as.factor
    # )
    
    fb1_decoded <- dplyr::mutate_if(
      fb1_decoded,
      sapply(fb1_decoded, is.integer),
      as.numeric
    )
    
    fb1_decoded
    
  })
  
  output$lineup1 <- lineupjs::renderLineup({
    lineupjs::lineup(
      current_dataset(), 
      width = "100%",
      options = list(
        filterGlobally = TRUE, singleSelection = FALSE,
        noCriteriaLimits = FALSE, animated = TRUE, sidePanel = "collapsed",
        hierarchyIndicator = TRUE, summaryHeader = TRUE, overviewMode = FALSE,
        expandLineOnHover = FALSE, defaultSlopeGraphMode = "item",
        ignoreUnsupportedBrowser = TRUE
      )
    )
  })
  
}
