server_overview <- function(input, output, session, current_dataset) {
  
  ns <- session$ns
  
  #### GF ####
  output$gf_plot <- plotly::renderPlotly({
    
    sdsdata <- current_dataset()$data
    
    sdsdata %<>%
      dplyr::mutate(
        gf_1 = ifelse(is.na(gf_1), "Sonstiges", gf_1),
        gf_2 = ifelse(is.na(gf_2), gf_1, gf_2)
      )
    
    sdsdata$gf_1 <- factor(sdsdata$gf_1, levels = names(sort(table(sdsdata$gf_1))))
    
    p <- ggplot2::ggplot(sdsdata) +
      ggplot2::geom_bar(
        ggplot2::aes_string(x = "gf_1", fill = "gf_2")
      ) +
      ggplot2::coord_flip() +
      theme_sds() +
      ggplot2::theme(
        axis.title.y = ggplot2::element_blank(),
        legend.title = ggplot2::element_blank()
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
    
    sdsdata <- current_dataset()$data
    
    sdsdata <- dplyr::mutate(
      sdsdata,
      igerm_cat = sdsanalysis::lookup_IGerM_category(sdsdata$index_geraete_modifikation, subcategory = TRUE)
    )
    
    for (i in 1:nrow(sdsdata)) {
      if (!(sdsdata$index_geraete_modifikation[i] %in% sdsanalysis::variable_values$attribute_name)) {
        sdsdata$index_geraete_modifikation[i] <- sdsdata$igerm_cat[i] <- "Sonstiges"
      }
    }
    
    sdsdata$igerm_cat <- factor(sdsdata$igerm_cat, levels = names(sort(table(sdsdata$igerm_cat))))
    
    p <- ggplot2::ggplot(sdsdata) +
      ggplot2::geom_bar(
        ggplot2::aes_string(x = "igerm_cat", fill = "index_geraete_modifikation")
      ) +
      ggplot2::coord_flip() +
      theme_sds() +
      ggplot2::theme(
        axis.title.y = ggplot2::element_blank(),
        legend.title = ggplot2::element_blank()
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
  
  #### Modifications ####
  output$proportion_mod_plot <- plotly::renderPlotly({
  })
  
  #### Size classes ####
  output$size_classes_plot <- plotly::renderPlotly({
  })
  
}
