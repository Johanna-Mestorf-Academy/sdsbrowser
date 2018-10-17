server_table <- function(input, output, session) {
  
  shiny::callModule(server_load_data, id = "load_data")
  
  current_dataset <- shiny::reactive({
    
    fb1 <- sdsanalysis::get_data("test_data")
  
    fb1_decoded <- sdsanalysis::lookup_everything(fb1, 1)
    
    hu <- dplyr::mutate_if(
      fb1_decoded,
      .predicate = function(x) {!any(is.na(x)) & is.character(x) & length(unique(x)) > 1 & length(unique(x)) <= 8},
      .funs = as.factor
    )

    hu
    
  })
  
  output$lineup1 <- lineupjs::renderLineup({
    lineupjs::lineup(
      current_dataset(),
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
