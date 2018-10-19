server_overview <- function(input, output, session, current_dataset) {
  
  ns <- session$ns
  
  #### GF ####
  output$gf_plot <- plotly::renderPlotly({
    
    sdsdata <- current_dataset()$data
    
    p <- sdsdata %>%
      dplyr::group_by(gf_1) %>%
      dplyr::summarize(count = n()) %>%
      plotly::plot_ly(labels = ~gf_1, values = ~count) %>%
      plotly::add_pie(hole = 0.6) %>%
      plotly::layout(
        xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE)
      )
    
    p
    
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
