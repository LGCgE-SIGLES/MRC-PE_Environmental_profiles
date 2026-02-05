# Package management with renv
# renv::init()
# renv::snapshot()
renv::restore() # Restores the project-specific versions of all R packages used in the RStudio project

library(openxlsx)
library(dplyr)
library(sf)

# This script harmonizes the NDVI municipal table with the IGN 2021 municipal framework used in MRC-PE.

# Import municipal boundaries (IGN 2021)
Communes <- st_read("1 Donnees brutes/Contour communes/Shape Communes.shp")

# Exclude Corsica (NDVI data are not available)
Communes <- Communes[!(Communes$INSEE_DEP %in% c('2A','2B')),]

# Work as a data.frame (no geometry required here)
Communes <- st_drop_geometry(Communes)

# Import NDVI dataset previously extracted
BdD_ndvi <- read.csv("3 Outputs/1 NDVI contour communes SPF/ndvi_ete_communes_2000_2018 - ville de Lyon gérée.csv", header=TRUE, sep=";",dec=",")

# Fix INSEE code formatting (leading zero may be dropped for codes starting with 01, 02, 03, etc.)
BdD_ndvi$INSEE_COM <- as.character(BdD_ndvi$INSEE_COM)

corriger_insee <- function(code) {
  if(nchar(code) == 4) {
    return(paste0("0", code))
  } else {
    return(code)
  }
}

BdD_ndvi$INSEE_COM <- sapply(BdD_ndvi$INSEE_COM, corriger_insee)

# Merge IGN 2021 municipal table with NDVI indicators
Communes_ndvi <- merge(Communes, BdD_ndvi[,c(1,4:ncol(BdD_ndvi))],by='INSEE_COM',all.x=TRUE)

# Export dataset aligned with MRC-PE municipal framework
write.xlsx(Communes_ndvi,"3 Outputs/2 NDVI contour communes MRC-PE/ndvi_ete_communes_2000_2018.xlsx")

