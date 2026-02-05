# Package management with renv
# renv::init()
# renv::snapshot()
renv::restore() # Restores the project-specific versions of all R packages used in the RStudio project

library(writexl)
library(dplyr)
library(sf)
library(openxlsx)

# Import municipal boundaries (IGN 2021)
Communes <- st_read("1 Donnees brutes/Contour communes 2021/Shape communes 2021.sqlite")

# Set CRS (Lambert-93, EPSG:2154)
Communes <- st_set_crs(Communes, 2154)

# Compute municipal area in hectares
Communes$surface_communale <- as.numeric(st_area(Communes) / 10000)


# Import livestock counts (Livestock Units)
Nb_UGB <- read.csv2(
  "3 Outputs/1 Contour Communes MRCPE/UGB - Contour Communes MRC-PE.CSV",
  header = TRUE,
  sep = ";",
  dec = ","
)

# Join livestock data to municipal layer
Communes_UGB_avec_NA <- merge(
  Communes,
  Nb_UGB[,c(1,11,12)],
  by = 'insee_com',
  all.x = TRUE
) 

# Compute livestock density (LU per hectare)
Communes_UGB_avec_NA$UGB_ha_2010 <- ifelse(
  is.na(Communes_UGB_avec_NA$Nb_UGB_2010) |
    is.na(Communes_UGB_avec_NA$surface_communale),
  NA,
  Communes_UGB_avec_NA$Nb_UGB_2010 /
    Communes_UGB_avec_NA$surface_communale
)

Communes_UGB_avec_NA$UGB_ha_2020 <- ifelse(
  is.na(Communes_UGB_avec_NA$Nb_UGB_2020) |
    is.na(Communes_UGB_avec_NA$surface_communale),
  NA,
  Communes_UGB_avec_NA$Nb_UGB_2020 /
    Communes_UGB_avec_NA$surface_communale
)


# Assess temporal stability before aggregation
# Pearson correlation
cor_pearson <- cor(
  Communes_UGB_avec_NA$UGB_ha_2020,
  Communes_UGB_avec_NA$UGB_ha_2010,
  use = "complete.obs",
  method = "pearson"
)

# Spearman correlation
cor_spearman <- cor(
  Communes_UGB_avec_NA$UGB_ha_2020,
  Communes_UGB_avec_NA$UGB_ha_2010,
  use = "complete.obs",
  method = "spearman"
)


# Compute inter-census mean (2010–2020)
Communes_UGB_avec_NA$UGB_ha_2010_2020 <-
  rowMeans(
    cbind(
      Communes_UGB_avec_NA$UGB_ha_2010,
      Communes_UGB_avec_NA$UGB_ha_2020
    ),
    na.rm = TRUE
  )


# Missing-value imputation
noms_colonnes <- 'UGB_ha_2010_2020'


# Inverse-distance weighted imputation function
imputer_valeur <- function(df, col_name) {
  
  suppressWarnings({
    centroids <- st_centroid(df) 
  })
  
  suppressWarnings({
    centroids <- st_centroid(df)
  })
  
  df[[paste0(col_name, "_imputed")]] <- df[[col_name]]
  
  na_indices <- which(is.na(df[[col_name]]))
  
  for (i in na_indices) {
    
    values <- numeric()
    distances <- numeric()
    neighbor_index <- 2
    
    while (length(values) < 5 &&
           neighbor_index <= nrow(df)) {
      
      distances_all <- st_distance(centroids[i,], centroids)[1,]
      current_index <- order(distances_all)[neighbor_index]
      current_value <- df[[col_name]][current_index]
      
      if (!is.na(current_value)) {
        values <- c(values, current_value)
        distances <- c(distances, distances_all[current_index])
      }
      
      neighbor_index <- neighbor_index + 1
    }
    
    if (length(values) > 0) {
      weights <- 1 / as.numeric(distances)
      weights <- weights / sum(weights)
      df[[paste0(col_name, "_imputed")]][i] <- sum(values * weights)
    }
  }
  
  df
}


Communes_UGB_sans_NA <- Communes_UGB_avec_NA

for (col_name in noms_colonnes) {
  Communes_UGB_sans_NA <-
    imputer_valeur(Communes_UGB_sans_NA, col_name)
}


# Export spreadsheet
Communes_UGB_sans_NA_table <-
  st_drop_geometry(Communes_UGB_sans_NA)

write.xlsx(
  Communes_UGB_sans_NA_table,
  "3 Outputs/2 Indicateurs rapportés à la surface/UGB apres imputation.xlsx"
)

# Export spatial format
st_write(
  Communes_UGB_sans_NA,
  "3 Outputs/2 Indicateurs rapportés à la surface/UGB apres imputation.sqlite"
)
