# Package management with renv
# renv::init()
# renv::snapshot()
renv::restore() # Restore the exact package versions used in this RStudio project

# Load libraries
library(sf)
library(dplyr)
library(spatstat)
library(raster)
library(ggplot2)
library(terra)

# Load municipalities and compute their areas (km²)
communes <- st_read("1 Donnees brutes/Contour communes 2021/Shape communes 2021.sqlite")
st_crs(communes) <- 2154 # Assign Lambert-93 (EPSG:2154)
communes$surf_com_km2 <- as.numeric(st_area(communes)) / 1000000

# Load road segments (whole of metropolitan France)
# This layer has already been filtered and contains only segments with importance 1, 2, 3 or 4
troncons <- st_read("1 Donnees brutes/BD TOPO Tronçons FR entière/Troncons_importance_1234.gpkg")

# Create a function encapsulating all required steps to compute the indicator
# from road segments and municipalities, for the selected importance classes
calculer_indicateur <- function(troncons_data, communes_data, importances) {
  
  # Step 1: Filter road segments by importance classes
  troncons_filtered <- troncons_data %>% filter(importance %in% importances)
  
  # Step 2: Spatial intersection between filtered segments and municipalities
  troncons_decoupes <- st_intersection(troncons_filtered, communes_data)
  
  # Step 3: Keep only linear geometries created by intersections
  # Points may appear when an intersection between a segment and a municipal boundary is reduced to a single point
  troncons_decoupes <- troncons_decoupes %>%
    filter(st_geometry_type(.) == "LINESTRING")
  
  # Step 4: Explicitly compute lengths (km)
  lengths_km <- st_length(troncons_decoupes) / 1000
  troncons_decoupes$length_km <- as.numeric(lengths_km)
  
  # Step 5: Aggregate total road length by municipality
  lengths_by_commune <- troncons_decoupes %>%
    group_by(insee_com) %>%
    summarise(total_length_km = sum(length_km, na.rm = TRUE)) %>%
    st_drop_geometry()
  
  # Step 6: Join results back to municipalities and compute the density indicator
  communes_with_indic <- communes_data %>%
    left_join(lengths_by_commune, by = "insee_com") %>%
    mutate(
      total_length_km = ifelse(is.na(total_length_km), 0, total_length_km),
      indicateur = total_length_km / surf_com_km2
    )
  
  return(communes_with_indic)
}


# Compute indicators using the function
indicateur_1_4 <- calculer_indicateur(troncons, communes, c(1, 2, 3, 4))
indicateur_1_2 <- calculer_indicateur(troncons, communes, c(1, 2))
indicateur_1 <- calculer_indicateur(troncons, communes, c(1))

# Export outputs for verification
st_write(indicateur_1_4, "3 Outputs/indicateur_1_4.gpkg", delete_layer = TRUE)
st_write(indicateur_1_2, "3 Outputs/indicateur_1_2.gpkg", delete_layer = TRUE)
st_write(indicateur_1, "3 Outputs/indicateur_1.gpkg", delete_layer = TRUE)
