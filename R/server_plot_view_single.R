# Additional functions/modules for the **single** data display of the Tab: "Plot View"

#### module: prepare dataset ####
server_plot_view_single_data_preparation <- function(input, output, session, current_dataset) {

  ns <- session$ns
  
  # this applies some changes to the currently loaded dataset and adds some additional variables
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
    }
    
    # GF
    if ("gf_1" %in% names(sdsdata)) {
      sdsdata$gf_1 <- ifelse(is.na(sdsdata$gf_1), "Sonstiges GF1", sdsdata$gf_1)
      sdsdata$gf_1 <- factor(sdsdata$gf_1, levels = names(sort(table(sdsdata$gf_1))))
    }
    if (all(c("gf_1", "gf_2") %in% names(sdsdata))) {
      sdsdata$gf_2 <- as.factor(ifelse(is.na(sdsdata$gf_2), "Sonstiges GF2", sdsdata$gf_2))
    }

    # size classes
    if ("groesse" %in% names(sdsdata)) {
      sdsdata$groesse <- forcats::fct_explicit_na(sdsdata$groesse, na_level = "Unbekannt")
    }
    
    # artefact length
    if (all(c("igerm_cat", "laenge") %in% names(sdsdata))) {
      sdsdata$laenge_cm <- sdsdata$laenge / 10
    }
    
    sdsdata
    
  })
  
  return(sdsdata)
  
}

