# Package management using renv
# renv::init()
# renv::snapshot()
renv::restore() # Restores the project-specific versions of all R packages


# Load required libraries
library(raster)
library(sf)
library(exactextractr)


# Import municipal boundaries (IGN 2021)
communes <- st_read(
  "1 Donnees brutes/Contour communes 2021/Shape communes 2021.sqlite"
)

# Projection metadata is missing in the source file
# but the dataset is provided in Lambert-93 (EPSG:2154)
st_crs(communes) <- 2154


# Compute municipal area in hectares
communes$surface_ha <- as.numeric(st_area(communes)) / 10000


# Import Corine Land Cover Level 2 municipal tables
CLC_niv1 <- read.csv(
  "1 Donnees brutes/CLC niveau 2 communes/CLC_niv2_brut.csv",
  header = TRUE,
  sep = ';',
  dec = ','
)

CLC_niv1$base <- as.factor(CLC_niv1$base)


# Extract and rename indicators for each CLC reference year
CLC_niv1_df <- CLC_niv1[CLC_niv1$base %in% 'CLC 1990',]
colnames(CLC_niv1_df)[4:5] <- c(
  'INDUST_1990',
  'MINE_1990'
)


CLC_niv1_df <- merge(
  CLC_niv1_df,
  CLC_niv1[CLC_niv1$base %in% 'CLC 2000 révisée', c(1,4:5)],
  by = 'NUM_COM',
  all.x = TRUE
)
colnames(CLC_niv1_df)[6:7] <- c(
  'INDUST_2000',
  'MINE_2000'
)


CLC_niv1_df <- merge(
  CLC_niv1_df,
  CLC_niv1[CLC_niv1$base %in% 'CLC 2006 révisée', c(1,4:5)],
  by = 'NUM_COM',
  all.x = TRUE
)
colnames(CLC_niv1_df)[8:9] <- c(
  'INDUST_2006',
  'MINE_2006'
)


CLC_niv1_df <- merge(
  CLC_niv1_df,
  CLC_niv1[CLC_niv1$base %in% 'CLC 2012 révisée', c(1,4:5)],
  by = 'NUM_COM',
  all.x = TRUE
)
colnames(CLC_niv1_df)[10:11] <- c(
  'INDUST_2012',
  'MINE_2012'
)


CLC_niv1_df <- merge(
  CLC_niv1_df,
  CLC_niv1[CLC_niv1$base %in% 'CLC 2018', c(1,4:5)],
  by = 'NUM_COM',
  all.x = TRUE
)
colnames(CLC_niv1_df)[12:13] <- c(
  'INDUST_2018',
  'MINE_2018'
)


# Join indicators with municipal boundaries
CLC_niv1_final <- merge(
  communes,
  CLC_niv1_df[,c(1,4:13)],
  by.x = 'insee_com',
  by.y = 'NUM_COM',
  all.x = TRUE
)


# Convert surfaces to percentage of municipal area
CLC_niv1_final$P_INDUST_1990 <- (
  CLC_niv1_final$INDUST_1990 /
    CLC_niv1_final$surface_ha
) * 100

CLC_niv1_final$P_MINE_1990 <- (
  CLC_niv1_final$MINE_1990 /
    CLC_niv1_final$surface_ha
) * 100


CLC_niv1_final$P_INDUST_2000 <- (
  CLC_niv1_final$INDUST_2000 /
    CLC_niv1_final$surface_ha
) * 100

CLC_niv1_final$P_MINE_2000 <- (
  CLC_niv1_final$MINE_2000 /
    CLC_niv1_final$surface_ha
) * 100


CLC_niv1_final$P_INDUST_2006 <- (
  CLC_niv1_final$INDUST_2006 /
    CLC_niv1_final$surface_ha
) * 100

CLC_niv1_final$P_MINE_2006 <- (
  CLC_niv1_final$MINE_2006 /
    CLC_niv1_final$surface_ha
) * 100


CLC_niv1_final$P_INDUST_2012 <- (
  CLC_niv1_final$INDUST_2012 /
    CLC_niv1_final$surface_ha
) * 100

