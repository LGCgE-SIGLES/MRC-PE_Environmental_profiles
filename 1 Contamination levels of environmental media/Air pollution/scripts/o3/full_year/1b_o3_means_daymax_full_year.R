# O3 - Compute long-term averages - daymax (full year)
#
# MRC-PE project - Air pollution indicators (INERIS reanalysis).
#

#Package management with renv
renv::restore() # Restores the exact versions of all R packages used in this R project.

#Load required packages
library(ncdf4)
library(raster)
library(sf)


# #Import spatio-temporal rasters. The `brick()` function keeps all raster bands (here: 365 or 366 daily layers).
O3_2000 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2000.FRA03/INERIS.REANALYSED.FRA03.2000.O3.daymax.2gis.nc")
O3_2001 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2001.FRA03/INERIS.REANALYSED.FRA03.2001.O3.daymax.2gis.nc")
O3_2002 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2002.FRA03/INERIS.REANALYSED.FRA03.2002.O3.daymax.2gis.nc")
O3_2003 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2003.FRA03/INERIS.REANALYSED.FRA03.2003.O3.daymax.2gis.nc")
O3_2004 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2004.FRA03/INERIS.REANALYSED.FRA03.2004.O3.daymax.2gis.nc")
O3_2005 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2005.FRA03/INERIS.REANALYSED.FRA03.2005.O3.daymax.2gis.nc")
O3_2006 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2006.FRA03/INERIS.REANALYSED.FRA03.2006.O3.daymax.2gis.nc")
O3_2007 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2007.FRA03/INERIS.REANALYSED.FRA03.2007.O3.daymax.2gis.nc")
O3_2008 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2008.FRA03/INERIS.REANALYSED.FRA03.2008.O3.daymax.2gis.nc")
O3_2009 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2009.FRA03/INERIS.REANALYSED.FRA03.2009.O3.daymax.2gis.nc")
O3_2010 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2010.FRA03/INERIS.REANALYSED.FRA03.2010.O3.daymax.2gis.nc")
O3_2011 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2011.FRA03/INERIS.REANALYSED.FRA03.2011.O3.daymax.2gis.nc")
O3_2012 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2012.FRA03/INERIS.REANALYSED.FRA03.2012.O3.daymax.2gis.nc")
O3_2013 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2013.FRA03/INERIS.REANALYSED.FRA03.2013.O3.daymax.2gis.nc")
O3_2014 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2014.FRA03/INERIS.REANALYSED.FRA03.2014.O3.daymax.2gis.nc")
O3_2015 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2015.FRA03/INERIS.REANALYSED.FRA03.2015.O3.daymax.2gis.nc")
O3_2016 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2016.FRA03/INERIS.REANALYSED.FRA03.2016.O3.daymax.2gis.nc")
O3_2017 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2017.FRA03/INERIS.REANALYSED.FRA03.2017.O3.daymax.2gis.nc")
O3_2018 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2018.FRA02/INERIS.REANALYSED.FRA02.2018.O3.daymax.2gis.nc")
O3_2019 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2019.FRA02/INERIS.REANALYSED.FRA02.2019.O3.daymax.2gis.nc")
O3_2020 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2020.FRA02/INERIS.REANALYSED.FRA02.2020.O3.daymax.2gis.nc")


# # #Align all rasters to a common grid. Harmonize spatial resolution using O3_2020 (2 km resolution from 2018 onward)
# This preserves as much information as possible.
# Most importantly, it makes all rasters interoperable (same grid).

O3_2000_resampled <- resample(O3_2000, O3_2020,method='ngb')
writeRaster(O3_2000_resampled,filename="3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2000_resampled.nc",format="CDF")

O3_2001_resampled <- resample(O3_2001, O3_2020,method='ngb')
writeRaster(O3_2001_resampled,filename="3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2001_resampled.nc",format="CDF")

O3_2002_resampled <- resample(O3_2002, O3_2020,method='ngb')
writeRaster(O3_2002_resampled,filename="3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2002_resampled.nc",format="CDF")

O3_2003_resampled <- resample(O3_2003, O3_2020,method='ngb')
writeRaster(O3_2003_resampled,filename="3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2003_resampled.nc",format="CDF")

O3_2004_resampled <- resample(O3_2004, O3_2020,method='ngb')
writeRaster(O3_2004_resampled,filename="3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2004_resampled.nc",format="CDF")

O3_2005_resampled <- resample(O3_2005, O3_2020,method='ngb')
writeRaster(O3_2005_resampled,filename="3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2005_resampled.nc",format="CDF")

O3_2006_resampled <- resample(O3_2006, O3_2020,method='ngb')
writeRaster(O3_2006_resampled,filename="3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2006_resampled.nc",format="CDF")

O3_2007_resampled <- resample(O3_2007, O3_2020,method='ngb')
writeRaster(O3_2007_resampled,filename="3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2007_resampled.nc",format="CDF")

O3_2008_resampled <- resample(O3_2008, O3_2020,method='ngb')
writeRaster(O3_2008_resampled,filename="3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2008_resampled.nc",format="CDF")

