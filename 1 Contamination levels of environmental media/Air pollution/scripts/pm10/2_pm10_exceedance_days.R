# PM10 - Compute exceedance days
#
# MRC-PE project - Air pollution indicators (INERIS reanalysis).
#

#Package management with renv
renv::restore() # Restores the exact versions of all R packages used in this R project.

#Load required packages
library(ncdf4)
library(raster)
library(sf)



# #Import spatio-temporal rasters previously processed to ensure a common spatial resolution
PM10_2007 <- brick("3 Outputs/PM10/.Rasters alignes/PM10_2007_resampled.nc")
PM10_2008 <- brick("3 Outputs/PM10/.Rasters alignes/PM10_2008_resampled.nc")
PM10_2009 <- brick("3 Outputs/PM10/.Rasters alignes/PM10_2009_resampled.nc")
PM10_2010 <- brick("3 Outputs/PM10/.Rasters alignes/PM10_2010_resampled.nc")
PM10_2011 <- brick("3 Outputs/PM10/.Rasters alignes/PM10_2011_resampled.nc")
PM10_2012 <- brick("3 Outputs/PM10/.Rasters alignes/PM10_2012_resampled.nc")
PM10_2013 <- brick("3 Outputs/PM10/.Rasters alignes/PM10_2013_resampled.nc")
PM10_2014 <- brick("3 Outputs/PM10/.Rasters alignes/PM10_2014_resampled.nc")
PM10_2015 <- brick("3 Outputs/PM10/.Rasters alignes/PM10_2015_resampled.nc")
PM10_2016 <- brick("3 Outputs/PM10/.Rasters alignes/PM10_2016_resampled.nc")
PM10_2017 <- brick("3 Outputs/PM10/.Rasters alignes/PM10_2017_resampled.nc")
PM10_2018 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2018.FRA02/INERIS.REANALYSED.FRA02.2018.PM10.daymean.2gis.nc")
PM10_2019 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2019.FRA02/INERIS.REANALYSED.FRA02.2019.PM10.daymean.2gis.nc")
PM10_2020 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2020.FRA02/INERIS.REANALYSED.FRA02.2020.PM10.daymean.2gis.nc")

threshold<-45

count_days_above_threshold <- function(x) {
  sum(x > threshold)
}


#  Compute the number of exceedance days
PM10_days_2007 <- calc(PM10_2007, fun = count_days_above_threshold)
PM10_days_2008 <- calc(PM10_2008, fun = count_days_above_threshold)
PM10_days_2009 <- calc(PM10_2009, fun = count_days_above_threshold)
PM10_days_2010 <- calc(PM10_2010, fun = count_days_above_threshold)
PM10_days_2011 <- calc(PM10_2011, fun = count_days_above_threshold)
PM10_days_2012 <- calc(PM10_2012, fun = count_days_above_threshold)
PM10_days_2013 <- calc(PM10_2013, fun = count_days_above_threshold)
PM10_days_2014 <- calc(PM10_2014, fun = count_days_above_threshold)
PM10_days_2015 <- calc(PM10_2015, fun = count_days_above_threshold)
PM10_days_2016 <- calc(PM10_2016, fun = count_days_above_threshold)
PM10_days_2017 <- calc(PM10_2017, fun = count_days_above_threshold)
PM10_days_2018 <- calc(PM10_2018, fun = count_days_above_threshold)
PM10_days_2019 <- calc(PM10_2019, fun = count_days_above_threshold)
PM10_days_2020 <- calc(PM10_2020, fun = count_days_above_threshold)

# Then we optionally save annual rasters as GeoTIFF (more convenient than NetCDF for QGIS viewing).
writeRaster(PM10_days_2007, filename="3 Outputs/PM10/Depassement/Rasters/PM10_days_2007.tif",format="GTiff")
writeRaster(PM10_days_2008, filename="3 Outputs/PM10/Depassement/Rasters/PM10_days_2008.tif",format="GTiff")
writeRaster(PM10_days_2009, filename="3 Outputs/PM10/Depassement/Rasters/PM10_days_2009.tif",format="GTiff")
writeRaster(PM10_days_2010, filename="3 Outputs/PM10/Depassement/Rasters/PM10_days_2010.tif",format="GTiff")
writeRaster(PM10_days_2011, filename="3 Outputs/PM10/Depassement/Rasters/PM10_days_2011.tif",format="GTiff")
writeRaster(PM10_days_2012, filename="3 Outputs/PM10/Depassement/Rasters/PM10_days_2012.tif",format="GTiff")
writeRaster(PM10_days_2013, filename="3 Outputs/PM10/Depassement/Rasters/PM10_days_2013.tif",format="GTiff")
writeRaster(PM10_days_2014, filename="3 Outputs/PM10/Depassement/Rasters/PM10_days_2014.tif",format="GTiff")
writeRaster(PM10_days_2015, filename="3 Outputs/PM10/Depassement/Rasters/PM10_days_2015.tif",format="GTiff")
writeRaster(PM10_days_2016, filename="3 Outputs/PM10/Depassement/Rasters/PM10_days_2016.tif",format="GTiff")
writeRaster(PM10_days_2017, filename="3 Outputs/PM10/Depassement/Rasters/PM10_days_2017.tif",format="GTiff")
writeRaster(PM10_days_2018, filename="3 Outputs/PM10/Depassement/Rasters/PM10_days_2018.tif",format="GTiff")
writeRaster(PM10_days_2019, filename="3 Outputs/PM10/Depassement/Rasters/PM10_days_2019.tif",format="GTiff")
writeRaster(PM10_days_2020, filename="3 Outputs/PM10/Depassement/Rasters/PM10_days_2020.tif",format="GTiff")


