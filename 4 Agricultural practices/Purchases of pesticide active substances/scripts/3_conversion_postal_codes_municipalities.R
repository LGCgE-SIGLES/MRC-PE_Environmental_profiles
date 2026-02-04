# Package management with renv
# renv::init()
#renv::snapshot()
renv::restore() # Restores the correct versions of all packages used in the RStudio project


library(writexl)
library(dplyr)
library(readxl)
library(sf)


# Load postal-code polygons with indicators (after NA imputation)
Code_postx <- st_read("3 Outputs/Indicateurs Code Postal/Sans NA/Resultats_indicateurs_cdepostal.sqlite")

# Make geometries valid
Code_postx <- st_make_valid(Code_postx)


# Extract all indicators (with imputed NAs)
Code_postx_indicateurs <- st_drop_geometry(Code_postx)
Code_postx_indicateurs <- Code_postx_indicateurs[,c(1,7:ncol(Code_postx_indicateurs))]
Code_postx_indicateurs <- Code_postx_indicateurs[,c(1,142:281)]

Code_postx <- merge(Code_postx[,c(1)],Code_postx_indicateurs,by='id')




# Load IGN municipal boundaries (2021). CRS not set in file but corresponds to Lambert-93
Communes <- st_read("1 Donnees brutes/Contour communes 2021/Shape communes 2021.sqlite")
Communes <- st_set_crs(Communes, 2154)

# Make geometries valid
Communes <- st_make_valid(Communes)



# Missing-value handling (inverse-distance weighted mean using the five nearest neighbours)
# Perform spatial intersection between postal codes and municipalities
intersection <- st_intersection(Code_postx, Communes)

# Compute intersection areas
intersection <- intersection %>%
  mutate(surface_intersection = st_area(geometry)) %>%
  st_drop_geometry()

intersection$surface_intersection <- as.numeric(intersection$surface_intersection)


# Compute area-weighted means for each indicator and each municipality
result <- intersection %>%
  group_by(insee_com) %>%
  summarise(across(contains("imputed"), ~ sum(.x * surface_intersection) / sum(surface_intersection), .names = "{.col}"))


RESULTAT <- merge(Communes,result, by = 'insee_com')

# Save the result
st_write(RESULTAT, "3 Outputs/2016-2022/Donnees finales communes/BinR/BdD BinR finale communes.sqlite")


# Perform spatial intersection between postal codes and municipalities
intersection <- st_intersection(Code_postx, Communes)

# Compute intersection areas
intersection <- intersection %>%
  mutate(surface_intersection = st_area(geometry)) %>%
  st_drop_geometry()

intersection$surface_intersection <- as.numeric(intersection$surface_intersection)


# Compute area-weighted means for each indicator and each municipality
result <- intersection %>%
  group_by(insee_com) %>%
  summarise(across(contains("imputed"), ~ sum(.x * surface_intersection) / sum(surface_intersection), .names = "{.col}"))


RESULTAT <- merge(Communes,result, by = 'insee_com')

# Save the result
st_write(RESULTAT, "3 Outputs/Indicateurs Communes/Resultats_indicateurs_communes.sqlite")

# Also export to Excel
RESULTATS_excel <- st_drop_geometry(RESULTAT)

# Save the dataframe to an Excel file
write_xlsx(RESULTATS_excel, "3 Outputs/Indicateurs Communes/Resultats_indicateurs_communes.xlsx")