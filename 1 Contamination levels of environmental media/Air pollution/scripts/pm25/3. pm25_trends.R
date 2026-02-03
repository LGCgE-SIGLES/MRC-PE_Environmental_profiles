# PM2.5 - Compute change rates (2015-2020 vs 2009-2014)
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
PM25_average_2009 <- raster("3 Outputs/PM25/Moyenne/Rasters/PM25_average_2009.tif")
PM25_average_2010 <- raster("3 Outputs/PM25/Moyenne/Rasters/PM25_average_2010.tif")
PM25_average_2011 <- raster("3 Outputs/PM25/Moyenne/Rasters/PM25_average_2011.tif")
PM25_average_2012 <- raster("3 Outputs/PM25/Moyenne/Rasters/PM25_average_2012.tif")
PM25_average_2013 <- raster("3 Outputs/PM25/Moyenne/Rasters/PM25_average_2013.tif")
PM25_average_2014 <- raster("3 Outputs/PM25/Moyenne/Rasters/PM25_average_2014.tif")
PM25_average_2015 <- raster("3 Outputs/PM25/Moyenne/Rasters/PM25_average_2015.tif")
PM25_average_2016 <- raster("3 Outputs/PM25/Moyenne/Rasters/PM25_average_2016.tif")
PM25_average_2017 <- raster("3 Outputs/PM25/Moyenne/Rasters/PM25_average_2017.tif")
PM25_average_2018 <- raster("3 Outputs/PM25/Moyenne/Rasters/PM25_average_2018.tif")
PM25_average_2019 <- raster("3 Outputs/PM25/Moyenne/Rasters/PM25_average_2019.tif")
PM25_average_2020 <- raster("3 Outputs/PM25/Moyenne/Rasters/PM25_average_2020.tif")

#Group rasters into the two comparison periods
stack_2009to2014 <- stack(PM25_average_2009, PM25_average_2010, PM25_average_2011,
                          PM25_average_2012, PM25_average_2013, PM25_average_2014)

stack_2015to2020 <- stack(PM25_average_2015, PM25_average_2016, PM25_average_2017,
                          PM25_average_2018, PM25_average_2019, PM25_average_2020)

# Compute the multi-year mean for each period
PM25_average_2009to2014 <- mean(stack_2009to2014)
PM25_average_2015to2020 <- mean(stack_2015to2020)

#Compute the percent change
PM25_evolution <- ((PM25_average_2015to2020 - PM25_average_2009to2014)/PM25_average_2009to2014)*100


# Load municipality boundaries (EPSG:2154)
communes <- st_read("1 Donnees brutes/Contour communes/Shape Communes.shp")

# Reproject municipality layer to match the raster CRS
communes <- st_transform(communes, crs = st_crs(PM25_evolution))

#Extract values from all rasters at once
values_communes_PM25 <- extract(PM25_evolution, communes)

communes_year <- communes
moyenne_par_commune <- sapply(values_communes_PM25, mean, na.rm = TRUE)
communes_year$PM25_evol <- moyenne_par_commune

# Write output shapefile with all columns for each year
st_write(communes_year, "3 Outputs/PM25/Evolution/PM25_Evol.shp")