#MUNICIPAL-LEVEL AGGREGATION STEP

#Load rasters of annual exceedance days for PM10
PM10_days_2007 <- raster("3 Outputs/PM10/Depassement/Rasters/PM10_days_2007.tif")
PM10_days_2008 <- raster("3 Outputs/PM10/Depassement/Rasters/PM10_days_2008.tif")
PM10_days_2009 <- raster("3 Outputs/PM10/Depassement/Rasters/PM10_days_2009.tif")
PM10_days_2010 <- raster("3 Outputs/PM10/Depassement/Rasters/PM10_days_2010.tif")
PM10_days_2011 <- raster("3 Outputs/PM10/Depassement/Rasters/PM10_days_2011.tif")
PM10_days_2012 <- raster("3 Outputs/PM10/Depassement/Rasters/PM10_days_2012.tif")
PM10_days_2013 <- raster("3 Outputs/PM10/Depassement/Rasters/PM10_days_2013.tif")
PM10_days_2014 <- raster("3 Outputs/PM10/Depassement/Rasters/PM10_days_2014.tif")
PM10_days_2015 <- raster("3 Outputs/PM10/Depassement/Rasters/PM10_days_2015.tif")
PM10_days_2016 <- raster("3 Outputs/PM10/Depassement/Rasters/PM10_days_2016.tif")
PM10_days_2017 <- raster("3 Outputs/PM10/Depassement/Rasters/PM10_days_2017.tif")
PM10_days_2018 <- raster("3 Outputs/PM10/Depassement/Rasters/PM10_days_2018.tif")
PM10_days_2019 <- raster("3 Outputs/PM10/Depassement/Rasters/PM10_days_2019.tif")
PM10_days_2020 <- raster("3 Outputs/PM10/Depassement/Rasters/PM10_days_2020.tif")



#AGGREGATION AT MUNICIPAL LEVEL
# Load all rasters into a single list
raster_list <- lapply(2007:2020, function(year) {
  raster_file <- paste0("3 Outputs/PM10/Depassement/Rasters/PM10_days_", year, ".tif")
  raster(raster_file)
})

# Fusionner les rasters en un seul raster stack
raster_stack <- stack(raster_list)

# Load municipality boundaries (EPSG:2154)
communes <- st_read("1 Donnees brutes/Contour communes/Shape Communes.shp")

# Reproject municipality layer to match the raster CRS
communes <- st_transform(communes, crs = st_crs(raster_stack))

#Extract values from all rasters at once
values_communes_PM10 <- extract(raster_stack, communes)

communes_year <- communes

# Loop to compute the municipal mean for each year
for (year in 2007:2020) {
  nom_year <- paste0("PM10_days_", formatC(year, width = 2, flag = "0"))
  donnees_year <- sapply(values_communes_PM10, function(x) x[, nom_year])
  moyenne_par_commune <- sapply(donnees_year, mean, na.rm = TRUE)
  col_name <- paste0("PM10_", formatC(year, width = 2, flag = "0"))
  communes_year[[col_name]] <- moyenne_par_commune
}


#Convert to a data.frame to compute the multi-year average
interannuel <- as.data.frame(cbind(communes_year[,c("INSEE_COM")] ,communes_year[, grepl("^PM10_", names(communes_year))]))

# Identify the columns to keep (those that do not start with 'geometry')
indices_colonnes <- grep("^geometry", names(interannuel), invert = TRUE)
interannuel <- interannuel[, indices_colonnes]

#Compute multi-year average (2007-2020)
interannuel$PM10_0720 <-rowMeans(interannuel[, grepl("^PM10_", names(interannuel))], na.rm = TRUE)

#Compute multi-year average (2009-2020)
interannuel$PM10_0920 <- rowMeans (interannuel[, c(4:15)], na.rm = TRUE)

communes_year<- merge(communes_year, interannuel[, c("INSEE_COM", "PM10_0720","PM10_0920")], by = "INSEE_COM")
                       

# Write output shapefile with all columns for each year
st_write(communes_year, "3 Outputs/PM10/Depassement/PM10_Days.shp")
