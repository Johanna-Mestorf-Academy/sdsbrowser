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
        shinydashboard::menuItem("Introduction", tabName = "intro", icon = shiny::icon("mortar-board"), selected = TRUE,
          shinydashboard::menuSubItem("SDS", tabName = "subintro", icon = icon("angle-right")),
          shinydashboard::menuSubItem("Drafehn et al. 2008", tabName = "drafehn", icon = icon("angle-right")),
          shinydashboard::menuSubItem("Mennenga et al. 2013", tabName = "mennenga", icon = icon("angle-right"))
        ),
        shinydashboard::menuItem("Table", tabName = "table", icon= shiny::icon("table")),
        shinydashboard::menuItem("Plot", tabName = "plot", icon = shiny::icon("line-chart")),
        shiny::div(
          id = "sidebartext",
          shiny::HTML("<b>sdsbrowser</b> is a browser app to visualize data collected in the <b>SDS-System</b> (Systematische und digitale Erfassung
von Steinartefakten). <br><br> You can use it by selecting a dataset in the <b>Table</b> menu.")
        ),
        shinydashboard::menuItem("SDS-Meta", tabName = "meta", icon = shiny::icon("align-justify"))
      )
    )
    
    # body
    body <- shinydashboard::dashboardBody(
      
      # header
      shiny::tags$head(
        # include css
        shiny::includeCSS(system.file("style/sdsbrowser_stylesheet.css", package = "sdsbrowser"))
      ),
      
      # github ribbon
      shiny::HTML('
        <a href = "https://github.com/nevrome/sdsbrowser">
          <img style="position: absolute; top: 0; right: 0; border: 0; z-index:1000" 
               src="https://camo.githubusercontent.com/e7bbb0521b397edbd5fe43e7f760759336b5e05f/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f677265656e5f3030373230302e706e67" 
               alt="Fork me on GitHub" 
               data-canonical-src="https://s3.amazonaws.com/github/ribbons/forkme_right_green_007200.png">
        </a>  
      '),
      
      # intro
      shinydashboard::tabItems(
        shinydashboard::tabItem(
          tabName = "subintro",
          shiny::includeMarkdown("https://raw.githubusercontent.com/nevrome/sdsbrowser/master/README.md")
        ),
        shinydashboard::tabItem(
          tabName = "drafehn",
          tags$iframe(style = "height:900px; width:100%", src = "http://www.jna.uni-kiel.de/index.php/jna/article/view/25/25")
        ),
        shinydashboard::tabItem(
          tabName = "mennenga",
          tags$iframe(style = "height:900px; width:100%", src = "http://www.jna.uni-kiel.de/index.php/jna/article/view/94/101")
        )
      )
      
    )
    
    # put sidebar and body together
    shinydashboard::dashboardPage(
      shinydashboard::dashboardHeader(
        title = "sdsbrowser"
      ),
      sidebar,
      body,
      skin = "yellow"
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
