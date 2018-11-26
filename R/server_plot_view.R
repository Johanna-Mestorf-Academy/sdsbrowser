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
      shiny::fluidPage(
        shiny::fluidRow(
          shiny::column(
            width = 9,
            shiny::fluidRow(
              shiny::column(
                width = 4,
                shinydashboard::box(
                  width = NULL,
                  title = "Proportion of modified artefacts",
                  plotly::plotlyOutput(
                    ns("proportion_mod_plot")
                  )
                )
              ),
              shiny::column(
                width = 8,
                shinydashboard::box(
                  width = NULL,
                  title = "Amount of artefacts by IGerM (Indexger\u00e4temodifikation nach Zimmermann)",
                  plotly::plotlyOutput(
                    ns("IGerM_plot")
                  )
                )
              )
            ),
            shiny::fluidRow(
              shiny::column(
                width = 8,
                shinydashboard::box(
                  width = NULL,
                  title = "Amount of artefacts by basic form (Grundform nach Drafehn 2004)",
                  plotly::plotlyOutput(
                    ns("GF_plot")
                  )
                )
              ),
              shiny::column(
                width = 4,
                shinydashboard::box(
                  width = NULL,
                  title = "Size classes (Gr\u00f6\u00dfenklassen nach Arnold 1981)",
                  plotly::plotlyOutput(
                    ns("size_classes_plot")
                  )
                )
              )
            )
          ),
          shiny::column(
            width = 3,
            shinydashboard::box(
              width = NULL,
              height = "947px",
              title = "Artefact length by IGerM (in cm)",
              plotly::plotlyOutput(
                ns("length_plot")
              )
            )
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
      shiny::fluidPage(
        shiny::fluidRow(
          shiny::column(
            width = 3,
            shinydashboard::box(
              width = NULL,
              title = "Proportion of burned artefacts",
              plotly::plotlyOutput(
                ns("proportion_burned_plot")
              )
            )
          ),
          shiny::column(
            width = 9,
            shinydashboard::box(
              width = NULL,
              title = "Amount of artefacts by IGerM (Indexger\u00e4temodifikation nach Zimmermann)",
              plotly::plotlyOutput(
                ns("IGerM_plot")
              )
            )
          )
        ),
        shiny::fluidRow(
          shiny::column(
            width = 3,
            shinydashboard::box(
              width = NULL,
              title = "Proportion of artefacts with natural surfaces",
              plotly::plotlyOutput(
                ns("proportion_natural_surface_plot")
              )
            )
          ),
          shiny::column(
            width = 5,
            shinydashboard::box(
              width = NULL,
              title = "Amount of artefacts by basic form (Grundform nach Drafehn 2004)",
              plotly::plotlyOutput(
                ns("GF_plot")
              )
            )
          ),
          shiny::column(
            width = 4,
            shinydashboard::box(
              width = NULL,
              title = "Size classes (Gr\u00f6\u00dfenklassen nach Arnold 1981)",
              plotly::plotlyOutput(
                ns("size_classes_plot")
              )
            )
          )
        )
      )
        
    } 
    
  })
  
}
