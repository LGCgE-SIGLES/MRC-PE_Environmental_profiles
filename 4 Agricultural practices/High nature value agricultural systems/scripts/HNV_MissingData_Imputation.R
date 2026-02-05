# Package management with renv
# renv::init()
# renv::snapshot()
renv::restore() 
# Restores the project-specific package environment to ensure reproducibility

library(openxlsx)
library(dplyr)
library(sf)

# Import municipal boundaries (IGN 2021 reference framework)
Communes <- st_read("1 Donnees brutes/Contour communes 2021/Shape communes 2021.sqlite")

# Import HNV dataset containing missing values after harmonisation
HVN_NA <- read.csv(
  "3 Outputs/2 Contour Communes MRC-PE avec N.A/Indicateurs agrégés interannuels.csv",
  header = TRUE,
  sep = ";",
  dec = ","
)

# Merge HNV indicators with municipal boundaries
Communes_HVN_NA <- merge(
  Communes,
  HVN_NA[, c(1, 3:ncol(HVN_NA))],
  by = "insee_com"
)

# Identify indicator columns requiring imputation
indicator_columns <- colnames(Communes_HVN_NA[28:ncol(Communes_HVN_NA)])

# Remove geometry column from the list
indicator_columns <- indicator_columns[1:length(indicator_columns) - 1]

# Function performing inverse-distance weighted imputation
impute_value <- function(df, col_name) {
  
  # Compute municipal centroids
  # Warnings about attribute constancy are suppressed because
  # indicators are assumed homogeneous within municipalities
  suppressWarnings({
    centroids <- st_centroid(df)
  })
  
  # Create imputed column initialized with original values
  df[[paste0(col_name, "_imputed")]] <- df[[col_name]]
  
  # Identify rows with missing values
  na_indices <- which(is.na(df[[col_name]]))
  
  for (i in na_indices) {
    
    values <- numeric()
    distances <- numeric()
    neighbor_index <- 2
    
    # Search for the five nearest neighbours with valid values
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
  
  return(df)
}

# Apply imputation to all indicator columns
HVN_after_imputation <- Communes_HVN_NA

for (col_name in indicator_columns) {
  HVN_after_imputation <- impute_value(HVN_after_imputation, col_name)
}

# Export imputed dataset – table format
HVN_table <- st_drop_geometry(HVN_after_imputation)

write.xlsx(
  HVN_table,
  "3 Outputs/3 Contour Communes MRC-PE sans N.A/HVN apres imputation.xlsx"
)

# Export spatial datasets (before and after imputation)

st_write(
  Communes_HVN_NA,
  "3 Outputs/2 Contour Communes MRC-PE avec N.A/HVN avant imputation.sqlite"
)

st_write(
  HVN_after_imputation,
  "3 Outputs/3 Contour Communes MRC-PE sans N.A/HVN apres imputation.sqlite"
)
