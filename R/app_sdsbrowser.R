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
