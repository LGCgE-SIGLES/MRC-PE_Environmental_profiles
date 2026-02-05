# Package management using renv
# renv::init()
# renv::snapshot()
renv::restore() 
# Restores the exact package versions used in the RStudio project environment

library(openxlsx)
library(dplyr)
library(sf)

# Import municipal boundaries (IGN 2021 reference framework)
Communes <- st_read("1 Donnees brutes/Contour communes 2021/Shape communes 2021.sqlite")

# Import Solagro TFI dataset containing missing values
IFT_NA <- read.csv(
  "3 Outputs/2 Contour Communes MRC-PE avec NA/2 Données MRC-PE -21 communes à imputer.csv",
  header = TRUE,
  sep = ";",
  dec = "."
)

# Ensure numeric format for quantitative indicators
IFT_NA$ift_t_2020 <- as.numeric(IFT_NA$ift_t_2020)

# Merge municipal geometries with TFI indicators
Communes_IFT_NA <- merge(
  Communes,
  IFT_NA[, c(1, 3:ncol(IFT_NA))],
  by = "insee_com"
)

# Missing data imputation

# Identify indicator columns to impute
noms_colonnes <- colnames(Communes_IFT_NA[16:ncol(Communes_IFT_NA)])
noms_colonnes <- noms_colonnes[1:length(noms_colonnes) - 1] 
# Remove GEOMETRY field

# Function performing inverse-distance weighted imputation
imputer_valeur <- function(df, col_name) {
  
  # Compute municipal centroids
  # Warnings about attribute constancy are suppressed
  suppressWarnings({
    centroids <- st_centroid(df)
  })
  
  # Initialize imputed column
  df[[paste0(col_name, "_imputed")]] <- df[[col_name]]
  
  # Identify missing values
  na_indices <- which(is.na(df[[col_name]]))
  
  for (i in na_indices) {
    
    values <- numeric()
    distances <- numeric()
    neighbor_index <- 2
    
    # Search for five nearest valid neighbours
    while (length(values) < 5 && neighbor_index <= nrow(df)) {
      
      distances_all <- st_distance(centroids[i, ], centroids)[1, ]
      current_index <- order(distances_all)[neighbor_index]
      current_value <- df[[col_name]][current_index]
      
      if (!is.na(current_value)) {
        values <- c(values, current_value)
        distances <- c(distances, distances_all[current_index])
      }
      
      neighbor_index <- neighbor_index + 1
    }
    
    # Compute inverse-distance weighted mean
    if (length(values) > 0) {
      weights <- 1 / as.numeric(distances)
      weights <- weights / sum(weights)
      
      df[[paste0(col_name, "_imputed")]][i] <- sum(values * weights)
    }
  }
  
  df
}

# Apply imputation
IFT_apres_imputation <- Communes_IFT_NA

for (col_name in noms_colonnes) {
  IFT_apres_imputation <- imputer_valeur(IFT_apres_imputation, col_name)
}

# Export results – tabular format
IFT_apres_imputation_table <- st_drop_geometry(IFT_apres_imputation)

write.xlsx(
  IFT_apres_imputation_table,
  "3 Outputs/3 Contour Communes MRC-PE sans NA/IFT apres imputation.xlsx"
)

# Export results – GIS format
st_write(
  IFT_apres_imputation,
  "3 Outputs/3 Contour Communes MRC-PE sans NA/IFT apres imputation.sqlite"
)
