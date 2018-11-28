# server module function for the Tab: "Plot View"

server_plot_view <- function(input, output, session, current_dataset) {
  
  ns <- session$ns
  
  # The ui is dynamically rendered in this server function. That's because it is differently structured
  # depending on the selected data type. Single artefact data (Einzelaufnahme) gets other plots than multi 
  # artefact data (Sammelaufnahme) -- although there is some overlap with plots that are relevant for both
  # types.
  output$ui_plot_view <- shiny::renderUI({
    
    #### single artefacts ####
    if (current_dataset()$data_type == "single_artefacts") {
     
      # module: prepare dataset
      sdsdata <- shiny::callModule(server_plot_view_single_data_preparation, id = "plot_view_single_data_preparation", current_dataset()$data)
      # module: plot proportion of modified artefacts
      output$proportion_mod_plot <- plotly::renderPlotly({
        shiny::callModule(server_plot_view_single_proportion_mod_plot, id = "plot_view_single_proportion_mod_plot", sdsdata)
      })
      # module: plot IGerM (Index Geraetemodifikation)
      output$IGerM_plot <- plotly::renderPlotly({
        shiny::callModule(server_plot_view_single_IGerM_plot, id = "plot_view_single_IGerM_plot", sdsdata)
      })
      # module: plot GF (Grundform)
      output$GF_plot <- plotly::renderPlotly({
        shiny::callModule(server_plot_view_single_GF_plot, id = "plot_view_single_GF_plot", sdsdata)
      })
      # module: plot size classes
      output$size_classes_plot <- plotly::renderPlotly({
        shiny::callModule(server_plot_view_single_size_classes_plot, id = "plot_view_single_size_classes_plot", sdsdata)
      })
      # module: artefact length plot
      output$length_plot <- plotly::renderPlotly({
        shiny::callModule(server_plot_view_single_length_plot, id = "plot_view_single_length_plot", sdsdata)
      })
      
      # ui output preparation
      shinydashboard::box(
        width = 12,
        shiny::flowLayout(
          cellArgs = list(
            style = "
            min-width: 300px; 
            width: auto; 
            height: auto; 
            border: 1px solid darkgray; 
            padding: 10px;
            margin: 10px;
          "),
          plotly::plotlyOutput(
            width = "500px",
            ns("proportion_mod_plot")
          ),
          plotly::plotlyOutput(
            width = "500px",
            ns("size_classes_plot")
          ),
          plotly::plotlyOutput(
            width = "1045px",
            ns("IGerM_plot")
          ),
          plotly::plotlyOutput(
            width = "1045px",
            ns("GF_plot")
          ),
          plotly::plotlyOutput(
            width = "1045px",
            ns("length_plot")
          )
        )
      )

    ################################################################################  
      
    #### multi artefacts ####
    } else if (current_dataset()$data_type == "multi_artefacts") {
      
      # module: plot proportion burned artefacts
      output$proportion_burned_plot <- plotly::renderPlotly({
        shiny::callModule(server_plot_view_multi_proportion_burned_plot, id = "plot_view_multi_proportion_burned_plot", current_dataset)
      })
      # module: plot proportion artefacts natural surfaces
      output$proportion_natural_surface_plot <- plotly::renderPlotly({
        shiny::callModule(server_plot_view_multi_proportion_natural_surface_plot, id = "plot_view_multi_proportion_natural_surface_plot", current_dataset)
      })
      # module: modify data and automatically transform structure from multi to single
      sdsdata <- shiny::callModule(
        server_plot_view_single_data_preparation, 
        id = "plot_view_single_data_preparation", 
        multi_to_single_data(current_dataset()$data)
      )
      # module: plot IGerM (Index Geraetemodifikation)
      output$IGerM_plot <- plotly::renderPlotly({
        shiny::callModule(server_plot_view_single_IGerM_plot, id = "plot_view_single_IGerM_plot", sdsdata)
      })
      # module: plot GF (Grundform)
      output$GF_plot <- plotly::renderPlotly({
        shiny::callModule(server_plot_view_single_GF_plot, id = "plot_view_single_GF_plot", sdsdata)
      })
      # module: plot size classes
      output$size_classes_plot <- plotly::renderPlotly({
        shiny::callModule(server_plot_view_single_size_classes_plot, id = "plot_view_single_size_classes_plot", sdsdata)
      })
      
      # ui output preparation
      shinydashboard::box(
        width = 12,
        shiny::flowLayout(
          cellArgs = list(
            style = "
            min-width: 300px; 
            width: auto; 
            height: auto; 
            border: 1px solid darkgray; 
            padding: 10px;
            margin: 10px;
          "),
          plotly::plotlyOutput(
            width = "500px",
            ns("proportion_burned_plot")
          ),
          plotly::plotlyOutput(
            width = "500px",
            ns("proportion_natural_surface_plot")
          ),
          plotly::plotlyOutput(
            width = "500px",
            ns("size_classes_plot")
          ),
          plotly::plotlyOutput(
            width = "1045px",
            ns("IGerM_plot")
          ),
          plotly::plotlyOutput(
            width = "1045px",
            ns("GF_plot")
          )
        )
      )
        
    } 
    
  })
  
}
