server_overview <- function(input, output, session, current_dataset) {
  
  ns <- session$ns
  
  output$gf_plot <- plotly::renderPlotly({
    plotly::plot_ly(data = datasets::iris, x = ~Sepal.Length, y = ~Petal.Length)
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
