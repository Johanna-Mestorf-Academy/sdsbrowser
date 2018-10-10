server_table <- function(input, output, session) {
  
  shiny::callModule(server_load_data, id = "table")
  
  output$lineup1 <- lineupjs::renderLineup({
    lineupjs::lineup(
      datasets::mtcars, 
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
