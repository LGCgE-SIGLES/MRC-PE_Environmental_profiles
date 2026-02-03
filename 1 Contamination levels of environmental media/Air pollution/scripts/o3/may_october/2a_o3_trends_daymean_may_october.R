# O3 - Compute change rates (2015-2020 vs 2009-2014) - daymean (May–October)
#
# MRC-PE project - Air pollution indicators (INERIS reanalysis).
#

#Package management with renv
renv::restore() # Restores the exact versions of all R packages used in this R project.

#Load required packages
library(ncdf4)
library(raster)
library(sf)

# --- Helper: select May 1 to Oct 31 layers (handles leap years) ---
select_may_oct <- function(x) {
  n <- raster::nlayers(x)
  if (n == 365) return(raster::subset(x, 121:304))
  if (n == 366) return(raster::subset(x, 122:305))
  stop('Unexpected number of layers: ', n)
}


#IMPORT ANNUAL-MEAN RASTERS
O3_average_2009 <- raster("3 Outputs/O3/Mai a octobre/Moyenne daymean/Rasters/O3_average_2009.tif")
O3_average_2010 <- raster("3 Outputs/O3/Mai a octobre/Moyenne daymean/Rasters/O3_average_2010.tif")
O3_average_2011 <- raster("3 Outputs/O3/Mai a octobre/Moyenne daymean/Rasters/O3_average_2011.tif")
O3_average_2012 <- raster("3 Outputs/O3/Mai a octobre/Moyenne daymean/Rasters/O3_average_2012.tif")
O3_average_2013 <- raster("3 Outputs/O3/Mai a octobre/Moyenne daymean/Rasters/O3_average_2013.tif")
O3_average_2014 <- raster("3 Outputs/O3/Mai a octobre/Moyenne daymean/Rasters/O3_average_2014.tif")
O3_average_2015 <- raster("3 Outputs/O3/Mai a octobre/Moyenne daymean/Rasters/O3_average_2015.tif")
O3_average_2016 <- raster("3 Outputs/O3/Mai a octobre/Moyenne daymean/Rasters/O3_average_2016.tif")
O3_average_2017 <- raster("3 Outputs/O3/Mai a octobre/Moyenne daymean/Rasters/O3_average_2017.tif")
O3_average_2018 <- raster("3 Outputs/O3/Mai a octobre/Moyenne daymean/Rasters/O3_average_2018.tif")
O3_average_2019 <- raster("3 Outputs/O3/Mai a octobre/Moyenne daymean/Rasters/O3_average_2019.tif")
O3_average_2020 <- raster("3 Outputs/O3/Mai a octobre/Moyenne daymean/Rasters/O3_average_2020.tif")

#Group rasters into the two comparison periods
stack_2009to2014 <- stack(O3_average_2009, O3_average_2010, O3_average_2011,
                          O3_average_2012, O3_average_2013, O3_average_2014)

stack_2015to2020 <- stack(O3_average_2015, O3_average_2016, O3_average_2017,
                          O3_average_2018, O3_average_2019, O3_average_2020)

# Compute the multi-year mean for each period
O3_average_2009to2014 <- mean(stack_2009to2014)
O3_average_2015to2020 <- mean(stack_2015to2020)

#Compute the percent change
O3_evolution <- ((O3_average_2015to2020 - O3_average_2009to2014)/O3_average_2009to2014)*100


# Load municipality boundaries (EPSG:2154)
communes <- st_read("1 Donnees brutes/Contour communes/Shape Communes.shp")

# Reproject municipality layer to match the raster CRS
communes <- st_transform(communes, crs = st_crs(O3_evolution))

#Extract values from all rasters at once
values_communes_O3 <- extract(O3_evolution, communes)

communes_year <- communes
moyenne_par_commune <- sapply(values_communes_O3, mean, na.rm = TRUE)
communes_year$O3_evol <- moyenne_par_commune

# Write output shapefile with all columns for each year
st_write(communes_year, "3 Outputs/O3/Mai a octobre/Evolution daymean/O3_Evol.shp")