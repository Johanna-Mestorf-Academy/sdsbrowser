server_dynamic_plot <- function(input, output, session, current_dataset) {
 
  output$rendered_dynamic_plot <- plotly::renderPlotly({
    plotly::ggplotly(
      sdsanalysis::dynamic_plot(
        current_dataset(),
        "fundjahr",
        "dicke"
      )
    )
  })
   
}