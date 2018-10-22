server_overview <- function(input, output, session, current_dataset) {
  
  ns <- session$ns
  
  #### data preparation ####
  sdsdata <- shiny::reactive({
    
    sdsdata <- current_dataset()$data
    
    # modification
    sdsdata$modifiziert = ifelse(sdsdata$erhaltung_gf != "Nicht modiziert", "Modifiziert", sdsdata$erhaltung_gf)
    
    # IGerM
    sdsdata$igerm_cat <- sdsanalysis::lookup_IGerM_category(sdsdata$index_geraete_modifikation, subcategory = TRUE)
    for (i in 1:nrow(sdsdata)) {
      if (!(sdsdata$index_geraete_modifikation[i] %in% sdsanalysis::variable_values$attribute_name)) {
        sdsdata$index_geraete_modifikation[i] <- sdsdata$igerm_cat[i] <- "Sonstiges"
      }
    }
    sdsdata$igerm_cat <- factor(sdsdata$igerm_cat, levels = names(sort(table(sdsdata$igerm_cat))))
    
    # GF
    sdsdata$gf_1 <- ifelse(is.na(sdsdata$gf_1), "Sonstiges", sdsdata$gf_1)
    sdsdata$gf_2 <- ifelse(is.na(sdsdata$gf_2), sdsdata$gf_1, sdsdata$gf_2)
    sdsdata$gf_1 <- factor(sdsdata$gf_1, levels = names(sort(table(sdsdata$gf_1))))
    
    # artefact length histogram
    sdsdata$igerm_cat_rev <- factor(sdsdata$igerm_cat, levels = rev(names(sort(table(sdsdata$igerm_cat)))))
    sdsdata$laenge_cm <- sdsdata$laenge / 10
    
    sdsdata
    
  })
  
  
  #### Modifications ####
  output$proportion_mod_plot <- plotly::renderPlotly({
    
    dat <- dplyr::summarise(
      dplyr::group_by_(
        sdsdata(), 
        "modifiziert"
      ),
      count = dplyr::n()
    )
    
    p <- plotly::layout(
      p = plotly::add_pie(
        p = plotly::plot_ly(dat),
        labels = ~modifiziert, values = ~count,
        hole = 0.7
      ),
      xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
      yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
      showlegend = F
    )
    
    plotly::config(
      p = plotly::ggplotly(p),
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
    
  })
  
  #### IGerM ####
  output$IGerM_plot <- plotly::renderPlotly({
    
    p <- ggplot2::ggplot(sdsdata()) +
      ggplot2::geom_bar(
        ggplot2::aes_string(x = "igerm_cat_rev", fill = "igerm_cat_rev", group = "index_geraete_modifikation")
      ) +
      ggplot2::coord_flip() +
      theme_sds() +
      ggplot2::theme(
        axis.title.y = ggplot2::element_blank(),
        legend.title = ggplot2::element_blank()
      ) +
      ggplot2::scale_fill_manual(
        values = d3.schemeCategory10()
      )
    
    plotly::config(
      p = plotly::ggplotly(p),
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
    
  })
  
  #### GF ####
  output$gf_plot <- plotly::renderPlotly({
    
    p <- ggplot2::ggplot(sdsdata()) +
      ggplot2::geom_bar(
        ggplot2::aes_string(x = "gf_1", fill = "gf_2")
      ) +
      ggplot2::coord_flip() +
      theme_sds() +
      ggplot2::theme(
        axis.title.y = ggplot2::element_blank(),
        legend.title = ggplot2::element_blank()
      ) +
      ggplot2::scale_fill_manual(
        values = d3.schemeCategory10()
      )
    
    plotly::config(
      p = plotly::ggplotly(p),
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
    
  })
  
  #### Size classes ####
  output$size_classes_plot <- plotly::renderPlotly({
    
    p <- ggplot2::ggplot(sdsdata()) +
      ggplot2::geom_bar(
        ggplot2::aes_string(x = "groesse", fill = "groesse")
      ) +
      theme_sds() +
      ggplot2::theme(
        axis.title.x = ggplot2::element_blank(),
        legend.title = ggplot2::element_blank()
      ) +
      ggplot2::scale_fill_manual(
        values = d3.schemeCategory10()
      )
    
    plotly::config(
      p = plotly::ggplotly(p),
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
    
  })
  
  #### Artefact length histogram ####
  output$surface_plot <- plotly::renderPlotly({
    
    p <- ggplot2::ggplot(sdsdata()) +
      ggplot2::geom_histogram(
        ggplot2::aes_string(x = "laenge_cm", fill = "igerm_cat_rev"),
        binwidth = 1
      ) +
      ggplot2::facet_wrap(
        ~igerm_cat,
        nrow = length(unique(sdsdata()$igerm_cat)),
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
      ggplot2::scale_fill_manual(
        values = d3.schemeCategory10()
      )
    
    p <- plotly::layout(
      p = plotly::ggplotly(
        p = p,
        height = 890
      ),
      showlegend = F
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
    
  })
  
}
