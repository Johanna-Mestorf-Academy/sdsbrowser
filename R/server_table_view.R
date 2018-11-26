# server module function for the Tab: "Table View"

server_table_view <- function(input, output, session, current_dataset) {
  
  #### table header HTML text output ####
  output$table_header <- shiny::renderUI({
    variables <- dplyr::setdiff(names(current_dataset()$data), names(table_dataset()))
    shiny::HTML(
      "<details>",
        "<summary>", 
          "This Table only shows the first <b>1000</b> entries of the selected dataset.",
          "Unfold to see the variables that were omitted in this table because they lack relevant information.",
        "</summary>",
        "<p>", 
          "<i>", paste(variables, collapse = ", "), "</i>", 
        "</p>",
      "</details>"
    )
  })
  
  #### modifications for table data set ####
  table_dataset <- shiny::reactive({
    table_dataset <- current_dataset()$data
    
    # show only the first 1000 entries
    if (nrow(table_dataset) > 1000) {
      table_dataset <- table_dataset[1:1000,]
    }
    
    # remove variables without any values
    table_dataset <- dplyr::select_if(
      table_dataset,
      .predicate = function(x) {!all(is.na(x))}
    )
    
    # remove variables with only negative information
    table_dataset <- dplyr::select_if(
      table_dataset,
      .predicate = function(x) {length(unique(x)) != 1 | !all(grepl("kein|nicht", x, ignore.case = TRUE))}
    )
    
    # transform character columns with less than 8 variants to factor to improve linup display
    table_dataset <- dplyr::mutate_if(
      table_dataset,
      .predicate = function(x) {!any(is.na(x)) & is.character(x) & length(unique(x)) > 1 & length(unique(x)) <= 8},
      .funs = as.factor
    )
    
    table_dataset
  })
  
  #### prepare table ####
  output$lineup1 <- lineupjs::renderLineup({
    lineupjs::lineup(
      table_dataset(),
      options = list(
        # see ?lineupjs::lineup for settings documentation
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
