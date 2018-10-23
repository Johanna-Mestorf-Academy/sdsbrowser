ui_overview <- function(id) {
  
  ns <- shiny::NS(id)
  
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
              title = "Amount of artefacts by IGerM (Indexgerätemodifikation nach Zimmermann)",
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
              title = "Size classes (Größenklassen nach Arnold 1981)",
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
  
}
