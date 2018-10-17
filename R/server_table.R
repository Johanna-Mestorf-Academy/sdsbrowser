server_table <- function(input, output, session) {
  
  current_dataset <- shiny::callModule(server_load_data, id = "load_data")
  
  output$dataset_description <- shiny::renderText({
    current_dataset()$description
  })
  
  output$lineup1 <- lineupjs::renderLineup({
    lineupjs::lineup(
      current_dataset()$data,
      options = list(
        filterGlobally = TRUE, singleSelection = FALSE,
        noCriteriaLimits = FALSE, animated = TRUE, sidePanel = FALSE,
        hierarchyIndicator = FALSE, summaryHeader = TRUE, overviewMode = FALSE,
        expandLineOnHover = FALSE, defaultSlopeGraphMode = "item",
        ignoreUnsupportedBrowser = TRUE, 
        rowHeight = 20
      ),
      ranking = lineupjs::lineupRanking(
        columns = c("*")
      )
    )
  })
  
  return(current_dataset)
}
