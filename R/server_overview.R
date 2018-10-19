server_overview <- function(input, output, session, current_dataset) {
  
  ns <- session$ns
  
  output$gf_plot <- plotly::renderPlotly({
    
    sdsdata <- dplyr::mutate(
      hu,
      igerm_cat = sdsanalysis::lookup_IGerM_category(hu$index_geraete_modifikation, subcategory = TRUE)
    )
    
    ggplot2::ggplot(sdsdata) +
      ggplot2::geom_bar(
        ggplot2::aes_string(x = "igerm_cat", fill = "index_geraete_modifikation")
      ) +
      ggplot2::scale_x_discrete(labels = function(x) stringr::str_wrap(x, width = 10)) +
      ggplot2::coord_flip() +
      theme_sds()
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
