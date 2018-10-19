server_overview <- function(input, output, session, current_dataset) {
  
  ns <- session$ns
  
  output$gf_plot <- plotly::renderPlotly({
    
    sdsdata <- current_dataset()$data
    
    sdsdata <- dplyr::mutate(
      sdsdata,
      igerm_cat = sdsanalysis::lookup_IGerM_category(sdsdata$index_geraete_modifikation, subcategory = TRUE)
    )
    
    for (i in 1:nrow(sdsdata)) {
      if (!(sdsdata$index_geraete_modifikation[i] %in% sdsanalysis::variable_values$attribute_name)) {
        sdsdata$index_geraete_modifikation[i] <- sdsdata$igerm_cat[i] <- "Sontiges"
      }
    }
    
    ggplot2::ggplot(sdsdata) +
      ggplot2::geom_bar(
        ggplot2::aes_string(x = "igerm_cat", fill = "index_geraete_modifikation")
      ) +
      ggplot2::coord_flip() +
      theme_sds() +
      ggplot2::theme(axis.title.y = ggplot2::element_blank())
  })
  
  output$IGerM_plot <- plotly::renderPlotly({
    plotly::plot_ly(data = datasets::iris, x = ~Sepal.Length, y = ~Petal.Length)
  })
  
  output$proportion_mod_plot <- plotly::renderPlotly({
    plotly::plot_ly(data = datasets::iris, x = ~Sepal.Length, y = ~Petal.Length)
  })
  
  output$size_classes_plot <- plotly::renderPlotly({
    plotly::plot_ly(data = datasets::iris, x = ~Sepal.Length, y = ~Petal.Length)
  })
  
}
