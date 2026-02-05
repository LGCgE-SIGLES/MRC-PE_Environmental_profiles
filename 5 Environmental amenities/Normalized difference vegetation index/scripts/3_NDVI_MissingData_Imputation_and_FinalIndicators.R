# Package management with renv
# renv::init()
# renv::snapshot()
renv::restore() # Restores the project-specific versions of all R packages used in the RStudio project

library(openxlsx)
library(dplyr)
library(sf)

# This script imputes missing NDVI values (including anomalous placeholders)
# and produces the final 2000–2018 NDVI indicators for MRC-PE.

# Import municipal boundaries (IGN 2021)
Communes <- st_read("1 Donnees brutes/Contour communes/Shape Communes.shp")

# Exclude Corsica (NDVI data are not available)
Communes <- Communes[!(Communes$INSEE_DEP %in% c('2A','2B')),]

# Import NDVI dataset aligned to MRC-PE municipalities
BdD_ndvi <- read.csv("3 Outputs/2 NDVI contour communes MRC-PE/ndvi_ete_communes_2000_2018.csv", header=TRUE, sep=";",dec=",")

# Fix INSEE code formatting (leading zero may be dropped)
BdD_ndvi$INSEE_COM <- as.character(BdD_ndvi$INSEE_COM)

corriger_insee <- function(code) {
  if(nchar(code) == 4) {
    return(paste0("0", code))
  } else {
    return(code)
  }
}

BdD_ndvi$INSEE_COM <- sapply(BdD_ndvi$INSEE_COM, corriger_insee)

# Keep only indicator columns
BdD_ndvi <- BdD_ndvi[,c(1,17:ncol(BdD_ndvi))]

# Temporal imputation using adjacent years (N-1 and N+1)
MEAN_NDVI <- BdD_ndvi[c(1,2:20)]
ECART_MED.NDVI <- BdD_ndvi[,c(1,21:39)]

imputer_generique <- function(df, id_col, prefix_annee, annees = 2000:2018) {
  colonnes_annees <- paste0(prefix_annee, annees)
  
  if (!all(colonnes_annees %in% colnames(df))) {
    stop("Year columns are missing in the input DataFrame.")
  }
  
  for (i in seq_along(colonnes_annees)) {
    annee <- annees[i]
    
    for (j in 1:nrow(df)) {
      if (is.na(df[j, colonnes_annees[i]])) {
        if (annee == 2000) {
          df[j, colonnes_annees[i]] <- df[j, colonnes_annees[i + 1]]
        } else if (annee == 2018) {
          df[j, colonnes_annees[i]] <- df[j, colonnes_annees[i - 1]]
        } else {
          valeur_precedente <- df[j, colonnes_annees[i - 1]]
          valeur_suivante <- df[j, colonnes_annees[i + 1]]
          
          if (!is.na(valeur_precedente) & !is.na(valeur_suivante)) {
            df[j, colonnes_annees[i]] <- mean(c(valeur_precedente, valeur_suivante), na.rm = TRUE)
          } else if (!is.na(valeur_precedente)) {
            df[j, colonnes_annees[i]] <- valeur_precedente
          } else if (!is.na(valeur_suivante)) {
            df[j, colonnes_annees[i]] <- valeur_suivante
          }
        }
      }
    }
  }
  
  return(df)
}

MEAN_NDVI_impute <- imputer_generique(MEAN_NDVI, "INSEE_COM", "MEAN.NDVI_SUMMER_")
ECART_MED.NDVI_impute <- imputer_generique(ECART_MED.NDVI, "INSEE_COM", "ECART_MED.NDVI_SUMMER_")

# Recompute the binary indicator from imputed deviation values (< 0 => 1, else 0)
DEPAS_MED.NDVI_impute <- ECART_MED.NDVI_impute[, "INSEE_COM", drop = FALSE]

for (year in 2000:2018) {
  original_column <- paste0("ECART_MED.NDVI_SUMMER_", year)
  new_column <- paste0("DEPAS_MED.NDVI_SUMMER_", year)
  DEPAS_MED.NDVI_impute[[new_column]] <- ifelse(ECART_MED.NDVI_impute[[original_column]] < 0, 1, 0)
}

# Assemble final dataset and export
NDVI_MRCPE <- merge(MEAN_NDVI_impute,ECART_MED.NDVI_impute,by='INSEE_COM')
NDVI_MRCPE <- merge(NDVI_MRCPE,DEPAS_MED.NDVI_impute,by='INSEE_COM')

write.xlsx(NDVI_MRCPE,"3 Outputs/3 NDVI après gestion N.A/NDVI_2000_2018.xlsx")

Communes_NDVI <- merge(Communes, NDVI_MRCPE, by='INSEE_COM', all.x=TRUE)
st_write(Communes_NDVI,"3 Outputs/3 NDVI après gestion N.A/NDVI_2000_2018.sqlite")

