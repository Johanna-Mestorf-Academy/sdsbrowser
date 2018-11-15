#### data preparation ####
server_overview_single_data_preparation <- function(input, output, session, current_dataset) {

  ns <- session$ns
  
  sdsdata <- shiny::reactive({
    
    sdsdata <- current_dataset
    
    # modification
    if ("erhaltung_gf" %in% names(sdsdata)) {
      sdsdata$modifiziert = ifelse(sdsdata$erhaltung_gf != "Nicht modiziert", "Modifiziert", sdsdata$erhaltung_gf)
    }
    
    # IGerM
    if ("index_geraete_modifikation" %in% names(sdsdata)) {
      sdsdata$igerm_cat <- sdsanalysis::lookup_IGerM_category(sdsdata$index_geraete_modifikation, subcategory = FALSE)
      for (i in 1:nrow(sdsdata)) {
        if (!(sdsdata$index_geraete_modifikation[i] %in% sdsanalysis::get_variable_values_list()$attribute_name)) {
          sdsdata$index_geraete_modifikation[i] <- sdsdata$igerm_cat[i] <- "Sonstiges"
        }
      }
      sdsdata$igerm_cat <- factor(sdsdata$igerm_cat, levels = names(sort(table(sdsdata$igerm_cat))))
      sdsdata$igerm_cat_rev <- factor(sdsdata$igerm_cat, levels = rev(names(sort(table(sdsdata$igerm_cat)))))
    }
    
    # GF
    if ("gf_1" %in% names(sdsdata)) {
      sdsdata$gf_1 <- ifelse(is.na(sdsdata$gf_1), "Sonstiges", sdsdata$gf_1)
      sdsdata$gf_1 <- factor(sdsdata$gf_1, levels = names(sort(table(sdsdata$gf_1))))
    }
    if (!("gf_2" %in% names(sdsdata))) {
      sdsdata$gf_2 <- NA
    }
    if (all(c("gf_1", "gf_2") %in% names(sdsdata))) {
      sdsdata$gf_2 <- ifelse(is.na(sdsdata$gf_2), sdsdata$gf_1, sdsdata$gf_2)
    }
    
    # artefact length histogram
    if (all(c("igerm_cat_rev", "laenge") %in% names(sdsdata))) {
      sdsdata$laenge_cm <- sdsdata$laenge / 10
    }
    
    sdsdata
    
  })
  
  return(sdsdata)
  
}

#### Modifications ####
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

#### IGerM ####
server_overview_single_IGerM_plot <- function(input, output, session, sdsdata) {
  
  ns <- session$ns
  
  dat <- sdsdata()
  
  # stop if relevant variables are not available
  if (!all(c("igerm_cat_rev", "index_geraete_modifikation") %in% names(dat))) {
    stop("Dataset does not contain all relevant variables to prepare this plot.")
  }
  
  p <- ggplot2::ggplot() +
    ggplot2::geom_bar(
      data = dat,
      mapping = ggplot2::aes_string(
        x = "igerm_cat_rev", 
        fill = "igerm_cat_rev",
        group = "index_geraete_modifikation"
      ),
      colour = "grey",
      size = 0.2
    ) +
    ggplot2::coord_flip() +
    theme_sds() +
    ggplot2::theme(
      axis.title.y = ggplot2::element_blank(),
      legend.title = ggplot2::element_blank()
    )
  
  # add colour scale
  if (length(unique(dat$igerm_cat_rev)) <= 10) {
    p <- p + ggplot2::scale_fill_manual(
      values = d3.schemeCategory10()
    )
  }
  
  p <- plotly::config(
    p = plotly::ggplotly(
      p,
      tooltip = c("index_geraete_modifikation", "count")
    ),
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

#### GF ####
server_overview_single_GF_plot <- function(input, output, session, sdsdata) {
  
  ns <- session$ns
  
  dat <- sdsdata()
  
  # stop if relevant variables are not available
  if (!all(c("gf_1", "gf_2") %in% names(dat))) {
    stop("Dataset does not contain all relevant variables to prepare this plot.")
  }
  
  p <- ggplot2::ggplot(dat) +
    ggplot2::geom_bar(
      ggplot2::aes_string(x = "gf_1", fill = "gf_1", group = "gf_2"),
      colour = "grey",
      size = 0.2
    ) +
    ggplot2::coord_flip() +
    theme_sds() +
    ggplot2::theme(
      axis.title.y = ggplot2::element_blank(),
      legend.title = ggplot2::element_blank()
    )
  
  # add colour scale
  if (length(unique(dat$gf_2)) <= 10) {
    p <- p + ggplot2::scale_fill_manual(
      values = d3.schemeCategory10()
    )
  }
  
  p <- plotly::config(
    p = plotly::ggplotly(
      p,
      tooltip = c("gf_2", "count")
    ),
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

#### Size classes ####
server_overview_single_size_classes_plot <- function(input, output, session, sdsdata) {
  
  ns <- session$ns
  
  dat <- sdsdata()
  
  # stop if relevant variables are not available
  if (!all(c("groesse") %in% names(dat))) {
    stop("Dataset does not contain all relevant variables to prepare this plot.")
  }
  
  p <- ggplot2::ggplot(dat) +
    ggplot2::geom_bar(
      ggplot2::aes_string(x = "groesse", fill = "groesse")
    ) +
    theme_sds() +
    ggplot2::theme(
      axis.title.x = ggplot2::element_blank(),
      legend.title = ggplot2::element_blank()
    ) +
    ggplot2::scale_y_log10()
  
  # add colour scale
  if (length(unique(dat$groesse)) <= 10) {
    p <- p + ggplot2::scale_fill_manual(
      values = d3.schemeCategory10()
    )
  }
  
  p <- plotly::config(
    p = plotly::ggplotly(
      p,
      tooltip = NA
    ),
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

#### Artefact length histogram ####
server_overview_single_length_plot <- function(input, output, session, sdsdata) {
  
  ns <- session$ns
  
  dat <- sdsdata()
  
  # stop if relevant variables are not available
  if (!all(c("laenge_cm", "igerm_cat_rev") %in% names(dat))) {
    stop("Dataset does not contain all relevant variables to prepare this plot.")
  }
  
  p <- ggplot2::ggplot(dat) +
    ggplot2::geom_histogram(
      ggplot2::aes_string(x = "laenge_cm", fill = "igerm_cat_rev"),
      binwidth = 1
    ) +
    ggplot2::facet_wrap(
      ~igerm_cat,
      nrow = length(unique(dat$igerm_cat)),
      strip.position = "top"
    ) +
    ggplot2::guides(
      fill = FALSE
    ) +
    ggplot2::ylab("") +
    ggplot2::xlab("") +
    theme_sds() +
    ggplot2::theme(
      strip.background = ggplot2::element_blank()
    ) +
    ggplot2::scale_y_log10()
  
  # add colour scale
  if (length(unique(dat$igerm_cat_rev)) <= 10) {
    p <- p + ggplot2::scale_fill_manual(
      values = d3.schemeCategory10()
    )
  }
  
  p <- plotly::layout(
    p = plotly::ggplotly(
      p = p,
      height = 890,
      tooltip = NA
    ),
    showlegend = F
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


