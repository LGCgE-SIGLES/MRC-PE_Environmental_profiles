# Package management with renv
# renv::init()
# renv::snapshot()
renv::restore() # Restore the R package versions used in the original project (requires renv.lock)

# Load required packages
library(raster)
library(sf)
library(exactextractr)
library(writexl)
library(dplyr)
library(purrr)

# Read municipality boundaries
communes_avant_imputation <- st_read("3 Outputs/HAPs RMQS 2km/HAPs avant imputation.sqlite")

# Exclude Corsica
communes_avant_imputation <- communes_avant_imputation %>% 
  filter(!insee_dep %in% c("2A", "2B"))

# Create a data frame to store missing-value percentages per indicator
pourcentages_manquants <- data.frame(
  Indicateur = character(),
  Nombre_manquant = numeric(),
  Pourcentage_manquant = numeric(),
  stringsAsFactors = FALSE
)

# Compute missing-value percentage for each indicator
for (nom_colonne in names(communes_avant_imputation)) {
  nombre <- sum(is.na(communes_avant_imputation[[nom_colonne]]))
  pourcentage <- sum(is.na(communes_avant_imputation[[nom_colonne]])) / nrow(communes_avant_imputation) * 100
  pourcentages_manquants <- rbind(pourcentages_manquants, data.frame(Indicateur = nom_colonne, Nombre_manquant = nombre, Pourcentage_manquant = pourcentage))
}

# Save missing-value summary to Excel
write_xlsx(pourcentages_manquants[17:(nrow(pourcentages_manquants)-1),], "3 Outputs/HAPs RMQS 2km/Donnees manquantes sans Corse.xlsx")

# List of indicator columns to impute
noms_colonnes <- colnames(communes_avant_imputation[17:ncol(communes_avant_imputation)])
noms_colonnes <- noms_colonnes[1:length(noms_colonnes)-1] # On enlève the champ GEOMETRY


# Function to perform inverse-distance weighted imputation, using only neighbours with non-missing values
imputer_valeur <- function(df, col_name) {
  
# Compute centroids
  # Also, we suppress warnings stating that st_centroid assumes attributes are constant over geometries
  # They simply want to ensure that the indicators (e.g. zn_tot) are constant within each spatial unit
  # The answer is yes: zinc concentration is considered constant within the same municipality
  # This is why we can ignore these warnings
  
  
  suppressWarnings({
    centroids <- st_centroid(df) 
  })
  
  suppressWarnings({
    centroids <- st_centroid(df)
  })
  
# Initialize the imputed column
  df[[paste0(col_name, "_imputed")]] <- df[[col_name]]
  
# Find row indices with missing values for the current indicator
  na_indices <- which(is.na(df[[col_name]]))
  
  for (i in na_indices) {
# Initialize the list of valid neighbours
    values <- numeric()
    distances <- numeric()
    neighbor_index <- 2
    
# Search for up to 5 nearest neighbours with non-missing values
    while (length(values) < 5 && neighbor_index <= nrow(df)) {
# Compute distances to other municipalities
      distances_all <- st_distance(centroids[i,], centroids)[1,]
      
      # Get the index of the current neighbor
      current_index <- order(distances_all)[neighbor_index]
      
      # Get the value of the current neighbor
      current_value <- df[[col_name]][current_index]
      
# Check whether the neighbour has a non-missing value
      if (!is.na(current_value)) {
        values <- c(values, current_value)
        distances <- c(distances, distances_all[current_index])
      }
      
      # Move to the next neighbor
      neighbor_index <- neighbor_index + 1
    }
    
# Compute inverse-distance weights if at least one valid neighbour is found
    if (length(values) > 0) {
      weights <- 1 / as.numeric(distances)
      weights <- weights / sum(weights) # Normalize the weights so that their sum equals 1
      
# Compute the weighted mean
      df[[paste0(col_name, "_imputed")]][i] <- sum(values * weights)
    }
  }
  
  df
}

communes_apres_imputation <- communes_avant_imputation

# Apply imputation to each indicator column
for (col_name in noms_colonnes) {
  communes_apres_imputation <- imputer_valeur(communes_apres_imputation, col_name)
}

# Save output layer with imputed values
st_write(communes_apres_imputation, "3 Outputs/HAPs RMQS 2km/HAPs apres imputation.sqlite")