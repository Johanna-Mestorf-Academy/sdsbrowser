#### data preparation ####
server_overview_multi_data_preparation <- function(input, output, session, current_dataset) {
  
  ns <- session$ns
  
  sdsdata <- shiny::reactive({
    
    sdsdata <- current_dataset()$data
    
    sdsdata
    
  })
  
  return(sdsdata)
  
}

#### Burning ####
server_overview_multi_proportion_burned_plot <- function(input, output, session, current_dataset) {
  
  ns <- session$ns
  
  sdsdata_multi <- current_dataset()$data
  
  # stop if relevant variables are not available
  if (
    !all(c(
      "sammel_anzahl_unverbrannt", 
      "sammel_anzahl_verbrannt", 
      "sammel_anzahl_unbekannt_ob_verbrannt"
    ) %in% names(sdsdata_multi))
    ) {
    stop("Dataset does not contain all relevant variables to prepare this plot.")
  }
  
  burned <- dplyr::select_(
    sdsdata_multi,
    "sammel_anzahl_unverbrannt", 
    "sammel_anzahl_verbrannt", 
    "sammel_anzahl_unbekannt_ob_verbrannt"
  )
  
  names(burned) <- c("unburned", "burned", "unknown")

  dat <- tibble::tibble(state = names(burned), count = colSums(burned))
  
  p <- plotly::layout(
    p = plotly::add_pie(
      p = plotly::plot_ly(
        dat,
        width = 320,
        height = 320
      ),
      labels = ~state, values = ~count,
      hole = 0.7
    ),
    xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
    yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
    showlegend = T,
    legend = list(orientation = 'h')
  )
  
  p <- plotly::config(
    p = p,
    # https://github.com/plotly/plotly.js/blob/master/src/plot_api/plot_config.js
    displaylogo = FALSE,
    collaborate = FALSE,
    # https://github.com/plotly/plotly.js/blob/master/src/components/modebar/buttons.js
    modeBarButtonsToRemove = list(
      'sendDataToCloud',
      'autoScale2d',
      'resetScale2d',
      'hoverClosestCartesian',
      'hoverCompareCartesian',
      'select2d',
      'lasso2d',
      'toggleSpikelines'
    )
  )
  
  return(p)
  
}

