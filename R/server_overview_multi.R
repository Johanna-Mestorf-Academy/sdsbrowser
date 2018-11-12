#### data preparation ####
server_overview_multi_data_preparation <- function(input, output, session, current_dataset) {
  
  ns <- session$ns
  
  sdsdata <- shiny::reactive({
    
    sdsdata <- current_dataset()$data
    
    sdsdata
    
  })
  
  return(sdsdata)
  
}