O3_2009_resampled <- resample(O3_2009, O3_2020,method='ngb')
writeRaster(O3_2009_resampled,filename="3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2009_resampled.nc",format="CDF")

O3_2010_resampled <- resample(O3_2010, O3_2020,method='ngb')
writeRaster(O3_2010_resampled,filename="3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2010_resampled.nc",format="CDF")

O3_2011_resampled <- resample(O3_2011, O3_2020,method='ngb')
writeRaster(O3_2011_resampled,filename="3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2011_resampled.nc",format="CDF")

O3_2012_resampled <- resample(O3_2012, O3_2020,method='ngb')
writeRaster(O3_2012_resampled,filename="3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2012_resampled.nc",format="CDF")

O3_2013_resampled <- resample(O3_2013, O3_2020,method='ngb')
writeRaster(O3_2013_resampled,filename="3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2013_resampled.nc",format="CDF")

O3_2014_resampled <- resample(O3_2014, O3_2020,method='ngb')
writeRaster(O3_2014_resampled,filename="3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2014_resampled.nc",format="CDF")

O3_2015_resampled <- resample(O3_2015, O3_2020,method='ngb')
writeRaster(O3_2015_resampled,filename="3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2015_resampled.nc",format="CDF")

O3_2016_resampled <- resample(O3_2016, O3_2020,method='ngb')
writeRaster(O3_2016_resampled,filename="3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2016_resampled.nc",format="CDF")

O3_2017_resampled <- resample(O3_2017, O3_2020,method='ngb')
writeRaster(O3_2017_resampled,filename="3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2017_resampled.nc",format="CDF")


# #Import spatio-temporal rasters previously processed to ensure a common spatial resolution
O3_2000 <- brick("3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2000_resampled.nc")
O3_2001 <- brick("3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2001_resampled.nc")
O3_2002 <- brick("3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2002_resampled.nc")
O3_2003 <- brick("3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2003_resampled.nc")
O3_2004 <- brick("3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2004_resampled.nc")
O3_2005 <- brick("3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2005_resampled.nc")
O3_2006 <- brick("3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2006_resampled.nc")
O3_2007 <- brick("3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2007_resampled.nc")
O3_2008 <- brick("3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2008_resampled.nc")
O3_2009 <- brick("3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2009_resampled.nc")
O3_2010 <- brick("3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2010_resampled.nc")
O3_2011 <- brick("3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2011_resampled.nc")
O3_2012 <- brick("3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2012_resampled.nc")
O3_2013 <- brick("3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2013_resampled.nc")
O3_2014 <- brick("3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2014_resampled.nc")
O3_2015 <- brick("3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2015_resampled.nc")
O3_2016 <- brick("3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2016_resampled.nc")
O3_2017 <- brick("3 Outputs/O3/Annee entiere/.Rasters alignes daymax/O3max_2017_resampled.nc")
O3_2018 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2018.FRA02/INERIS.REANALYSED.FRA02.2018.O3.daymax.2gis.nc")
O3_2019 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2019.FRA02/INERIS.REANALYSED.FRA02.2019.O3.daymax.2gis.nc")
O3_2020 <- brick("1 Donnees brutes/DAYLY_GRIDDED DATA 2000-2020/DailyGriddedData_2020.FRA02/INERIS.REANALYSED.FRA02.2020.O3.daymax.2gis.nc")


# Compute annual means
# Then we optionally save annual rasters as GeoTIFF (more convenient than NetCDF for QGIS viewing).
O3_average_2000 <- calc(O3_2000_resampled, fun = mean)
O3_average_2001 <- calc(O3_2001_resampled, fun = mean)
O3_average_2002 <- calc(O3_2002_resampled, fun = mean)
O3_average_2003 <- calc(O3_2003_resampled, fun = mean)
O3_average_2004 <- calc(O3_2004_resampled, fun = mean)
O3_average_2005 <- calc(O3_2005_resampled, fun = mean)
O3_average_2006 <- calc(O3_2006_resampled, fun = mean)
O3_average_2007 <- calc(O3_2007_resampled, fun = mean)
O3_average_2008 <- calc(O3_2008_resampled, fun = mean)
O3_average_2009 <- calc(O3_2009_resampled, fun = mean)
O3_average_2010 <- calc(O3_2010_resampled, fun = mean)
O3_average_2011 <- calc(O3_2011_resampled, fun = mean)
O3_average_2012 <- calc(O3_2012_resampled, fun = mean)
O3_average_2013 <- calc(O3_2013_resampled, fun = mean)
O3_average_2014 <- calc(O3_2014_resampled, fun = mean)
O3_average_2015 <- calc(O3_2015_resampled, fun = mean)
O3_average_2016 <- calc(O3_2016_resampled, fun = mean)
O3_average_2017 <- calc(O3_2017_resampled, fun = mean)
O3_average_2018 <- calc(O3_2018, fun = mean)
O3_average_2019 <- calc(O3_2019, fun = mean)
O3_average_2020 <- calc(O3_2020, fun = mean)

