# Package management with renv
# renv::init()
#renv::snapshot()
renv::restore() # Restores the correct versions of all packages used in the RStudio project

library(raster)
library(sf)
library(exactextractr)
library(writexl)
library(readxl)
library(dplyr)
library(purrr)


# Import all indicators computed at the postal-code level
fichier_excel <- "3 Outputs/Indicateurs Code Postal/Avec NA/Resultats_indicateurs_cdepostal.xlsx"
noms_feuilles <- excel_sheets(fichier_excel)

# Read each sheet and convert it to a dataframe
resultats_importes <- lapply(noms_feuilles, function(feuille) {
  read_excel(fichier_excel, sheet = feuille)
})

# Assign sheet names to the imported dataframes
names(resultats_importes) <- noms_feuilles

# Rename dataframe columns
for (nom in noms_feuilles) {
  df <- resultats_importes[[nom]]
  colnames(df)[2:ncol(df)] <- paste(nom, colnames(df)[2:ncol(df)], sep = "_")
  resultats_importes[[nom]] <- df
}

# Merge all dataframes on the CODE_POSTAL column
df_combine <- Reduce(function(x, y) full_join(x, y, by = "CODE_POSTAL"), resultats_importes)


# Load postal-code polygons (no version more recent than 2014 available) – CRS Lambert-93
Code_postx <- st_read("1 Donnees brutes/Contours code postaux 2014/codes_postaux_region.shp")

# Make geometries valid
Code_postx <- st_make_valid(Code_postx)



# Join postal-code polygons with the indicator table (to spatialise the indicators)
Code_postx_indicateurs <- merge(Code_postx,df_combine,by.x='ID',by.y='CODE_POSTAL',all.x=TRUE)



# Then, normalise indicators by postal-code area
# Important: do this before imputing missing values
colonnes_a_modifier <- names(Code_postx_indicateurs)[7:(ncol(Code_postx_indicateurs) - 1)]

# Divide each numeric column by the area field ($SURF)
Code_postx_indicateurs_finaux <- Code_postx_indicateurs %>%
  mutate(across(all_of(colonnes_a_modifier), ~ .x / SURF))


Code_postx_indicateurs <- Code_postx_indicateurs_finaux

# Create a small dataframe to store the percentage of missing data per indicator
pourcentages_manquants <- data.frame(
  Indicateur = character(),
  Nombre_manquant = numeric(),
  Pourcentage_manquant = numeric(),
  stringsAsFactors = FALSE
)

# Compute the percentage of missing data for each column
for (nom_colonne in names(Code_postx_indicateurs)) {
  nombre <- sum(is.na(Code_postx_indicateurs[[nom_colonne]]))
  pourcentage <- sum(is.na(Code_postx_indicateurs[[nom_colonne]])) / nrow(Code_postx_indicateurs) * 100
  pourcentages_manquants <- rbind(pourcentages_manquants, data.frame(Indicateur = nom_colonne, Nombre_manquant = nombre, Pourcentage_manquant = pourcentage))
}


# Save the dataframe to an Excel file
write_xlsx(pourcentages_manquants[7:(nrow(pourcentages_manquants)-1),], "3 Outputs/Indicateurs Code Postal/Avec NA/Donnees manquantes avant imputation.xlsx")




# Impute missing values
# List of columns for which missing values should be imputed
noms_colonnes <- colnames(Code_postx_indicateurs[7:ncol(Code_postx_indicateurs)])
noms_colonnes <- noms_colonnes[1:length(noms_colonnes)-1] # Remove the GEOMETRY field


# Inverse-distance weighted imputation with validation of neighbouring values
imputer_valeur <- function(df, col_name) {
  
  # Compute centroids
  # We also suppress warnings stating 'st_centroid assumes attributes are constant over geometries'
  # This simply checks that the attributes (e.g., zn_tot) are constant within each spatial unit
  # Here the answer is yes: the indicator value is assumed constant within a given unit
  # Therefore, these warnings can be safely ignored
  
  suppressWarnings({
    centroids <- st_centroid(df) 
  })
  
  suppressWarnings({
    centroids <- st_centroid(df)
  })
  
  # Initialise the imputed column
  df[[paste0(col_name, "_imputed")]] <- df[[col_name]]
  
  # Find indices of rows with missing values
  na_indices <- which(is.na(df[[col_name]]))
  
  for (i in na_indices) {
    # Initialise containers for valid neighbours
    values <- numeric()
    distances <- numeric()
    neighbor_index <- 2
    
    # Search until 5 valid neighbours are found
    while (length(values) < 5 && neighbor_index <= nrow(df)) {
      # Compute distances from all other centroids to this one
      distances_all <- st_distance(centroids[i,], centroids)[1,]
      
      # Get the index of the current neighbour
      current_index <- order(distances_all)[neighbor_index]
      
      # Get the value for the current neighbour
      current_value <- df[[col_name]][current_index]
      
      # Check whether the neighbour has a valid value
      if (!is.na(current_value)) {
        values <- c(values, current_value)
        distances <- c(distances, distances_all[current_index])
      }
      
      # Move to the next neighbour
      neighbor_index <- neighbor_index + 1
    }
    
    # Compute weights (inverse of distances) if at least one valid neighbour is found
    if (length(values) > 0) {
      weights <- 1 / as.numeric(distances)
      weights <- weights / sum(weights) # Normalise weights so that they sum to 1
      
      # Compute the weighted mean
      df[[paste0(col_name, "_imputed")]][i] <- sum(values * weights)
    }
  }
  
  df
}


Code_postx_apres_imputation <- Code_postx_indicateurs

# Apply the imputation to each column
for (col_name in noms_colonnes) {
  Code_postx_apres_imputation <- imputer_valeur(Code_postx_apres_imputation, col_name)
}

# Save the spatial layer with imputed data
st_write(Code_postx_apres_imputation, "3 Outputs/Indicateurs Code Postal/Sans NA/Resultats_indicateurs_cdepostal.sqlite")


