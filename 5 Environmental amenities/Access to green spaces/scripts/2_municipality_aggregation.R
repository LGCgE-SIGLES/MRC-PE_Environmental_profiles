# Package management with renv
# renv::init()
# renv::snapshot()
renv::restore() # Restores the appropriate versions of all packages used in the RStudio project

# Load libraries
library(osmdata)
library(sf)
library(dplyr)
library(spatstat)
library(raster)
library(ggplot2)
library(terra)
library(exactextractr)


# Read municipality boundaries (EPSG:2154)
communes <- st_read("1 Donnees brutes/Contour communes 2021/Shape communes 2021.sqlite")

# The CRS metadata is missing in the file, but the layer is in Lambert-93 (EPSG:2154)
st_crs(communes) <- 2154


# Variants / indicator definitions (see methodological note)
variants <- list(
  list(indicator_code = "kde_parks", out_folder = "Parks"),
  list(indicator_code = "kde_parks_natural", out_folder = "Parks_natural"),
  list(indicator_code = "kde_parks_natural_forests", out_folder = "Parks_natural_forests")
)

out_communes_dir <- file.path("3 Outputs/FR entiere", "Municipal")
if (!dir.exists(out_communes_dir)) dir.create(out_communes_dir, recursive = TRUE)


# Compute municipal indicators for each OSM variant
for (v in variants) {

  # Path to the KDE raster file produced in step 1
  fichier_tiff <- file.path("3 Outputs/FR entiere", v$out_folder, paste0("Fr_kde_green_spaces_", v$indicator_code, ".tif"))

  # Load raster with terra
  raster_data <- rast(fichier_tiff)

  # For improved readability, apply a few transformations

  # Convert density from per m² to per km²
  raster_data <- raster_data * 1e6  # convert m² → km²

  # There are very small negative values (e.g., -3.01e-19); replace them with 0
  raster_data[raster_data < 0] <- 0

  # Round to 6 decimals
  raster_data <- round(raster_data, 6)

  # Export the corrected raster
  writeRaster(
    raster_data,
    filename = file.path("3 Outputs/FR entiere", v$out_folder, paste0("Fr_kde_green_spaces_", v$indicator_code, "_corrected.tif")),
    filetype = "GTiff",
    overwrite = TRUE
  )

  # Compute the mean raster value per municipality
  communes[[v$indicator_code]] <- exact_extract(raster_data, communes, fun = "mean")
}

# Export municipality layer with computed means
st_write(communes, file.path(out_communes_dir, "Commune_kde_green_spaces.gpkg"), delete_dsn = TRUE)
