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
          shiny::HTML(paste0(
            "<b>sdsbrowser</b> is a browser app to visualize data collected in the <b>SDS-System</b>.",
            "<br><br>You can start to use it by selecting a dataset in the <b>Table</b> menu."
          ))
        ),
        shinydashboard::menuItem("Table", tabName = "table", icon= shiny::icon("table")),
        shiny::div(
          class = "sidebartext",
          shiny::HTML("The <b>Overview</b> menu presents the dataset with some predefined graphics.")
        ),
        shinydashboard::menuItem("Overview", tabName = "overview", icon = shiny::icon("image")),
        shiny::div(
          class = "sidebartext",
          shiny::HTML("The <b>Exploration</b> menu allows you to take a look at the variables relevant for you.")
        ),
        shinydashboard::menuItem("Exploration", tabName = "dynamic_plot", icon = shiny::icon("line-chart")),
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
        shinydashboard::menuItem("SDS-Metadata", tabName = "meta", icon = shiny::icon("align-justify")),
        shinydashboard::menuItem("FAQ", tabName = "meta", icon = shiny::icon("question")),
        shinydashboard::menuItem("Contact", tabName = "meta", icon = shiny::icon("address-book"))
      )
    )
    
    # body
    body <- shinydashboard::dashboardBody(
      
      # header
      shiny::tags$head(
        # include css
        shiny::includeCSS(system.file("style/sdsbrowser_stylesheet.css", package = "sdsbrowser")),
        shiny::includeCSS(system.file("style/lineupjs_stylesheet.css", package = "sdsbrowser"))
      ),
      
      # fork symbol
      shiny::a(
        href = "https://github.com/nevrome/sdsbrowser",
        shiny::div(
          class = "corner_symbol",
          shiny::icon("code-branch")
        )
      ),
      
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
          ui_table("table")
        ),
        shinydashboard::tabItem(
          tabName = "overview",
          ui_overview("overview")
        ),
        shinydashboard::tabItem(
          tabName = "dynamic_plot",
          ui_dynamic_plot("dynamic_plot")
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
    
    # load modules
    current_dataset <- shiny::callModule(server_table, id = "table")
    shiny::callModule(server_dynamic_plot, id = "dynamic_plot", "dynamic_plot", current_dataset)
    shiny::callModule(server_overview, id = "overview", current_dataset)
    
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
