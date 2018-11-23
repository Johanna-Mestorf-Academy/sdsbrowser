# get the complete SDS name of a variable if you have the short name
get_variable_complete_name <- function(short_name) {
  sdsanalysis::lookup_var_complete_names(short_name)
}

