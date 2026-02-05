# Package management with renv
# renv::init()
# renv::snapshot()
renv::restore() # Restores the project-specific versions of all R packages used in the RStudio project

library(writexl)
library(dplyr)

# This script extracts annual summer NDVI indicators from multiple municipal RDS files
# and assembles them into a single municipal table covering 2000–2018.

for (j in c(1:19,21:95)) {
  
  chemin_acces <- paste0 ("1 Donnees brutes/ndvi_pr_valo/communes/",j,".rds")
  
  nom_dataframe_brut <- paste0("ndvi_communes_",j)
  
  nom_dataframe_final <- paste0("BdD_ndvi_communes_",j)
  
  # NDVI
  dataframe <-readRDS(chemin_acces)
  
  assign(nom_dataframe_brut, dataframe)
  
  
  BdD_communes <-as.data.frame(unique(get(nom_dataframe_brut)[,c('INSEE_COM','NOM_M','INSEE_DEP')]))
  
  annees_disponibles <- unique(get(nom_dataframe_brut)$ANNEE)
  
  assign(nom_dataframe_final, BdD_communes)
  
  
  for (i in annees_disponibles) {
    
    # Filter by year
    df_annee <- get(nom_dataframe_brut)[get(nom_dataframe_brut)$ANNEE==i, c(2,8,12,13)]
    
    nom_colonne1 <- paste0("MEAN.NDVI_SUMMER_",i)
    nom_colonne2 <- paste0("DEPAS_MED.NDVI_SUMMER_",i)
    nom_colonne3 <- paste0("ECART_MED.NDVI_SUMMER_",i)
    
    colnames(df_annee) <- c("INSEE_COM", nom_colonne1, nom_colonne2, nom_colonne3)
    
    ndvi_dataframe_final <- merge(get(nom_dataframe_final), df_annee, by = 'INSEE_COM')
    assign(nom_dataframe_final, ndvi_dataframe_final)
    
    rm(df_annee)
    
  }
  
  
}

# Concatenate all municipal blocks into a single table
BdD_communes_ndvi <- BdD_ndvi_communes_1

for (i in c(2:19,21:95)){
  
  nom_dataframe <- paste0("BdD_ndvi_communes_", i)
  BdD_communes_ndvi <-rbind(BdD_communes_ndvi,get(nom_dataframe))
  
}

# Export consolidated table (SPF municipal boundary framework)
write_xlsx(BdD_communes_ndvi,"3 Outputs/1 NDVI contour communes SPF/ndvi_ete_communes_2000_2018 - contour SPF.xlsx")

