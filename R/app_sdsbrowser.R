#' sdsbrowser app
#' 
#' @param run_app Boolean. Should the app be run (TRUE - Default) or a shiny app object be returned?
#' @param port Integer. The TCP port that the application should listen on. Default: 2779.
#' @param launch.browser If true, the system's default web browser will be launched automatically after the app is started. Default: FALSE.
#' @param ... Additional arguments are passed to \code{shiny::runApp}.
#' 
#' @export
sdsbrowser <- function(
  run_app = TRUE,
  port = 2779,
  launch.browser = FALSE,
  ...
) {
  
  #### ui ####
  ui <- function() {
    
    # sidebar menu
    sidebar <- shinydashboard::dashboardSidebar(
      shinydashboard::sidebarMenu(
        id = "tabs",
        shinydashboard::menuItem("Introduction", tabName = "intro", icon = shiny::icon("mortar-board"), selected = TRUE,
          shinydashboard::menuSubItem("SDS", tabName = "subintro", icon = shiny::icon("angle-right")),
          shinydashboard::menuSubItem("Drafehn et al. 2008", tabName = "drafehn", icon = shiny::icon("angle-right")),
          shinydashboard::menuSubItem("Mennenga et al. 2013", tabName = "mennenga", icon = shiny::icon("angle-right"))
        ),
        shiny::div(
          class = "sidebartext",
          shiny::HTML("<b>sdsbrowser</b> is a browser app to visualize data collected in the <b>SDS-System</b>.<br><br>You can start to use it by selecting a dataset in the <b>Table</b> menu.")
        ),
        shinydashboard::menuItem("Table", tabName = "table", icon= shiny::icon("table")),
        shinydashboard::menuItem("Plot", tabName = "plot", icon = shiny::icon("line-chart")),
        shinydashboard::menuItem("SDS-Metadata", tabName = "meta", icon = shiny::icon("align-justify")),
        shinydashboard::menuItem("FAQ", tabName = "meta", icon = shiny::icon("question")),
        shiny::div(
          class = "sidebarlogos",
          shiny::a(
            href = "https://www.jma.uni-kiel.de",
            target = "_blank",
            shiny::img(
              src = "https://www.jma.uni-kiel.de/en/material/copy_of_logo-johanna-mestorf-acadamy/@@images/2208ec47-d4d8-443c-bdb7-6ae788b6f6ee.jpeg", 
              class = "autoaugment",
              style = "display: block; margin-left: auto; margin-right: auto;",
              width = 100
            )
          )
        ),
        shinydashboard::menuItem("Contact", tabName = "meta", icon = shiny::icon("address-book"))
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
          shiny::tags$iframe(style = "height:90vh;; width:90%", src = "http://www.jna.uni-kiel.de/index.php/jna/article/view/25/25")
        ),
        shinydashboard::tabItem(
          tabName = "mennenga",
          shiny::tags$iframe(style = "height:90vh;; width:90%", src = "http://www.jna.uni-kiel.de/index.php/jna/article/view/94/101")
        ),
        shinydashboard::tabItem(
          tabName = "table",
          shiny::HTML("test1"),
          ui_table("table")
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
      skin = "purple"
    )
  }
  
  #### server ####
  server <- function(input, output, session) {
    
    shiny::callModule(server_table, id = "table")
    
  }
  
  app_object <- shiny::shinyApp(ui, server)
  
  #### run app ####
  if (run_app) {
    shiny::runApp(
      app_object,
      port = port,
      launch.browser = launch.browser,
      ...
    )
  } else {
    return(app_object)
  }
  
}
