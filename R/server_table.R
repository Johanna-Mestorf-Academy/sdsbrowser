server_table <- function(input, output, session) {
  
  current_dataset <- shiny::callModule(server_load_data, id = "load_data")
  
  output$dataset_description <- shiny::renderUI({
    shiny::HTML(paste(current_dataset()$description, collapse = "<br><br>"))
  })
  
  output$lineup1 <- lineupjs::renderLineup({
    
    sdsdata <- current_dataset()$data
    
    # show only the first 500
    if (nrow(sdsdata) > 1000) {
      sdsdata <- sdsdata[1:1000,]
    }
    
    # remove variables without any values
    sdsdata <- dplyr::select_if(
      sdsdata,
      .predicate = function(x) {!all(is.na(x))}
    )
    
    # transform character columns with less than 8 variants to factor to improve linup display
    sdsdata <- dplyr::mutate_if(
      sdsdata,
      .predicate = function(x) {!any(is.na(x)) & is.character(x) & length(unique(x)) > 1 & length(unique(x)) <= 8},
      .funs = as.factor
    )
    
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
