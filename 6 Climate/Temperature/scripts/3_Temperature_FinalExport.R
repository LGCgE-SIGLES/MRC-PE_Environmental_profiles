# Package management with renv
# renv::init()
# renv::snapshot()
renv::restore() # Restores the project-specific versions of all R packages used in the RStudio project

library(writexl)
library(dplyr)
library(sf)

# This script assembles the final municipal temperature dataset for MRC-PE
# by joining temperature indicators to the IGN 2021 municipal boundary layer
# and exporting both spatial and tabular outputs.

# Import municipal boundaries (IGN 2021)
Communes <- st_read("1 Donnees brutes/Contour communes 2021/Shape Communes 2021.sqlite")

# Import annual indicators (after Lyon-specific adjustment step)
DEPAS <- read.csv("3 Outputs/2 Après gestion Lyon/Depassement/Temperatures_depassements_annuels_communes.csv",header=TRUE,sep=";",dec=",")
QUANTI <- read.csv("3 Outputs/2 Après gestion Lyon/Quanti/Temperatures_moyennes_annuelles_communes.csv",header=TRUE,sep=";",dec=",")

DEPAS$INSEE_COM <- as.character(DEPAS$INSEE_COM)
QUANTI$INSEE_COM <- as.character(QUANTI$INSEE_COM)

# Fix INSEE code formatting (leading zero may be dropped for codes starting with 01, 02, 03, etc.)
corriger_insee <- function(code) {
  if(nchar(code) == 4) {
    return(paste0("0", code))
  } else {
    return(code)
  }
}

DEPAS$INSEE_COM <- sapply(DEPAS$INSEE_COM, corriger_insee)
QUANTI$INSEE_COM <- sapply(QUANTI$INSEE_COM, corriger_insee)

# Build complete dataset (spatial)
TEMPERATURE_SIG <- merge(Communes, QUANTI[,c(1,4:(ncol(QUANTI)-6))], by.x ='insee_com', by.y='INSEE_COM')

TEMPERATURE_SIG <- merge(TEMPERATURE_SIG, DEPAS[,c(1,4:(ncol(DEPAS)-3))], by.x ='insee_com', by.y='INSEE_COM')

TEMPERATURE_SIG <- merge(TEMPERATURE_SIG, QUANTI[,c(1,(ncol(QUANTI)-5):ncol(QUANTI))], by.x ='insee_com', by.y='INSEE_COM')

TEMPERATURE_SIG <- merge(TEMPERATURE_SIG, DEPAS[,c(1,(ncol(DEPAS)-2):ncol(DEPAS))], by.x ='insee_com', by.y='INSEE_COM')

# Tabular version (no geometry)
TEMPERATURE_TABLE <- st_drop_geometry(TEMPERATURE_SIG)

# Export final outputs
st_write(TEMPERATURE_SIG,"4 Résultat final/Temperature_2000_2018.sqlite")

write_xlsx(TEMPERATURE_TABLE,"4 Résultat final/Temperature_2000_2018.xlsx")

