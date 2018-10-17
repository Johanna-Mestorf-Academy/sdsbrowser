server_load_data <- function(input, output, session) {
  
  current_dataset <- shiny::reactive({
    
    fb1 <- sdsanalysis::get_data("test_data")
    
    fb1_decoded <- sdsanalysis::lookup_everything(fb1, 1)
    
    hu <- dplyr::mutate_if(
      fb1_decoded,
      .predicate = function(x) {!any(is.na(x)) & is.character(x) & length(unique(x)) > 1 & length(unique(x)) <= 8},
      .funs = as.factor
    )
    
    hu
    
    list(
      data = hu,
      description = sdsanalysis::get_description_HTML("test_data")
    )
    
  })
  
  return(current_dataset)
  
}
