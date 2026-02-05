# Package management with renv
# renv::init()
# renv::snapshot()
renv::restore() # Restores the project-specific versions of all R packages used in the RStudio project

library(writexl)
library(dplyr)

# This script aggregates daily municipal temperature data into annual indicators (2000–2018).
# Two types of annual indicators are produced:
# - quantitative indicators: annual mean of daily temperatures and annual mean of deviations from reference values
# - exceedance indicators: annual counts of days exceeding climate reference values

# TEMPERATURES: quantitative parameters (TMEAN, TMAX, TMIN, ECART_TMEAN, ECART_TMAX, ECART_TMIN)

for (j in c(1:19,21:95)) {
  
  chemin_acces <- paste0 ("1 Donnees brutes/temp_jour_pr_valo/communes/",j,".rds")
  
  nom_dataframe_brut <- paste0("temp_communes_",j)
  
  nom_dataframe_final <- paste0("BdD_temp_communes_",j)
  
  # TEMPERATURE
  dataframe <-readRDS(chemin_acces)
  
  assign(nom_dataframe_brut, dataframe)
  
  
  BdD_communes <-as.data.frame(unique(get(nom_dataframe_brut)[,c('INSEE_COM','NOM_M','INSEE_DEP')]))
  
  annees_disponibles <- unique(get(nom_dataframe_brut)$ANNEE)
  
  assign(nom_dataframe_final, BdD_communes)
  
  
  for (i in annees_disponibles) {
    
    # Filter daily data for a given year
    df_jour_annee <- get(nom_dataframe_brut)[get(nom_dataframe_brut)$ANNEE==i, ]
    
    # Annual means by municipality
    df_annee <- aggregate(cbind(TMEAN, ECART_TMEAN, TMIN, ECART_TMIN, TMAX, ECART_TMAX) ~ INSEE_COM , data= df_jour_annee, mean)
    
    nom_colonne1 <- paste0("TMEAN_",i)
    nom_colonne2 <- paste0("ECART_TMEAN_",i)
    nom_colonne3 <- paste0("TMIN_",i)
    nom_colonne4 <- paste0("ECART_TMIN_",i)
    nom_colonne5 <- paste0("TMAX_",i)
    nom_colonne6 <- paste0("ECART_TMAX_",i)
    
    colnames(df_annee) <- c("INSEE_COM", nom_colonne1, nom_colonne2, nom_colonne3,nom_colonne4,nom_colonne5,nom_colonne6)
    
    temp_dataframe_final <- merge(get(nom_dataframe_final), df_annee, by = 'INSEE_COM')
    assign(nom_dataframe_final, temp_dataframe_final)
    
    
  }
  
  
}

# Concatenate all blocks into a single municipal table
BdD_communes_Temp_quantitatif <- BdD_temp_communes_1

for (i in c(2:19,21:95)){
  
  nom_dataframe <- paste0("BdD_temp_communes_", i)
  BdD_communes_Temp_quantitatif <-rbind(BdD_communes_Temp_quantitatif,get(nom_dataframe))
  
}

# Export annual quantitative indicators
write_xlsx(BdD_communes_Temp_quantitatif,"3 Outputs/Quanti/Temperatures_moyennes_annuelles_communes.xlsx")



# TEMPERATURES: exceedance indicators (DEPAS_TMEAN, DEPAS_TMIN, DEPAS_TMAX)
# Values correspond to annual counts of days where temperature exceeds the reference value.

for (j in c(1:19,21:95)) {
  
  chemin_acces <- paste0 ("1 Donnees brutes/temp_jour_pr_valo/communes/",j,".rds")
  
  nom_dataframe_brut <- paste0("temp_communes_",j)
  
  nom_dataframe_final <- paste0("BdD_temp_communes_",j)
  
  # TEMPERATURE
  dataframe <-readRDS(chemin_acces)
  
  assign(nom_dataframe_brut, dataframe)
  
  
  BdD_communes <-as.data.frame(unique(get(nom_dataframe_brut)[,c('INSEE_COM','NOM_M','INSEE_DEP')]))
  
  annees_disponibles <- unique(get(nom_dataframe_brut)$ANNEE)
  
  assign(nom_dataframe_final, BdD_communes)
  
  
  for (i in annees_disponibles) {
    
    # Filter daily data for a given year
    df_jour_annee <- get(nom_dataframe_brut)[get(nom_dataframe_brut)$ANNEE==i, ]
    
    # Annual sums by municipality (number of exceedance days)
    df_annee <- aggregate(cbind(DEPAS_TMEAN, DEPAS_TMIN, DEPAS_TMAX) ~ INSEE_COM , data= df_jour_annee, sum)
    
    nom_colonne1 <- paste0("DEPAS_TMEAN_",i)
    nom_colonne2 <- paste0("DEPAS_TMIN_",i)
    nom_colonne3 <- paste0("DEPAS_TMAX_",i)
    
    colnames(df_annee) <- c("INSEE_COM", nom_colonne1, nom_colonne2, nom_colonne3)
    
    temp_dataframe_final <- merge(get(nom_dataframe_final), df_annee, by = 'INSEE_COM')
    assign(nom_dataframe_final, temp_dataframe_final)
    
    
  }
  
  
}

# Concatenate all blocks into a single municipal table
BdD_communes_Temp_depassement <- BdD_temp_communes_1

for (i in c(2:19,21:95)){
  
  nom_dataframe <- paste0("BdD_temp_communes_", i)
  BdD_communes_Temp_depassement <-rbind(BdD_communes_Temp_depassement,get(nom_dataframe))
  
}

# Export annual exceedance indicators
write_xlsx(BdD_communes_Temp_depassement,"3 Outputs/Depassement/Temperatures_depassements_annuels_communes.xlsx")

