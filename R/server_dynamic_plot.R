server_dynamic_plot <- function(input, output, session, id, current_dataset) {
 
  ns <- shiny::NS(id)
  
  output$dataset_intro <- shiny::renderText({
    current_dataset()$description
  })
  
  get_variable_complete_name <- function(short_name) {
    sdsanalysis::lookup_var_complete_names(short_name)
  }
  
  output$var1_selection <- shiny::renderUI({
    shiny::selectInput(
      ns("var1"),
      label = shiny::HTML(paste(shiny::icon("arrows-alt-h"), "X-axis variable")),
      choices = colnames(current_dataset()$data),
      selected = "laenge"
    )
  })
  
  output$var1_complete_name <- shiny::renderText({
    get_variable_complete_name(input$var1)
  })
  
  output$var2_selection <- shiny::renderUI({
    shiny::selectInput(
      ns("var2"),
      label = shiny::HTML(paste(shiny::icon("arrows-alt-v"), "Y-axis variable")),
      choices = c(NA, colnames(current_dataset()$data)),
      selected = "breite"
    )
  })
  
  output$var2_complete_name <- shiny::renderText({
    get_variable_complete_name(input$var2)
  })
  
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
  
  output$rendered_dynamic_plot <- plotly::renderPlotly({
    
    # wait for input to load
    shiny::req(
      input$var1,
      input$var2,
      input$var3,
      input$var4
    )
    
    # prepare plot
    p <- ggplot2::ggplot(current_dataset()$data) +
      ggplot2::ggtitle(paste(get_variable_complete_name(input$var1), " - ", get_variable_complete_name(input$var2))) +
      theme_sds()
    
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
    
    plotly::ggplotly(p)
  })

  
}
