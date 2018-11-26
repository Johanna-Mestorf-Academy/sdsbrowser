#' sdsbrowser app
#' 
#' This function starts the sdsbrowser app with \code{shiny::runApp()}. Within this function the main user interface
#' is built and the different modules are loaded. All arguments are passed to \code{shiny::runApp()}, for \code{port}
#' and \code{launch.browser} there are defined defaults.
#' 
#' @param run_app Boolean. Should the app be run (TRUE - Default) or a shiny app object be returned?
#' @param port Integer. The TCP port that the application should listen on. Default: 2779.
#' @param launch.browser If true, the system's default web browser will be launched automatically after the app is
#' started. Default: FALSE.
#' @param ... Additional arguments are passed to \code{shiny::runApp}.
#' 
#' @examples 
#' 
#' \dontrun{
#' sdsbrowser::sdsbrowser()
#' }
#' 
#' @export
sdsbrowser <- function(
  run_app = TRUE,
  port = 3838,
  launch.browser = FALSE,
  ...
) {
  
  #### ui ####
  ui <- function() {
    
    sidebar <- shinydashboard::dashboardSidebar(
      
      # load shinyjs to enable more direct javascript configuration
      shinyjs::useShinyjs(),
      
      # construct sidebar menu: the main page structure
      shinydashboard::sidebarMenu(
        id = "tabs",
        
        # text
        shiny::div(
          class = "sidebartext",
          shiny::HTML("<b>sdsbrowser</b> is a browser app to visualize data collected in the <b>SDS-System</b>.")
        ),
        
        # tabs / menu items / pages
        shinydashboard::menuItem("Introduction", tabName = "intro_view", icon = shiny::icon("mortar-board")),
        shinydashboard::menuItem("Load Data", tabName = "load_data_view", icon = shiny::icon("upload")),
        shinydashboard::menuItem("Table View", tabName = "table_view", icon = shiny::icon("table")),
        shinydashboard::menuItem("Plot View", tabName = "plot_view", icon = shiny::icon("image")),
        shinydashboard::menuItem("Exploration View", tabName = "exploration_view", icon = shiny::icon("line-chart")),
        
        # text
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
        
        # JMA logo
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
    
    # construct page body: fill pages with life
    body <- shinydashboard::dashboardBody(
      
      # html page header
      shiny::tags$head(
        # stylesheet
        shiny::includeCSS(system.file("style/sdsbrowser_stylesheet.css", package = "sdsbrowser")),
        # favicon
        shiny::tags$link(
          rel = "shortcut icon", 
          href = "https://raw.githubusercontent.com/Johanna-Mestorf-Academy/sdsbrowser/master/inst/sds_logo/favicon/favicon.ico"
        )
      ),
      
      # fork symbol on the top right corner (link to github)
      shiny::a(
        href = "https://github.com/nevrome/sdsbrowser",
        shiny::div(
          class = "corner_symbol",
          shiny::icon("code-branch")
        )
      ),
      
      # call ui module functions to load uis of pages
      # shinydashboard::tabItems(
      #   shinydashboard::tabItem(
      #     tabName = "intro_view",
      #     HTML(
      #       "<div id = intro_page>", 
      #       shiny::includeMarkdown("https://raw.githubusercontent.com/nevrome/sdsbrowser/master/README.md"), 
      #       "</div>"
      #     )
      #   ),
        
      shinydashboard::tabItems(
        shinydashboard::tabItem(
          tabName = "intro_view",
          shiny::fluidPage(
            shiny::fluidRow(
              shiny::column(
                width = 8,
                shiny::includeMarkdown("https://raw.githubusercontent.com/nevrome/sdsbrowser/master/README.md")
              ),
              shiny::column(
                width = 4,
                shiny::HTML('<a class="twitter-timeline" data-tweet-limit="4" href="https://twitter.com/SFB1266?ref_src=twsrc%5Etfw">Tweets by SFB1266</a> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>')
              )
            )
          )
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
    
    # combine sidebar menu and body to create the page
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
    
    # load server modules for the individual pages
    # *server_load_data_view* produces a reactive data object *current_dataset* that is used by the other pages
    current_dataset <- shiny::callModule(server_load_data_view, id = "load_data_view")
    shiny::callModule(server_table_view, id = "table_view", current_dataset)
    shiny::callModule(server_plot_view, id = "plot_view", current_dataset)
    shiny::callModule(server_exploration_view, id = "exploration_view", current_dataset)

    # Control functionality of menu items depending on whether data is loaded or not
    dependend_views <- c("table_view", "plot_view", "exploration_view")
    purrr::walk(dependend_views, function(x) {
      shinyjs::addCssClass(selector = paste0("a[data-value='", x, "']"), class = "inactiveLink")
    })
    shiny::observeEvent(is.null(current_dataset()), {
      purrr::walk(dependend_views, function(x) {
        shinyjs::addCssClass(selector = paste0("a[data-value='", x, "']"), class = "inactiveLink")
      })
    })
    shiny::observeEvent(!is.null(current_dataset()), {
      purrr::walk(dependend_views, function(x) {
        shinyjs::removeCssClass(selector = paste0("a[data-value='", x, "']"), class = "inactiveLink")
      })
    })
    
  }
  
  
  
  #### combine server and ui to create a shinyapp object ####
  app_object <- shiny::shinyApp(ui, server)
  
  
  
  #### run app object ####
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
