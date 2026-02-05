# Package management with renv
# renv::init()
# renv::snapshot()
renv::restore() # Restores the project-specific versions of all R packages used in the RStudio project

# Load required libraries
library(raster)
library(sf)
library(exactextractr)
library(writexl)
library(dplyr)
library(purrr)

# Import municipal boundaries (IGN 2021 – EPSG:2154)
communes <- st_read("1 Donnees brutes/Contour communes 2021/Shape communes 2021.sqlite")

# CRS information is missing in the metadata but the layer is provided in Lambert-93
st_crs(communes) <- 2154

# Import artificialization data (municipal aggregates)
artif_brut <- st_read("1 Donnees brutes/Artif brut/obs_artif_conso_com_2009_2023.shp")

# Keep relevant fields only
artif_brut <- as.data.frame(artif_brut[, c('idcom', 'artcom0923')])
artif_brut <- artif_brut[,c(1,2)]

# Join artificialization data to municipal boundaries
communes_avant_imputation <- merge(
  communes,
  artif_brut,
  by.x='insee_com',
  by.y='idcom',
  all.x=TRUE
)

# Export dataset before missing-value imputation
st_write(
  communes_avant_imputation,
  "3 Outputs/Artif_avant_imputation.gpkg"
)



# Inverse-distance weighted imputation function
imputer_valeur <- function(df, col_name) {
  
  # Compute centroids
  # Warnings related to attribute constancy are suppressed
  suppressWarnings({
    centroids <- st_centroid(df) 
  })
  
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
    
    # Search for up to 5 valid neighbouring municipalities
    while (length(values) < 5 && neighbor_index <= nrow(df)) {
      
      distances_all <- st_distance(centroids[i,], centroids)[1,]
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

communes_apres_imputation <- communes_avant_imputation

# Apply imputation to artificialization indicator
communes_apres_imputation <- imputer_valeur(
  communes_avant_imputation,
  'artcom0923'
)

# Export dataset after imputation
st_write(
  communes_apres_imputation,
  "3 Outputs/Artif_apres_imputation.gpkg"
)

# Export tabular version (without geometry)
communes_apres_imputation_df <- st_drop_geometry(
  communes_apres_imputation
)

write_xlsx(
  communes_apres_imputation_df,
  "3 Outputs/Artif_apres_imputation.xlsx"
)
