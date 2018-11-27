# get the complete SDS name of a variable if you have the short name
get_variable_complete_name <- function(short_name) {
  sdsanalysis::lookup_var_complete_names(short_name)
}

# data availability validiation
check_for_relevant_columns <- function(x, data){
  shiny::validate(shiny::need(
    all(x %in% names(data)),
    "Dataset does not contain all relevant variables to prepare this plot."
  ))
}
