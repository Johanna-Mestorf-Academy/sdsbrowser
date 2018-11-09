server_overview_single_data_preparation <- function(input, output, session, current_dataset) {

  ns <- session$ns
  
  #### data preparation ####
  sdsdata <- shiny::reactive({
    
    sdsdata <- current_dataset()$data
    
    # modification
    if ("erhaltung_gf" %in% names(sdsdata)) {
      sdsdata$modifiziert = ifelse(sdsdata$erhaltung_gf != "Nicht modiziert", "Modifiziert", sdsdata$erhaltung_gf)
    }
    
    # IGerM
    if ("index_geraete_modifikation" %in% names(sdsdata)) {
      sdsdata$igerm_cat <- sdsanalysis::lookup_IGerM_category(sdsdata$index_geraete_modifikation, subcategory = FALSE)
      for (i in 1:nrow(sdsdata)) {
        if (!(sdsdata$index_geraete_modifikation[i] %in% sdsanalysis::variable_values$attribute_name)) {
          sdsdata$index_geraete_modifikation[i] <- sdsdata$igerm_cat[i] <- "Sonstiges"
        }
      }
      sdsdata$igerm_cat <- factor(sdsdata$igerm_cat, levels = names(sort(table(sdsdata$igerm_cat))))
    }
    
    # GF
    if (all(c("gf_1", "gf_2") %in% names(sdsdata))) {
      sdsdata$gf_1 <- ifelse(is.na(sdsdata$gf_1), "Sonstiges", sdsdata$gf_1)
      sdsdata$gf_2 <- ifelse(is.na(sdsdata$gf_2), sdsdata$gf_1, sdsdata$gf_2)
      sdsdata$gf_1 <- factor(sdsdata$gf_1, levels = names(sort(table(sdsdata$gf_1))))
    }
    
    # artefact length histogram
    if (all(c("igerm_cat", "laenge") %in% names(sdsdata))) {
      sdsdata$igerm_cat_rev <- factor(sdsdata$igerm_cat, levels = rev(names(sort(table(sdsdata$igerm_cat)))))
      sdsdata$laenge_cm <- sdsdata$laenge / 10
    }
    
    sdsdata
    
  })
  
  return(sdsdata)
  
}

server_overview_single_proportion_mod_plot <- function(input, output, session, sdsdata) {
  
  ns <- session$ns

  # stop if relevant variables are not available
  if (!all(c("modifiziert") %in% names(sdsdata()))) {
    stop("Dataset does not contain all relevant variables to prepare this plot.")
  }
  
  dat <- dplyr::summarise(
    dplyr::group_by_(
      sdsdata(), 
      "modifiziert"
    ),
    count = dplyr::n()
  )
  
  dat$modifiziert[is.na(dat$modifiziert)] <- "Nicht modifiziert"
  
  p <- plotly::layout(
    p = plotly::add_pie(
      p = plotly::plot_ly(
        dat,
        width = 320,
        height = 320
      ),
      labels = ~modifiziert, values = ~count,
      hole = 0.7
    ),
    xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
    yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
    showlegend = T,
    legend = list(orientation = 'h')
  )
  
  plotly::config(
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

