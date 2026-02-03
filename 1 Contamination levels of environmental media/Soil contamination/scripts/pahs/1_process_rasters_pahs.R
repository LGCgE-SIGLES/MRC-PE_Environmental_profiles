# Package management with renv
# renv::init()
# renv::snapshot()
renv::restore() # Restore the R package versions used in the original project (requires renv.lock)


# Load required packages
library(raster)
library(sf)
library(exactextractr)


fichiers_tiff <- list.files("1 Donnees brutes/HAPs 2x2km/Dbrute", pattern = "\\.tif$", full.names = TRUE)

# Read each GeoTIFF file and assign it to an object named after the file
for (fichier in fichiers_tiff) {
# Extract file name (without extension)
  nom <- tools::file_path_sans_ext(basename(fichier))

# Load GeoTIFF as a raster
  img <- raster(fichier)

# Assign the raster to the generated object name
  assign(nom, img)

  # Display a message indicating that the file is being loaded
  cat("Fichier chargé :", nom, "\n")
  rm(img)
  rm(fichier)
  rm(nom)

}

# Extract file name (without path and extension)
noms_rasters <- tools::file_path_sans_ext(basename(fichiers_tiff))


# Read municipality boundaries (EPSG:2154)
communes <- st_read("1 Donnees brutes/Contours Communes/Shape Communes.shp")

# Reproject municipalities to match raster CRS (if needed)
communes_RMQS_2km <- st_transform(communes, crs = st_crs(get(noms_rasters[1])))


# Create an empty list
values_communes <- list()



i=0 

# Extract raster values within each municipality and compute municipality means
for (fichier in noms_rasters) {
# Retrieve raster object from the environment
  raster_obj <- get(fichier)
  
# Extract raster cell values intersecting each municipality
  values_communes[[fichier]] <- extract(raster_obj, communes_RMQS_2km, small=TRUE, exact=TRUE)

  moyennes <- sapply(values_communes[[fichier]], function(x) if (!is.null(x)) mean(x, na.rm=TRUE) else NA )
  
  moyennes[is.nan(moyennes)] <- NA
  
  col_name <- fichier
  communes_RMQS_2km[[col_name]] <- moyennes
  i=i+1
  cat(i,",")
  }

names(communes_RMQS_2km)[names(communes_RMQS_2km) == "froger_et_al_hap_french_soils"] <- "x15haps"

# Write output layer (municipality indicators) to file
st_write(communes_RMQS_2km, "3 Outputs/HAPs RMQS 2km/HAPs avant imputation.sqlite")