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
        shiny::div(
          class = "sidebartext",
          shiny::HTML("<b>sdsbrowser</b> is a browser app to visualize data collected in the <b>SDS-System</b>.")
        ),
        shinydashboard::menuItem("Introduction", tabName = "intro_view", icon = shiny::icon("mortar-board")),
        shinydashboard::menuItem("Load Data", tabName = "load_data_view", icon = shiny::icon("upload")),
        shinydashboard::menuItem("Table View", tabName = "table_view", icon = shiny::icon("table")),
        shinydashboard::menuItem("Plot View", tabName = "plot_view", icon = shiny::icon("image")),
        shinydashboard::menuItem("Exploration View", tabName = "exploration_view", icon = shiny::icon("line-chart")),
        shiny::div(
          class = "sidebartext",
          shiny::HTML("In the <b>Load Data</b> tab you can select different publicly available SDS datasets.")
        ),
        shiny::div(
          class = "sidebartext",
          shiny::HTML("The <b>Table View</b> tab presents the selected dataset in a table.")
        ),
        shiny::div(
          class = "sidebartext",
          shiny::HTML("The <b>Plot View</b> tab contains some predefined graphics for the dataset.")
        ),
        shiny::div(
          class = "sidebartext",
          shiny::HTML("The <b>Exploration View</b> tab allows you to take a look at individual variables more closely.")
        ),
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
        )
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
          tabName = "intro_view",
          shiny::includeMarkdown("https://raw.githubusercontent.com/nevrome/sdsbrowser/master/README.md")
        ),
        shinydashboard::tabItem(
          tabName = "load_data_view",
          ui_load_data_view("load_data_view")
        ),
        shinydashboard::tabItem(
          tabName = "table_view",
          ui_table_view("table_view")
        ),
        shinydashboard::tabItem(
          tabName = "plot_view",
          ui_plot_view("plot_view")
        ),
        shinydashboard::tabItem(
          tabName = "exploration_view",
          ui_exploration_view("exploration_view")
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
    
    # load server modules
    current_dataset <- shiny::callModule(server_load_data_view, id = "load_data_view")
    shiny::callModule(server_table_view, id = "table_view", current_dataset)
    shiny::callModule(server_plot_view, id = "plot_view", current_dataset)
    shiny::callModule(server_exploration_view, id = "exploration_view", current_dataset)

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
