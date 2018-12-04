# Additional functions/modules for the **multi** data display of the Tab: "Plot View"

#### function: transform multi sds data to single sds data ####
multi_to_single_data <- function(current_dataset) {
  
  sdsdata_multi <- current_dataset
  
  # replace NA and 0 with 1 in count column to avoid errors with wrong data
  sdsdata_multi$sammel_anzahl_artefakte[is.na(sdsdata_multi$sammel_anzahl_artefakte) ] <- 1
  sdsdata_multi$sammel_anzahl_artefakte[sdsdata_multi$sammel_anzahl_artefakte == 0] <- 1
  
  # transform wide to long data format
  sdsdata <- sdsdata_multi[rep(row.names(sdsdata_multi), sdsdata_multi$sammel_anzahl_artefakte),]
    
  return(sdsdata)
  
}

#### module: plot proportion burned artefacts ####
server_plot_view_multi_proportion_burned_plot <- function(input, output, session, current_dataset) {
  
  ns <- session$ns
  
  sdsdata_multi <- current_dataset()$data
  
  # stop if relevant variables are not available
  check_for_relevant_columns(c(
    "sammel_anzahl_unverbrannt", 
    "sammel_anzahl_verbrannt", 
    "sammel_anzahl_unbekannt_ob_verbrannt"
  ), sdsdata_multi)
  
  # reduce dataset to relevant variables
  burned <- dplyr::select_(
    sdsdata_multi,
    "sammel_anzahl_verbrannt", 
    "sammel_anzahl_unverbrannt",
    "sammel_anzahl_unbekannt_ob_verbrannt"
  )
  
  # simplify variable names
  names(burned) <- c("Verbrannt", "Unverbrannt", "Unbekannt")

  # replace missing values in bad data with 0
  burned <- replace(burned, is.na(burned), 0)
  
  # create plotable representation of proportions
  dat <- tibble::tibble(state = names(burned), count = colSums(burned))
  
  # prepare plot
  p <- plotly::layout(
    p = plotly::add_pie(
      p = plotly::plot_ly(
        dat
      ),
      labels = ~state, values = ~count,
      hole = 0.7
    ),
    xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
    yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
    showlegend = T,
    legend = list(orientation = 'h'),
    title = "Proportion of burned artefacts",
    titlefont = list(size = 14)
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

#### module: plot proportion artefacts natural surfaces ####
server_plot_view_multi_proportion_natural_surface_plot <- function(input, output, session, current_dataset) {
  
  ns <- session$ns
  
  sdsdata_multi <- current_dataset()$data
  
  # stop if relevant variables are not available
  check_for_relevant_columns(c(
    "sammel_anzahl_ohne_naturflaeche",
    "sammel_anzahl_kleinereindrittel_naturflaeche",
    "sammel_anzahl_kleinerzweidrittel_naturflaeche",
    "sammel_anzahl_groesserzweidrittel_naturflaeche",
    "sammel_anzahl_voll_naturflaeche",
    "sammel_anzahl_unbekannt_naturflaeche"
  ), sdsdata_multi)

  # reduce dataset to relevant variables
  natural_surface <- dplyr::select_(
    sdsdata_multi,
    "sammel_anzahl_ohne_naturflaeche",
    "sammel_anzahl_kleinereindrittel_naturflaeche",
    "sammel_anzahl_kleinerzweidrittel_naturflaeche",
    "sammel_anzahl_groesserzweidrittel_naturflaeche",
    "sammel_anzahl_voll_naturflaeche",
    "sammel_anzahl_unbekannt_naturflaeche"
  )
  
  # simplify variable names
  names(natural_surface) <- c(
    "Ohne Naturfl\u00E4che", 
    "< 1/3 Naturfl\u00E4che", 
    "< 2/3 Naturfl\u00E4che",
    "> 2/3 Naturfl\u00E4che",
    "Voll Naturfl\u00E4che",
    "Unbekannt"
  ) 
  
  # replace missing values in bad data with NA
  natural_surface <- replace(natural_surface, is.na(natural_surface), 0)
  
  # create plotable representation of proportions
  dat <- tibble::tibble(state = names(natural_surface), count = colSums(natural_surface))

  # prepare plot  
  p <- plotly::layout(
    p = plotly::add_pie(
      p = plotly::plot_ly(
        dat
      ),
      labels = ~state, 
      sort = FALSE,
      values = ~count,
      hole = 0.7
    ),
    xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
    yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
    showlegend = T,
    legend = list(orientation = 'h'),
    title = "Proportion of artefacts with natural surfaces",
    titlefont = list(size = 14)
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
