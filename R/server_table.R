server_table <- function(input, output, session) {
  
  current_dataset <- shiny::callModule(server_load_data, id = "load_data")
  
  output$dataset_description <- shiny::renderUI({
    shiny::HTML(paste(current_dataset()$description, collapse = "<br><br>"))
  })
  
  output$lineup1 <- lineupjs::renderLineup({
    sdsdata <- current_dataset()$data
    if (nrow(sdsdata) > 1000) {
      sdsdata <- sdsdata[1:1000,]
    }
    lineupjs::lineup(
      sdsdata,
      options = list(
        filterGlobally = TRUE, singleSelection = FALSE,
        noCriteriaLimits = FALSE, animated = FALSE, sidePanel = FALSE,
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
