server_dynamic_plot <- function(input, output, session, id, current_dataset) {
 
  ns <- shiny::NS(id)
  
  get_variable_complete_name <- function(short_name) {
    sdsanalysis::lookup_var_complete_names(short_name)
  }
  
  output$var1_selection <- shiny::renderUI({
    shiny::selectInput(
      ns("var1"),
      label = "X-axis variable",
      choices = colnames(current_dataset()),
      selected = "laenge"
    )
  })
  
  output$var1_complete_name <- shiny::renderText({
    get_variable_complete_name(input$var1)
  })
  
  output$var2_selection <- shiny::renderUI({
    shiny::selectInput(
      ns("var2"),
      label = "Y-axis variable",
      choices = colnames(current_dataset()),
      selected = "breite"
    )
  })

  output$var2_complete_name <- shiny::renderText({
    get_variable_complete_name(input$var2)
  })
  
  output$rendered_dynamic_plot <- plotly::renderPlotly({
    # wait for input to load
    shiny::req(
      input$var1,
      input$var2
    )
    # prepare plot
    plotly::ggplotly(
      ggplot2::ggplot(current_dataset()) +
        ggplot2::geom_point(
          ggplot2::aes_string(
            x = input$var1,
            y = input$var2
          )
        ) +
        ggplot2::ggtitle(paste(get_variable_complete_name(input$var1), " - ", get_variable_complete_name(input$var2))) +
        ggplot2::theme_bw() +
        ggplot2::theme(
          panel.background = ggplot2::element_rect(fill = "#ECF0F5", color = "black"),
          plot.background = ggplot2::element_rect(fill = "#ECF0F5", color = "black"),
          panel.grid.minor = ggplot2::element_line(colour = "darkgrey", size = 0.5),
          panel.grid.major = ggplot2::element_line(colour = "darkgrey", size = 1),
          axis.text.x = ggplot2::element_text(angle = 45, vjust = 1, hjust = 1), 
          axis.text.y = ggplot2::element_text(angle = 45, vjust = -1, hjust = 1.5)
        )
    )
  })

  
}
