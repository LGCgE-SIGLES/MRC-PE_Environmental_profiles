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



# Variants / indicator definitions
# In the MRC-PE dataset, three indicators are produced using the same workflow but different OSM tag selections:
# 1) Strictly urban vision: parks and gardens
# 2) Urban + natural reserves: parks, gardens, nature reserves
# 3) Broader vision including forests/wooded areas: parks, gardens, nature reserves, forests/wood
variants <- list(
  list(
    indicator_code = "kde_parks",
    out_folder = "Parks",
    query = "SELECT * FROM multipolygons WHERE leisure IN ('park', 'garden')"
  ),
  list(
    indicator_code = "kde_parks_natural",
    out_folder = "Parks_natural",
    query = "SELECT * FROM multipolygons WHERE leisure IN ('park', 'garden' ,'nature-reserve')"
  ),
  list(
    indicator_code = "kde_parks_natural_forests",
    out_folder = "Parks_natural_forests",
    query = "SELECT * FROM multipolygons WHERE leisure IN ('park', 'garden', 'nature-reserve') OR landuse = 'forest' OR natural = 'wood'"
  )
)

# Step 1: Load OSM data with sf and filter the features of interest
# Read OSM data directly from the .osm.pbf file
for (v in variants) {
  message(sprintf("Processing OSM variant: %s", v$indicator_code))

  out_dir <- file.path("3 Outputs/FR entiere", v$out_folder)
  if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

  osm_data <- st_read(
    dsn = "1 Donnees brutes/OSM France/france-latest.osm.pbf",
    layer = "multipolygons",  # Load polygons only
    query = v$query
  )


# Step 2: Simplify and reproject geometries
# Reproject to Lambert-93
osm_data <- st_transform(osm_data, crs = 2154)

# Initial geometry simplification
osm_data <- st_simplify(osm_data, dTolerance = 5)

# Fix invalid geometries
osm_polygons <- st_make_valid(osm_data)

# Merge all geometries
osm_polygons_fused <- st_union(osm_polygons)

# # Export to GeoJSON for verification
# st_write(osm_polygons_fused, "3 Outputs/FR entiere/Fr_ev_fusionnes.geojson", delete_dsn = TRUE)




# Step 3: Rasterise the vector layer to facilitate computations
# (instead of creating a regular grid of points and intersecting it with green-space polygons).

# Get polygon extent (bounding box)
osm_extent <- st_bbox(osm_polygons_fused)  # Extraire les limites (xmin, ymin, xmax, ymax)

# Convert the extent to a `SpatExtent` object for `terra`
osm_extent_terra <- ext(osm_extent["xmin"], osm_extent["xmax"], osm_extent["ymin"], osm_extent["ymax"])

# Retrieve CRS from the sf object
crs_terra <- st_crs(osm_polygons_fused)$wkt  # Utiliser le WKT pour compatibilité avec terra

# Create a raster template based on the polygon extent (30 m × 30 m resolution)
# Helps capture even small urban green spaces
raster_template <- rast(ext = osm_extent_terra, resolution = 30, crs = crs_terra)

# Convert sf object to a SpatVector
osm_polygons_fused_vect <- vect(osm_polygons_fused)

# Rasterise polygons
rasterized <- rasterize(osm_polygons_fused_vect, raster_template, field = 1, background = NA)

# Export raster for visual inspection
writeRaster(rasterized, file.path(out_dir, paste0("Fr_ev_raster_", v$indicator_code, ".tif")), overwrite = TRUE)



# Step 4: From the raster created above (30 m × 30 m resolution),
# Identify raster cells/pixels that contain a green spaceis present
# Then extract the spatial coordinates of these cells (more precisely, cell centroids)

# Initialise a list for non-NA cells
non_na_cells <- c()

# To reduce memory use, process the raster in blocks
# Define block size
block_size <- 100  # Number of rows per block (adjust depending on available RAM)

# Loop over blocks
for (start_row in seq(1, nrow(rasterized), by = block_size)) {
  # Compute end row for the block
  end_row <- min(start_row + block_size - 1, nrow(rasterized))

  # Convert rows to spatial coordinates
  ymin <- yFromRow(rasterized, end_row)
  ymax <- yFromRow(rasterized, start_row)
  raster_extent <- ext(xmin(rasterized), xmax(rasterized), ymin, ymax)

  # Crop the block
  block <- crop(rasterized, raster_extent)

  # Identify non-NA cells in this block
  block_cells <- which(!is.na(values(block)))

  # Append indices to the full list
  non_na_cells <- c(non_na_cells, block_cells + (start_row - 1) * ncol(rasterized))
}

# Extract coordinates of non-NA cells
points_coords <- xyFromCell(rasterized, non_na_cells)




# Step 5: Convert coordinates to a `ppp` object (required to run KDE)
# Build the spatial window from the raster extent
raster_extent <- as.polygons(ext(rasterized))  # Convert the extent to a polygon
raster_extent <- st_as_sf(raster_extent)      # Convert to an sf object
st_crs(raster_extent) <- st_crs(rasterized)   # Ensure CRS is set
raster_window <- as.owin(raster_extent)       # Convert to a spatstat window (owin)

# Create the ppp object
points_ppp <- ppp(
  x = points_coords[, 1],  # X coordinates
  y = points_coords[, 2],  # Y coordinates
  window = raster_window
)

rm(raster_extent)
rm(points_coords)
rm(non_na_cells)
rm(rasterized)




# Step 6: Run KDE with a 400 m bandwidth using the Epanechnikov kernel
# Output is a 200 m × 200 m raster (limited by computational resources at national scale)
# This resolution is sufficient for the MRC-PE context (municipality aggregation afterwards)
# At a more local scale (city/urban area), a finer resolution could be used
kde_result <- density.ppp(points_ppp, sigma = 400, kernel = "epanechnikov", eps = c(200, 200))

# Convert KDE result to a raster
kde_raster <- raster(kde_result)

# Set Lambert-93 CRS
crs(kde_raster) <- CRS("EPSG:2154")

# Export raster as GeoTIFF
writeRaster(kde_raster, file.path(out_dir, paste0("Fr_kde_green_spaces_", v$indicator_code, ".tif")), format = "GTiff", overwrite = TRUE)

}
