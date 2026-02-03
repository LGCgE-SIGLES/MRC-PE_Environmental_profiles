# Package management with renv
# renv::init()
# renv::snapshot()
renv::restore() # Restore the R package versions used in the original project (requires renv.lock)


# Load required packages
library(raster)
library(sf)
library(exactextractr)
library(writexl)

# Read municipality layer containing RMQS-derived indicators (before missing-value handling)
RMQS_1km <- st_read("3 Outputs/Metaux RMQS 1km/Mediane RMQS 1km avant gestion avant imputation.sqlite")


# Read 16 km RMQS rasters used to fill as many missing values as possible
# Missing values to be filled in Corsica (1 km rasters do not cover Corsica)
# Border missing values may also be partially filled using 16 km rasters
# Note: 16 km rasters are not available for cobalt (Co) and molybdenum (Mo)

fichiers_tiff <- list.files("1 Donnees brutes/Metaux 16x16km/Dbrute", pattern = "\\.tif$", full.names = TRUE)

for (fichier in fichiers_tiff) {
# Extract file name (without extension)
  nom <- tools::file_path_sans_ext(basename(fichier))
  
# Load GeoTIFF as a raster
  img <- raster(fichier)
  
# Assign the raster to the generated object name
  assign(nom, img)
  
  # Display a message to indicate the loading of the file
  cat("Fichier chargé :", nom, "\n")
  rm(img)
  rm(fichier)
  rm(nom)
  
}

# Extract file name (without path and extension)
noms_rasters <- tools::file_path_sans_ext(basename(fichiers_tiff))



# For each indicator, subset municipalities with missing values
# Then redo a specific processing on these municipalities using the 16 km raster layer
# We proceed exactly in the same way as before
# For each municipality, we extract all raster cells that intersect the municipality.
# Then assign the mean raster value within the municipality to fill the missing value
# After this step, some missing values may still remain
# For the remaining ones, we will need to consider an imputation method (no other alternative)


# Reproject municipalities to match raster CRS (if needed)
communes_RMQS_1km <- st_transform(RMQS_1km, crs = st_crs(get(noms_rasters[1])))

# We retrieve the first six letters of each column name of the dataframe communes_RMQS_1km
# And we rename the columns
noms_colonnes <- substr(colnames(communes_RMQS_1km[17: ncol(communes_RMQS_1km)]),1,6)
names(communes_RMQS_1km)[17:ncol(communes_RMQS_1km)] <- noms_colonnes
st_geometry(communes_RMQS_1km) <- "GEOMET"


for (fichier in noms_rasters) {
  
# First, subset municipalities with missing values for the current indicator
  # Use the first six letters of the raster name to select the column of interest in communes_RMQS_1km
  nom_colonne_interet <- substr(fichier, 1, 6)
  
# Select rows where the value is missing for the current indicator
  RMQS_filtre <- communes_RMQS_1km[is.na(communes_RMQS_1km[[nom_colonne_interet]]), ]
  
# Keep only the municipality code ('insee_com') and the current indicator column
  RMQS_filtre <- RMQS_filtre[, c('insee_com', nom_colonne_interet)]
  
# Retrieve raster object from the environment
  raster_obj <- get(fichier)
  
# Extract raster values for municipalities with missing values
  values_communes <- extract(raster_obj, RMQS_filtre, small=TRUE, exact=TRUE)
  
  # We compute the mean in each municipality missing
  moyennes <- sapply(values_communes, function(x) if (!is.null(x)) mean(x, na.rm=TRUE) else NA )
  moyennes[is.nan(moyennes)] <- NA
  
# Inject the filled values back into the original municipality layer
  communes_RMQS_1km[is.na(communes_RMQS_1km[[nom_colonne_interet]]), c(nom_colonne_interet) ] <- moyennes
  
    }


# Write output layer after handling part of the missing values (before imputation)
st_write(communes_RMQS_1km, "3 Outputs/Metaux RMQS 1km/Mediane RMQS 1km apres gestion avant imputation.sqlite")


# Create a data frame to store missing-value percentages per indicator
pourcentages_manquants <- data.frame(
  Indicateur = character(),
  Nombre_manquant = numeric(),
  Pourcentage_manquant = numeric(),
  stringsAsFactors = FALSE
)

# Compute missing-value percentage for each indicator
for (nom_colonne in names(communes_RMQS_1km)) {
  nombre <- sum(is.na(communes_RMQS_1km[[nom_colonne]]))
  pourcentage <- sum(is.na(communes_RMQS_1km[[nom_colonne]])) / nrow(communes_RMQS_1km) * 100
  pourcentages_manquants <- rbind(pourcentages_manquants, data.frame(Indicateur = nom_colonne, Nombre_manquant = nombre, Pourcentage_manquant = pourcentage))
}


# Save missing-value summary to Excel
write_xlsx(pourcentages_manquants[17:(nrow(pourcentages_manquants)-1),], "3 Outputs/Metaux RMQS 1km/Donnees manquantes avant imputation avec Corse.xlsx")


