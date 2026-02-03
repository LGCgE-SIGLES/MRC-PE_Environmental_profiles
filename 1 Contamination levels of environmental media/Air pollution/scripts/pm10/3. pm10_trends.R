# PM10 - Compute change rates (2015-2020 vs 2009-2014)
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
PM10_average_2009 <- raster("3 Outputs/PM10/Moyenne/Rasters/PM10_average_2009.tif")
PM10_average_2010 <- raster("3 Outputs/PM10/Moyenne/Rasters/PM10_average_2010.tif")
PM10_average_2011 <- raster("3 Outputs/PM10/Moyenne/Rasters/PM10_average_2011.tif")
PM10_average_2012 <- raster("3 Outputs/PM10/Moyenne/Rasters/PM10_average_2012.tif")
PM10_average_2013 <- raster("3 Outputs/PM10/Moyenne/Rasters/PM10_average_2013.tif")
PM10_average_2014 <- raster("3 Outputs/PM10/Moyenne/Rasters/PM10_average_2014.tif")
PM10_average_2015 <- raster("3 Outputs/PM10/Moyenne/Rasters/PM10_average_2015.tif")
PM10_average_2016 <- raster("3 Outputs/PM10/Moyenne/Rasters/PM10_average_2016.tif")
PM10_average_2017 <- raster("3 Outputs/PM10/Moyenne/Rasters/PM10_average_2017.tif")
PM10_average_2018 <- raster("3 Outputs/PM10/Moyenne/Rasters/PM10_average_2018.tif")
PM10_average_2019 <- raster("3 Outputs/PM10/Moyenne/Rasters/PM10_average_2019.tif")
PM10_average_2020 <- raster("3 Outputs/PM10/Moyenne/Rasters/PM10_average_2020.tif")

#Group rasters into the two comparison periods
stack_2009to2014 <- stack(PM10_average_2009, PM10_average_2010, PM10_average_2011,
                          PM10_average_2012, PM10_average_2013, PM10_average_2014)

stack_2015to2020 <- stack(PM10_average_2015, PM10_average_2016, PM10_average_2017,
                          PM10_average_2018, PM10_average_2019, PM10_average_2020)

# Compute the multi-year mean for each period
PM10_average_2009to2014 <- mean(stack_2009to2014)
PM10_average_2015to2020 <- mean(stack_2015to2020)

#Compute the percent change
PM10_evolution <- ((PM10_average_2015to2020 - PM10_average_2009to2014)/PM10_average_2009to2014)*100


# Load municipality boundaries (EPSG:2154)
communes <- st_read("1 Donnees brutes/Contour communes/Shape Communes.shp")

# Reproject municipality layer to match the raster CRS
communes <- st_transform(communes, crs = st_crs(PM10_evolution))

#Extract values from all rasters at once
values_communes_PM10 <- extract(PM10_evolution, communes)

communes_year <- communes
moyenne_par_commune <- sapply(values_communes_PM10, mean, na.rm = TRUE)
communes_year$PM10_evol <- moyenne_par_commune

# Write output shapefile with all columns for each year
st_write(communes_year, "3 Outputs/PM10/Evolution/PM10_Evol.shp")
