# ui module function for the Tab: "Exploration View"

ui_exploration_view <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::fluidPage(
    shiny::fluidRow(
      #### left column: navigation ####
      shiny::column(
        3,
        shinydashboard::box(
          width = 12,
          status = "primary",
          # title
          shiny::h4("Exploration tools"),
          shiny::HTML(
            "You can select the variables that should be displayed on the right."
          ),
          shiny::br(), shiny::br(),
          # variable selection
          shiny::uiOutput(ns("var1_selection")),
          shiny::textOutput(ns("var1_complete_name")),
          shiny::br(),
          shiny::uiOutput(ns("var2_selection")),
          shiny::textOutput(ns("var2_complete_name")),
          shiny::br(),
          shiny::uiOutput(ns("var3_selection")),
          shiny::textOutput(ns("var3_complete_name")),
          shiny::br(),
          shiny::uiOutput(ns("var4_selection")),
          shiny::textOutput(ns("var4_complete_name"))
        )
      ),
      #### right column: plot ####
      shiny::column(
        9,
        shinydashboard::box(
          width = 12,
          # dynamic plot
          shinycssloaders::withSpinner(plotly::plotlyOutput(
            ns("rendered_dynamic_plot"),
            width = "100%",
            height = "90vh"
          ))
        )
      )
    )
  )
}