CLC_niv1_final$P_MINE_2012 <- (
  CLC_niv1_final$MINE_2012 /
    CLC_niv1_final$surface_ha
) * 100


CLC_niv1_final$P_INDUST_2018 <- (
  CLC_niv1_final$INDUST_2018 /
    CLC_niv1_final$surface_ha
) * 100

CLC_niv1_final$P_MINE_2018 <- (
  CLC_niv1_final$MINE_2018 /
    CLC_niv1_final$surface_ha
) * 100


CLC_niv1_final <- CLC_niv1_final[,c(1,16,27:ncol(CLC_niv1_final))]



# Inverse-distance weighted imputation function
imputer_valeur <- function(df, col_name) {
  
  # Compute centroids
  # Warnings related to attribute constancy are suppressed
  suppressWarnings({
    centroids <- st_centroid(df)
  })
  
  # Initialize imputed column
  df[[paste0(col_name, "_imputed")]] <- df[[col_name]]
  
  # Identify missing values
  na_indices <- which(is.na(df[[col_name]]))
  
  for (i in na_indices) {
    
    values <- numeric()
    distances <- numeric()
    neighbor_index <- 2
    
    while (length(values) < 5 &&
           neighbor_index <= nrow(df)) {
      
      distances_all <- st_distance(
        centroids[i,],
        centroids
      )[1,]
      
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
      
      df[[paste0(col_name, "_imputed")]][i] <-
        sum(values * weights)
    }
  }
  
  df
}


communes_apres_imputation <- CLC_niv1_final


# Identify columns requiring imputation
cols_to_modify <- setdiff(
  names(CLC_niv1_final),
  c("insee_com", "surface_ha", "GEOMETRY")
)


for (col in cols_to_modify) {
  communes_apres_imputation <-
    imputer_valeur(
      communes_apres_imputation,
      col
    )
}


data_finale <- communes_apres_imputation[
  ,c(1,2,3,14:ncol(communes_apres_imputation))
]

colnames(data_finale)[4:13] <-
  colnames(communes_apres_imputation)[4:13]



# Combined industrial + extraction indicators
data_finale$P_INDUST_MINE_1990 <-
  data_finale$P_INDUST_1990 +
  data_finale$P_MINE_1990

data_finale$P_INDUST_MINE_2000 <-
  data_finale$P_INDUST_2000 +
  data_finale$P_MINE_2000

data_finale$P_INDUST_MINE_2006 <-
  data_finale$P_INDUST_2006 +
  data_finale$P_MINE_2006

data_finale$P_INDUST_MINE_2012 <-
  data_finale$P_INDUST_2012 +
  data_finale$P_MINE_2012

data_finale$P_INDUST_MINE_2018 <-
  data_finale$P_INDUST_2018 +
  data_finale$P_MINE_2018



# Inter-annual means (2006, 2012, 2018)
data_finale$P_INDUST_06_12_18 <-
  (data_finale$P_INDUST_2006 +
     data_finale$P_INDUST_2012 +
     data_finale$P_INDUST_2018) / 3

data_finale$P_MINE_06_12_18 <-
  (data_finale$P_MINE_2006 +
     data_finale$P_MINE_2012 +
     data_finale$P_MINE_2018) / 3

data_finale$P_INDUST_MINE_06_12_18 <-
  (data_finale$P_INDUST_MINE_2006 +
     data_finale$P_INDUST_MINE_2012 +
     data_finale$P_INDUST_MINE_2018) / 3



# Binary presence indicators
data_finale$INDUST_binR_06_12_18 <-
  ifelse(data_finale$P_INDUST_06_12_18 == 0, 0, 1)

data_finale$MINE_binR_06_12_18 <-
  ifelse(data_finale$P_MINE_06_12_18 == 0, 0, 1)

data_finale$INDUST_MINE_binR_06_12_18 <-
  ifelse(data_finale$P_INDUST_MINE_06_12_18 == 0, 0, 1)



table <- st_drop_geometry(data_finale)


# Export outputs
st_write(
  data_finale,
  "3 Outputs/Niveau 2/CLC_niveau2.gpkg"
)

st_write(
  table,
  "3 Outputs/Niveau 2/CLC_niveau2.xlsx"
)
