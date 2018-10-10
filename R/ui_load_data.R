ui_load_data <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::column(
    3,
    fileInput(
      "file1", "Choose CSV File",
      multiple = FALSE,
      accept = c(
        "text/csv",
        "text/comma-separated-values,text/plain",
        ".csv"
      )
    )
  )
  
}
