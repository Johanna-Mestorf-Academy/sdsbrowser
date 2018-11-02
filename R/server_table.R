server_table <- function(input, output, session) {
  
  # load load data module
  current_dataset <- shiny::callModule(server_load_data, id = "load_data")
  
  # prepare description HTML text output
  output$dataset_description <- shiny::renderUI({
    shiny::HTML(paste(current_dataset()$description, collapse = "<br><br>"))
  })
  
  # prepare table header HTML text output
  output$table_header <- shiny::renderUI({
    sentence <- paste("This Table only shows the first <b>1000</b> entries of the selected dataset.",
    "The following variables were removed because they lacked relevant information:")
    variables <- dplyr::setdiff(names(current_dataset()$data), names(table_dataset()))
    shiny::HTML(paste(sentence, "<i>", paste(variables, collapse = ", "), "</i>"))
  })
  
  # prepare table dataset
  table_dataset <- shiny::reactive({
    table_dataset <- current_dataset()$data
    
    # show only the first 1000
    if (nrow(table_dataset) > 1000) {
      table_dataset <- table_dataset[1:1000,]
    }
    
    # remove variables without any values
    table_dataset <- dplyr::select_if(
      table_dataset,
      .predicate = function(x) {!all(is.na(x))}
    )
    
    # transform character columns with less than 8 variants to factor to improve linup display
    table_dataset <- dplyr::mutate_if(
      table_dataset,
      .predicate = function(x) {!any(is.na(x)) & is.character(x) & length(unique(x)) > 1 & length(unique(x)) <= 8},
      .funs = as.factor
    )
    
    table_dataset
  })
  
  # prepare table
  output$lineup1 <- lineupjs::renderLineup({
    lineupjs::lineup(
      table_dataset(),
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
