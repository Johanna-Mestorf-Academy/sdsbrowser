server_table <- function(input, output, session) {
  
  #shiny::callModule(server_load_data, id = "table")
  
  current_dataset <- shiny::reactive({
    
    fb1 <- tibble::as.tibble(data.table::fread(
      "../sdsmeta/example_data/Kuesterberg_fb1_test.csv", 
      encoding = "Latin-1"
    ))
    
    sdsanalysis::lookup_everything(fb1, 1)
    
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