#### module: plot proportion of modified artefacts ####
server_plot_view_single_proportion_mod_plot <- function(input, output, session, sdsdata) {
  
  ns <- session$ns

  # stop if relevant variables are not available
  check_for_relevant_columns(c(
    "modifiziert"
  ), sdsdata())

  # count modified artefacts
  dat <- dplyr::summarise(
    dplyr::group_by_(
      sdsdata(), 
      "modifiziert"
    ),
    count = dplyr::n()
  )
  
  # rename variables
  dat$modifiziert[is.na(dat$modifiziert)] <- "Nicht modifiziert"
  
  # prepare plot
  p <- plotly::layout(
    p = plotly::add_pie(
      p = plotly::plot_ly(
        dat
      ),
      labels = ~modifiziert, values = ~count,
      hole = 0.7,
      rotation = 45
    ),
    xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
    yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
    showlegend = T,
    legend = list(orientation = 'h'),
    title = "Proportion of modified artefacts",
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

#### module: plot IGerM ####
server_plot_view_single_IGerM_plot <- function(input, output, session, sdsdata) {
  
  ns <- session$ns
  
  dat <- sdsdata()
  
  # stop if relevant variables are not available
  check_for_relevant_columns(c(
    "igerm_cat", 
    "index_geraete_modifikation"
  ), sdsdata())
  
  # prepare plot
  p <- ggplot2::ggplot() +
    ggplot2::geom_bar(
      data = dat,
      mapping = ggplot2::aes_string(
        x = "igerm_cat", 
        fill = "index_geraete_modifikation"
      ),
      colour = "grey",
      size = 0.2
    ) +
    ggplot2::coord_flip() +
    theme_sds() +
    ggplot2::theme(
      axis.title.y = ggplot2::element_blank(),
      legend.title = ggplot2::element_blank()
    ) +
    ggplot2::ggtitle("Amount of artefacts by IGerM (Indexger\u00e4temodifikation nach Zimmermann)") + 
    ggplot2::theme(
      plot.title = ggplot2::element_text(size = 10),
      legend.position = "none"
    )
  
  # add colour scale
  if (length(unique(dat$index_geraete_modifikation)) <= 10) {
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

#### module: plot GF ####
server_plot_view_single_GF_plot <- function(input, output, session, sdsdata) {
  
  ns <- session$ns
  
  dat <- sdsdata()
  
  # stop if relevant variables are not available
  check_for_relevant_columns("gf_1", dat)
  
  # check if gf_2 is available: plot is different with gf_2
  gf2 <- "gf_2" %in% names(dat)
  
  # prepare plot 
  p <- ggplot2::ggplot(dat)
  
  if (gf2) {
    p <- p +
      ggplot2::geom_bar(
        ggplot2::aes_string(x = "gf_1", fill = "gf_2"),
        colour = "grey",
        size = 0.2
      )
  } else {
    p <- p +
      ggplot2::geom_bar(
        ggplot2::aes_string(x = "gf_1", fill = "gf_1"),
        size = 0.2
      )
  }
  
  p <- p + ggplot2::coord_flip() +
    theme_sds() +
    ggplot2::theme(
      axis.title.y = ggplot2::element_blank(),
      legend.title = ggplot2::element_blank()
    ) +
    ggplot2::ggtitle("Amount of artefacts by basic form (Grundform nach Drafehn 2004)") + 
    ggplot2::theme(
      plot.title = ggplot2::element_text(size = 10),
      legend.position = "none"
    )
  
  # add colour scale
  if (gf2) {
    if (length(unique(dat$gf_2)) <= 10) {
      p <- p + ggplot2::scale_fill_manual(
        values = d3.schemeCategory10()
      )
    }
  } else if (length(unique(dat$gf_1)) <= 10) {
    p <- p + ggplot2::scale_fill_manual(
      values = d3.schemeCategory10()
    )
  }
  
  # prepare ggplotly object
  if (gf2) {
    ggp <- plotly::ggplotly(p, tooltip = c("gf_2", "count"))
  } else {
    ggp <- plotly::ggplotly(p, tooltip = NA)
  }
  
  p <- plotly::config(
    p = ggp,
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

#### module: plot size classes ####
server_plot_view_single_size_classes_plot <- function(input, output, session, sdsdata) {
  
  ns <- session$ns
  
  dat <- sdsdata()
  
  # stop if relevant variables are not available
  check_for_relevant_columns(c(
    "groesse"
  ), dat)
  
  # prepare plot
  p <- ggplot2::ggplot(dat) +
    ggplot2::geom_bar(
      ggplot2::aes_string(x = "groesse", fill = "groesse")
    ) +
    theme_sds() +
    ggplot2::theme(
      axis.title.x = ggplot2::element_blank(),
      legend.title = ggplot2::element_blank()
    ) +
    ggplot2::scale_y_log10() +
    ggplot2::ggtitle("Size classes (Gr\u00f6\u00dfenklassen nach Arnold 1981)") + 
    ggplot2::theme(
      plot.title = ggplot2::element_text(size = 10),
      legend.position = "none"
    )
  
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

#### module: artefact length plot ####
server_plot_view_single_length_plot <- function(input, output, session, sdsdata) {
  
  ns <- session$ns
  
  dat <- sdsdata()
  
  # stop if relevant variables are not available
  check_for_relevant_columns(c(
    "laenge_cm", 
    "igerm_cat"
  ), sdsdata())
  
  # prepare plot
  p <- ggplot2::ggplot(dat) +
    ggplot2::geom_histogram(
      ggplot2::aes_string(x = "laenge_cm", fill = "igerm_cat"),
      binwidth = 1
    ) +
    ggplot2::facet_wrap(
      ~igerm_cat,
      ncol = length(unique(dat$igerm_cat)),
      strip.position = "top"
    ) +
    ggplot2::guides(
      fill = FALSE
    ) +
    ggplot2::ylab("count") +
    ggplot2::xlab("") +
    theme_sds() +
    ggplot2::theme(
      strip.background = ggplot2::element_blank()
    ) +
    ggplot2::scale_y_log10() +
    ggplot2::ggtitle("Artefact length by IGerM (in cm)") + 
    ggplot2::theme(plot.title = ggplot2::element_text(size = 10))
  
  # add colour scale
  if (length(unique(dat$igerm_cat)) <= 10) {
    p <- p + ggplot2::scale_fill_manual(
      values = d3.schemeCategory10()
    )
  }
  
  p <- plotly::layout(
    p = plotly::ggplotly(
      p = p,
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
