# server module function for the Tab: "Exploration View"

server_exploration_view <- function(input, output, session, current_dataset) {
 
  ns <- session$ns
  
  #### render input elements to select variables for the plot ####
  # x
  output$var1_selection <- shiny::renderUI({
    shiny::selectInput(
      ns("var1"),
      label = shiny::HTML(paste(shiny::icon("arrows-alt-h"), "X-axis variable")),
      choices = colnames(current_dataset()$data),
      selected = "fundjahr"
    )
  })
  
  output$var1_complete_name <- shiny::renderText({
    get_variable_complete_name(input$var1)
  })
  
  # y
  output$var2_selection <- shiny::renderUI({
    shiny::selectInput(
      ns("var2"),
      label = shiny::HTML(paste(shiny::icon("arrows-alt-v"), "Y-axis variable")),
      choices = c(NA, colnames(current_dataset()$data)),
      selected = NA
    )
  })
  
  output$var2_complete_name <- shiny::renderText({
    get_variable_complete_name(input$var2)
  })
  
  # colour
  output$var3_selection <- shiny::renderUI({
    shiny::selectInput(
      ns("var3"),
      label = shiny::HTML(paste(shiny::icon("palette"), "Colour variable")),
      choices = c("none", colnames(current_dataset()$data)),
      selected = "none"
    )
  })
  
  output$var3_complete_name <- shiny::renderText({
    get_variable_complete_name(input$var3)
  })
  
  # size
  output$var4_selection <- shiny::renderUI({
    shiny::selectInput(
      ns("var4"),
      label = shiny::HTML(paste(shiny::icon("dot-circle"), "Size variable")),
      choices = c("none", colnames(current_dataset()$data)[sapply(current_dataset()$data, class) != "character"]),
      selected = "none"
    )
  })
  
  output$var4_complete_name <- shiny::renderText({
    get_variable_complete_name(input$var4)
  })
  
  #### prepare plot ####
  output$rendered_dynamic_plot <- plotly::renderPlotly({
    
    # wait for input to load
    shiny::req(
      input$var1,
      input$var2,
      input$var3,
      input$var4
    )
    
    # start to create plot
    p <- ggplot2::ggplot(current_dataset()$data) +
      ggplot2::ggtitle(paste(get_variable_complete_name(input$var1), " - ", get_variable_complete_name(input$var2))) +
      theme_sds()
    
    # add plotting code depending on inputs
    if (input$var3 == "none" & input$var4 == "none") {
      p <- p + ggplot2::geom_point(
        ggplot2::aes_string(
          x = input$var1,
          y = input$var2
        )
      )
    } else if (input$var3 != "none" & input$var4 == "none") {
      p <- p + ggplot2::geom_point(
        ggplot2::aes_string(
          x = input$var1,
          y = input$var2,
          colour = input$var3
        )
      )
    } else if (input$var3 == "none" & input$var4 != "none") {
      p <- p + ggplot2::geom_point(
        ggplot2::aes_string(
          x = input$var1,
          y = input$var2,
          size = input$var4
        )
      )
    } else if (input$var3 != "none" & input$var4 != "none") {
      p <- p + ggplot2::geom_point(
        ggplot2::aes_string(
          x = input$var1,
          y = input$var2,
          colour = input$var3,
          size = input$var4
        )
      )
    }
    
    # transform ggplot to plotly
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

  
}
