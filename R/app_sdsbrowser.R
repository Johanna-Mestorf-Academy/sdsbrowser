#' sdsbrowser app
#' 
#' @param run_app Boolean. Should the app be run (TRUE - Default) or a shiny app object be returned?
#' 
#' @export
sdsbrowser <- function(
  run_app = TRUE
) {
  
  #### ui ####
  ui <- function() {
    
    # sidebar menu
    sidebar <- shinydashboard::dashboardSidebar(
      shinydashboard::sidebarMenu(
        id = "tabs",
        shinydashboard::menuItem("Introduction", tabName = "intro", icon = shiny::icon("mortar-board"), selected = TRUE),
        shinydashboard::menuItem("Table", tabName = "table", icon= shiny::icon("table")),
        shinydashboard::menuItem("Plot", tabName = "plot", icon = shiny::icon("line-chart")),
        shinydashboard::menuItem("About", tabName = "about", icon = shiny::icon("question"))
      )
    )
    
    # body
    body <- shinydashboard::dashboardBody(
      
      # intro
      shinydashboard::tabItems(
        shinydashboard::tabItem(
          tabName = "intro"
        )
      )
      
    )
    
    # put sidebar and body together
    shinydashboard::dashboardPage(
      shinydashboard::dashboardHeader(title = "sdsbrowser"),
      sidebar,
      body
    )
  }
  
  #### server ####
  server <- function(input, output, session) {
    
  }
  
  app_object <- shiny::shinyApp(ui, server)
  
  #### run app ####
  if (run_app) {
    shiny::runApp(app_object)
  } else {
    return(app_object)
  }
  
}
