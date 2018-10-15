ui_dynamic_plot <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::fluidPage(
    shiny::fluidRow(
      shiny::column(
        3,
        shiny::selectInput(
          ns("var1"),
          label = "X-axis variable",
          choices = c("dicke", "laenge", "fundjahr"),
          selected = "dicke"
        )
      ),
      shiny::column(
        3,
        shiny::selectInput(
          ns("var2"),
          label = "Y-axis variable",
          choices = c("dicke", "laenge", "fundjahr"),
          selected = "laenge"
        )
      )
    ),
    shiny::fluidRow(
      plotly::plotlyOutput(
        ns("rendered_dynamic_plot")
      )
    )
  )
  

  

  
}