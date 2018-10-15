server_dynamic_plot <- function(input, output, session, id, current_dataset) {
 
  ns <- shiny::NS(id)
  
  output$var1_selection <- shiny::renderUI({
    shiny::selectInput(
      ns("var1"),
      label = "X-axis variable",
      choices = colnames(current_dataset()),
      selected = "fundjahr"
    )
  })
  
  output$var2_selection <- shiny::renderUI({
    shiny::selectInput(
      ns("var2"),
      label = "X-axis variable",
      choices = colnames(current_dataset()),
      selected = "fundjahr"
    )
  })

  output$rendered_dynamic_plot <- plotly::renderPlotly({
    # wait for input to load
    shiny::req(
      input$var1,
      input$var2
    )
    # prepare plot
    plotly::ggplotly(
      sdsanalysis::dynamic_plot(
        current_dataset(),
        input$var1,
        input$var2
      )
    )
  })

  
}
