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
      label = "Y-axis variable",
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
      ) +
        ggplot2::ggtitle(paste(input$var1, " - ", input$var2)) +
        ggplot2::theme_bw() +
        ggplot2::theme(
          panel.background = ggplot2::element_rect(fill = "#ECF0F5", color = "black"),
          plot.background = ggplot2::element_rect(fill = "#ECF0F5", color = "black"),
          panel.grid.minor = ggplot2::element_line(colour = "darkgrey", size = 0.5),
          panel.grid.major = ggplot2::element_line(colour = "darkgrey", size = 1)
        )
    )
  })

  
}
