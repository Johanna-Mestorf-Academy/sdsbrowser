server_overview <- function(input, output, session, current_dataset) {
  
  ns <- session$ns
  
  data_type <- shiny::reactive({current_dataset()$data_type})
  
  output$ui_overview <- shiny::reactive({

    if (data_type() == "single_artefacts") {
      
      #### data preparation ####
      sdsdata <- shiny::callModule(server_overview_single_data_preparation, id = "overview_single_data_preparation", current_dataset)
      
      #### Modifications ####
      output$proportion_mod_plot <- plotly::renderPlotly({
        shiny::callModule(server_overview_single_proportion_mod_plot, id = "overview_single_proportion_mod_plot", sdsdata)
      })
      
      #### IGerM ####
      output$IGerM_plot <- plotly::renderPlotly({
        
        dat <- sdsdata()
        
        # stop if relevant variables are not available
        if (!all(c("igerm_cat_rev", "index_geraete_modifikation") %in% names(dat))) {
          stop("Dataset does not contain all relevant variables to prepare this plot.")
        }
        
        p <- ggplot2::ggplot() +
          ggplot2::geom_bar(
            data = dat,
            mapping = ggplot2::aes_string(
              x = "igerm_cat_rev", 
              fill = "igerm_cat_rev",
              group = "index_geraete_modifikation"
            ),
            colour = "grey",
            size = 0.2
          ) +
          ggplot2::coord_flip() +
          theme_sds() +
          ggplot2::theme(
            axis.title.y = ggplot2::element_blank(),
            legend.title = ggplot2::element_blank()
          )
        
        # add colour scale
        if (length(unique(dat$igerm_cat_rev)) <= 10) {
          p <- p + ggplot2::scale_fill_manual(
            values = d3.schemeCategory10()
          )
        }
        
        plotly::config(
          p = plotly::ggplotly(
            p,
            tooltip = c("index_geraete_modifikation", "count")
          ),
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
      
      #### GF ####
      output$gf_plot <- plotly::renderPlotly({
        
        dat <- sdsdata()
        
        # stop if relevant variables are not available
        if (!all(c("gf_1", "gf_2") %in% names(dat))) {
          stop("Dataset does not contain all relevant variables to prepare this plot.")
        }
        
        p <- ggplot2::ggplot(dat) +
          ggplot2::geom_bar(
            ggplot2::aes_string(x = "gf_1", fill = "gf_1", group = "gf_2"),
            colour = "grey",
            size = 0.2
          ) +
          ggplot2::coord_flip() +
          theme_sds() +
          ggplot2::theme(
            axis.title.y = ggplot2::element_blank(),
            legend.title = ggplot2::element_blank()
          )
        
        # add colour scale
        if (length(unique(dat$gf_2)) <= 10) {
          p <- p + ggplot2::scale_fill_manual(
            values = d3.schemeCategory10()
          )
        }
        
        plotly::config(
          p = plotly::ggplotly(
            p,
            tooltip = c("gf_2", "count")
          ),
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
      
      #### Size classes ####
      output$size_classes_plot <- plotly::renderPlotly({
        
        dat <- sdsdata()
        
        # stop if relevant variables are not available
        if (!all(c("groesse") %in% names(dat))) {
          stop("Dataset does not contain all relevant variables to prepare this plot.")
        }
        
        p <- ggplot2::ggplot(dat) +
          ggplot2::geom_bar(
            ggplot2::aes_string(x = "groesse", fill = "groesse")
          ) +
          theme_sds() +
          ggplot2::theme(
            axis.title.x = ggplot2::element_blank(),
            legend.title = ggplot2::element_blank()
          ) +
          ggplot2::scale_y_log10()
        
        # add colour scale
        if (length(unique(dat$groesse)) <= 10) {
          p <- p + ggplot2::scale_fill_manual(
            values = d3.schemeCategory10()
          )
        }
        
        plotly::config(
          p = plotly::ggplotly(
            p,
            tooltip = NA
          ),
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
      
      #### Artefact length histogram ####
      output$surface_plot <- plotly::renderPlotly({
        
        dat <- sdsdata()
        
        # stop if relevant variables are not available
        if (!all(c("laenge_cm", "igerm_cat_rev") %in% names(dat))) {
          stop("Dataset does not contain all relevant variables to prepare this plot.")
        }
        
        p <- ggplot2::ggplot(dat) +
          ggplot2::geom_histogram(
            ggplot2::aes_string(x = "laenge_cm", fill = "igerm_cat_rev"),
            binwidth = 1
          ) +
          ggplot2::facet_wrap(
            ~igerm_cat,
            nrow = length(unique(dat$igerm_cat)),
            strip.position = "top"
          ) +
          ggplot2::guides(
            fill = FALSE
          ) +
          ggplot2::ylab("") +
          ggplot2::xlab("") +
          theme_sds() +
          ggplot2::theme(
            strip.background = ggplot2::element_blank()
          ) +
          ggplot2::scale_y_log10()
        
        # add colour scale
        if (length(unique(dat$igerm_cat_rev)) <= 10) {
          p <- p + ggplot2::scale_fill_manual(
            values = d3.schemeCategory10()
          )
        }
        
        p <- plotly::layout(
          p = plotly::ggplotly(
            p = p,
            height = 890,
            tooltip = NA
          ),
          showlegend = F
        )
        
        plotly::config(
          p = p,
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
      
      #### ui output preparation ####
      output$ui_overview <- shiny::renderUI({
        
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
                      ns("gf_plot")
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
                  ns("surface_plot")
                )
              )
            )
          )
        )
        
      })
      
      
      
      
      
      
      
      
      
      
    } else if (data_type() == "multi_artefacts") {
      #ui_overview <- shiny::callModule(server_overview_multi, id = "overview", current_dataset)
      
      output$ui_overview <- shiny::renderUI({
        
        "test"
        
      })
      
    } 
    
  })

  
}