writeRaster(O3_average_2000, filename="3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2000.tif",format="GTiff")
writeRaster(O3_average_2001, filename="3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2001.tif",format="GTiff")
writeRaster(O3_average_2002, filename="3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2002.tif",format="GTiff")
writeRaster(O3_average_2003, filename="3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2003.tif",format="GTiff")
writeRaster(O3_average_2004, filename="3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2004.tif",format="GTiff")
writeRaster(O3_average_2005, filename="3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2005.tif",format="GTiff")
writeRaster(O3_average_2006, filename="3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2006.tif",format="GTiff")
writeRaster(O3_average_2007, filename="3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2007.tif",format="GTiff")
writeRaster(O3_average_2008, filename="3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2008.tif",format="GTiff")
writeRaster(O3_average_2009, filename="3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2009.tif",format="GTiff")
writeRaster(O3_average_2010, filename="3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2010.tif",format="GTiff")
writeRaster(O3_average_2011, filename="3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2011.tif",format="GTiff")
writeRaster(O3_average_2012, filename="3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2012.tif",format="GTiff")
writeRaster(O3_average_2013, filename="3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2013.tif",format="GTiff")
writeRaster(O3_average_2014, filename="3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2014.tif",format="GTiff")
writeRaster(O3_average_2015, filename="3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2015.tif",format="GTiff")
writeRaster(O3_average_2016, filename="3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2016.tif",format="GTiff")
writeRaster(O3_average_2017, filename="3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2017.tif",format="GTiff")
writeRaster(O3_average_2018, filename="3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2018.tif",format="GTiff")
writeRaster(O3_average_2019, filename="3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2019.tif",format="GTiff")
writeRaster(O3_average_2020, filename="3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2020.tif",format="GTiff")


#MUNICIPAL-LEVEL AGGREGATION STEP

#Load rasters of annual mean O3 concentrations
O3_average_2000 <- raster("3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2000.tif")
O3_average_2001 <- raster("3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2001.tif")
O3_average_2002 <- raster("3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2002.tif")
O3_average_2003 <- raster("3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2003.tif")
O3_average_2004 <- raster("3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2004.tif")
O3_average_2005 <- raster("3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2005.tif")
O3_average_2006 <- raster("3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2006.tif")
O3_average_2007 <- raster("3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2007.tif")
O3_average_2008 <- raster("3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2008.tif")
O3_average_2009 <- raster("3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2009.tif")
O3_average_2010 <- raster("3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2010.tif")
O3_average_2011 <- raster("3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2011.tif")
O3_average_2012 <- raster("3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2012.tif")
O3_average_2013 <- raster("3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2013.tif")
O3_average_2014 <- raster("3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2014.tif")
O3_average_2015 <- raster("3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2015.tif")
O3_average_2016 <- raster("3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2016.tif")
O3_average_2017 <- raster("3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2017.tif")
O3_average_2018 <- raster("3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2018.tif")
O3_average_2019 <- raster("3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2019.tif")
O3_average_2020 <- raster("3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_2020.tif")


#AGGREGATION AT MUNICIPAL LEVEL
# Load all rasters into a single list
raster_list <- lapply(2000:2020, function(year) {
  raster_file <- paste0("3 Outputs/O3/Annee entiere/Moyenne daymax/Rasters/O3_average_", year, ".tif")
  raster(raster_file)
})

# Fusionner les rasters en un seul raster stack
raster_stack <- stack(raster_list)

# Load municipality boundaries (EPSG:2154)
communes <- st_read("1 Donnees brutes/Contour communes/Shape Communes.shp")

# Reproject municipality layer to match the raster CRS
communes <- st_transform(communes, crs = st_crs(raster_stack))

#Extract values from all rasters at once
values_communes_O3 <- extract(raster_stack, communes)

communes_year <- communes

# Loop to compute the municipal mean for each year
for (year in 2000:2020) {
  nom_year <- paste0("O3_average_", formatC(year, width = 2, flag = "0"))
  donnees_year <- sapply(values_communes_O3, function(x) x[, nom_year])
  moyenne_par_commune <- sapply(donnees_year, mean, na.rm = TRUE)
  col_name <- paste0("O3_", formatC(year, width = 2, flag = "0"))
  communes_year[[col_name]] <- moyenne_par_commune
}

#Convert to a data.frame to compute the multi-year average
interannuel <- as.data.frame(cbind(communes_year[,c("INSEE_COM")] ,communes_year[, grepl("^O3_", names(communes_year))]))

# Identify the columns to keep (those that do not start with 'geometry')
indices_colonnes <- grep("^geometry", names(interannuel), invert = TRUE)
interannuel <- interannuel[, indices_colonnes]

#Compute multi-year average (2000-2020)
interannuel$O3_0020 <-rowMeans(interannuel[, grepl("^O3_", names(interannuel))], na.rm = TRUE)

#Compute multi-year average (2009-2020)
interannuel$O3_0920 <- rowMeans (interannuel[, c(11:22)], na.rm = TRUE)

communes_year<- merge(communes_year, interannuel[, c("INSEE_COM", "O3_0020","O3_0920")], by = "INSEE_COM")

# Write output shapefile with all columns for each year
st_write(communes_year, "3 Outputs/O3/Annee entiere/Moyenne daymax/O3_Moyenne.shp")

