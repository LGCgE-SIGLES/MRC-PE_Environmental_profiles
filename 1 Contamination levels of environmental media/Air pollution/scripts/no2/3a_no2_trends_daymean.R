# NO2 - Compute change rates (2015-2020 vs 2009-2014) - daymean
#
# MRC-PE project - Air pollution indicators (INERIS reanalysis).
#

#Package management with renv
renv::restore() # Restores the exact versions of all R packages used in this R project.

#Load required packages
library(ncdf4)
library(raster)
library(sf)


#IMPORT ANNUAL-MEAN RASTERS
NO2_average_2009 <- raster("3 Outputs/NO2/Moyenne daymean/Rasters/NO2_average_2009.tif")
NO2_average_2010 <- raster("3 Outputs/NO2/Moyenne daymean/Rasters/NO2_average_2010.tif")
NO2_average_2011 <- raster("3 Outputs/NO2/Moyenne daymean/Rasters/NO2_average_2011.tif")
NO2_average_2012 <- raster("3 Outputs/NO2/Moyenne daymean/Rasters/NO2_average_2012.tif")
NO2_average_2013 <- raster("3 Outputs/NO2/Moyenne daymean/Rasters/NO2_average_2013.tif")
NO2_average_2014 <- raster("3 Outputs/NO2/Moyenne daymean/Rasters/NO2_average_2014.tif")
NO2_average_2015 <- raster("3 Outputs/NO2/Moyenne daymean/Rasters/NO2_average_2015.tif")
NO2_average_2016 <- raster("3 Outputs/NO2/Moyenne daymean/Rasters/NO2_average_2016.tif")
NO2_average_2017 <- raster("3 Outputs/NO2/Moyenne daymean/Rasters/NO2_average_2017.tif")
NO2_average_2018 <- raster("3 Outputs/NO2/Moyenne daymean/Rasters/NO2_average_2018.tif")
NO2_average_2019 <- raster("3 Outputs/NO2/Moyenne daymean/Rasters/NO2_average_2019.tif")
NO2_average_2020 <- raster("3 Outputs/NO2/Moyenne daymean/Rasters/NO2_average_2020.tif")

#Group rasters into the two comparison periods
stack_2009to2014 <- stack(NO2_average_2009, NO2_average_2010, NO2_average_2011,
                          NO2_average_2012, NO2_average_2013, NO2_average_2014)

stack_2015to2020 <- stack(NO2_average_2015, NO2_average_2016, NO2_average_2017,
                          NO2_average_2018, NO2_average_2019, NO2_average_2020)

# Compute the multi-year mean for each period
NO2_average_2009to2014 <- mean(stack_2009to2014)
NO2_average_2015to2020 <- mean(stack_2015to2020)

#Compute the percent change
NO2_evolution <- ((NO2_average_2015to2020 - NO2_average_2009to2014)/NO2_average_2009to2014)*100


# Load municipality boundaries (EPSG:2154)
communes <- st_read("1 Donnees brutes/Contour communes/Shape Communes.shp")

# Reproject municipality layer to match the raster CRS
communes <- st_transform(communes, crs = st_crs(NO2_evolution))

#Extract values from all rasters at once
values_communes_NO2 <- extract(NO2_evolution, communes)

communes_year <- communes
moyenne_par_commune <- sapply(values_communes_NO2, mean, na.rm = TRUE)
communes_year$NO2_evol <- moyenne_par_commune

# Write output shapefile with all columns for each year
st_write(communes_year, "3 Outputs/NO2/Evolution daymean/NO2_Evol.shp")
