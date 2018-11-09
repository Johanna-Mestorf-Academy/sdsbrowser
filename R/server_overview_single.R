server_overview_single_data_preparation <- function(input, output, session, current_dataset) {

  ns <- session$ns
  
  #### data preparation ####
  sdsdata <- shiny::reactive({
    
    sdsdata <- current_dataset()$data
    
    # modification
    if ("erhaltung_gf" %in% names(sdsdata)) {
      sdsdata$modifiziert = ifelse(sdsdata$erhaltung_gf != "Nicht modiziert", "Modifiziert", sdsdata$erhaltung_gf)
    }
    
    # IGerM
    if ("index_geraete_modifikation" %in% names(sdsdata)) {
      sdsdata$igerm_cat <- sdsanalysis::lookup_IGerM_category(sdsdata$index_geraete_modifikation, subcategory = FALSE)
      for (i in 1:nrow(sdsdata)) {
        if (!(sdsdata$index_geraete_modifikation[i] %in% sdsanalysis::variable_values$attribute_name)) {
          sdsdata$index_geraete_modifikation[i] <- sdsdata$igerm_cat[i] <- "Sonstiges"
        }
      }
      sdsdata$igerm_cat <- factor(sdsdata$igerm_cat, levels = names(sort(table(sdsdata$igerm_cat))))
    }
    
    # GF
    if (all(c("gf_1", "gf_2") %in% names(sdsdata))) {
      sdsdata$gf_1 <- ifelse(is.na(sdsdata$gf_1), "Sonstiges", sdsdata$gf_1)
      sdsdata$gf_2 <- ifelse(is.na(sdsdata$gf_2), sdsdata$gf_1, sdsdata$gf_2)
      sdsdata$gf_1 <- factor(sdsdata$gf_1, levels = names(sort(table(sdsdata$gf_1))))
    }
    
    # artefact length histogram
    if (all(c("igerm_cat", "laenge") %in% names(sdsdata))) {
      sdsdata$igerm_cat_rev <- factor(sdsdata$igerm_cat, levels = rev(names(sort(table(sdsdata$igerm_cat)))))
      sdsdata$laenge_cm <- sdsdata$laenge / 10
    }
    
    sdsdata
    
  })
  
  return(sdsdata)
  
}
