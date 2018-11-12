server_overview <- function(input, output, session, current_dataset) {
  
  ns <- session$ns
  
  output$ui_overview <- shiny::renderUI({
    
    #### single artefacts ####
    if (current_dataset()$data_type == "single_artefacts") {
     
      # call relevant modules
      sdsdata <- shiny::callModule(server_overview_single_data_preparation, id = "overview_single_data_preparation", current_dataset()$data)
      output$proportion_mod_plot <- plotly::renderPlotly({
        shiny::callModule(server_overview_single_proportion_mod_plot, id = "overview_single_proportion_mod_plot", sdsdata)
      })
      output$IGerM_plot <- plotly::renderPlotly({
        shiny::callModule(server_overview_single_IGerM_plot, id = "overview_single_IGerM_plot", sdsdata)
      })
      output$GF_plot <- plotly::renderPlotly({
        shiny::callModule(server_overview_single_GF_plot, id = "overview_single_GF_plot", sdsdata)
      })
      output$size_classes_plot <- plotly::renderPlotly({
        shiny::callModule(server_overview_single_size_classes_plot, id = "overview_single_size_classes_plot", sdsdata)
      })
      output$length_plot <- plotly::renderPlotly({
        shiny::callModule(server_overview_single_length_plot, id = "overview_single_length_plot", sdsdata)
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

    #### multi artefacts ####
    } else if (current_dataset()$data_type == "multi_artefacts") {
      
      # call relevant modules
      output$proportion_burned_plot <- plotly::renderPlotly({
        shiny::callModule(server_overview_multi_proportion_burned_plot, id = "overview_multi_proportion_burned_plot", current_dataset)
      })
      output$proportion_natural_surface_plot <- plotly::renderPlotly({
        shiny::callModule(server_overview_multi_proportion_natural_surface_plot, id = "overview_multi_proportion_natural_surface_plot", current_dataset)
      })
      sdsdata <- shiny::callModule(
        server_overview_single_data_preparation, 
        id = "overview_single_data_preparation", 
        multi_to_single_data(current_dataset()$data)
      )
      output$IGerM_plot <- plotly::renderPlotly({
        shiny::callModule(server_overview_single_IGerM_plot, id = "overview_single_IGerM_plot", sdsdata)
      })
      output$GF_plot <- plotly::renderPlotly({
        shiny::callModule(server_overview_single_GF_plot, id = "overview_single_GF_plot", sdsdata)
      })
      output$size_classes_plot <- plotly::renderPlotly({
        shiny::callModule(server_overview_single_size_classes_plot, id = "overview_single_size_classes_plot", sdsdata)
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
