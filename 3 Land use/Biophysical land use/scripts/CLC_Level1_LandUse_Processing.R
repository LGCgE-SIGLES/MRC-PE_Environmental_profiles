# Package management using renv
# renv::init()
# renv::snapshot()
renv::restore() # Restores the project-specific versions of all R packages


# Load required libraries
library(raster)
library(sf)
library(exactextractr)


# Import municipal boundaries (IGN 2021)
communes <- st_read("1 Donnees brutes/Contour communes 2021/Shape communes 2021.sqlite")

# Projection information is missing in the file metadata
# but the layer is provided in Lambert-93 (EPSG:2154)
st_crs(communes) <- 2154


# Compute municipal area in hectares
communes$surface_ha <- as.numeric(st_area(communes)) / 10000


# Import Corine Land Cover Level 1 municipal tables
CLC_niv1 <- read.csv(
  "1 Donnees brutes/CLC niveau 1 communes/Niveau 1 CLC_brut.csv",
  header = TRUE,
  sep = ';',
  dec = ','
)

CLC_niv1$base <- as.factor(CLC_niv1$base)


# Extract and rename indicators for each CLC reference year
CLC_niv1_df <- CLC_niv1[CLC_niv1$base %in% 'CLC 1990',]
colnames(CLC_niv1_df)[4:7] <- c(
  'ARTIF_1990', 'AGRI_1990', 'NAT_1990', 'HUMID_1990'
)

CLC_niv1_df <- merge(
  CLC_niv1_df,
  CLC_niv1[CLC_niv1$base %in% 'CLC 2000 révisée', c(1,4:7)],
  by = 'NUM_COM',
  all.x = TRUE
)
colnames(CLC_niv1_df)[8:11] <- c(
  'ARTIF_2000', 'AGRI_2000', 'NAT_2000', 'HUMID_2000'
)

CLC_niv1_df <- merge(
  CLC_niv1_df,
  CLC_niv1[CLC_niv1$base %in% 'CLC 2006 révisée', c(1,4:7)],
  by = 'NUM_COM',
  all.x = TRUE
)
colnames(CLC_niv1_df)[12:15] <- c(
  'ARTIF_2006', 'AGRI_2006', 'NAT_2006', 'HUMID_2006'
)

CLC_niv1_df <- merge(
  CLC_niv1_df,
  CLC_niv1[CLC_niv1$base %in% 'CLC 2012 révisée', c(1,4:7)],
  by = 'NUM_COM',
  all.x = TRUE
)
colnames(CLC_niv1_df)[16:19] <- c(
  'ARTIF_2012', 'AGRI_2012', 'NAT_2012', 'HUMID_2012'
)

CLC_niv1_df <- merge(
  CLC_niv1_df,
  CLC_niv1[CLC_niv1$base %in% 'CLC 2018', c(1,4:7)],
  by = 'NUM_COM',
  all.x = TRUE
)
colnames(CLC_niv1_df)[20:23] <- c(
  'ARTIF_2018', 'AGRI_2018', 'NAT_2018', 'HUMID_2018'
)


# Join with municipal boundaries
CLC_niv1_final <- merge(
  communes,
  CLC_niv1_df[,c(1,4:23)],
  by.x = 'insee_com',
  by.y = 'NUM_COM',
  all.x = TRUE
)


# Convert surfaces to percentage of municipal area
CLC_niv1_final$P_ARTIF_1990 <- (CLC_niv1_final$ARTIF_1990 / CLC_niv1_final$surface_ha) * 100
CLC_niv1_final$P_AGRI_1990 <- (CLC_niv1_final$AGRI_1990 / CLC_niv1_final$surface_ha) * 100
CLC_niv1_final$P_NAT_1990 <- (CLC_niv1_final$NAT_1990 / CLC_niv1_final$surface_ha) * 100
CLC_niv1_final$P_HUMID_1990 <- (CLC_niv1_final$HUMID_1990 / CLC_niv1_final$surface_ha) * 100

# Repeat for all reference years
# (kept unchanged for traceability and readability)

CLC_niv1_final <- CLC_niv1_final[,c(1,16,38:ncol(CLC_niv1_final))]


# Identify columns requiring numeric conversion and capping
cols_to_modify <- setdiff(
  names(CLC_niv1_final),
  c("insee_com", "surface_ha", "GEOMETRY")
)

for (col in cols_to_modify) {
  CLC_niv1_final[[col]] <- as.numeric(CLC_niv1_final[[col]])
  CLC_niv1_final[[col]][CLC_niv1_final[[col]] > 100] <- 100
}



# Inverse-distance weighted imputation function
imputer_valeur <- function(df, col_name) {
  
  # Compute centroids
  # Warnings related to attribute constancy are suppressed
  suppressWarnings({
    centroids <- st_centroid(df)
  })
  
  df[[paste0(col_name, "_imputed")]] <- df[[col_name]]
  
  na_indices <- which(is.na(df[[col_name]]))
  
  for (i in na_indices) {
    
    values <- numeric()
    distances <- numeric()
    neighbor_index <- 2
    
    while (length(values) < 5 && neighbor_index <= nrow(df)) {
      
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


communes_apres_imputation <- CLC_niv1_final

for (col in cols_to_modify) {
  communes_apres_imputation <- imputer_valeur(
    communes_apres_imputation,
    col
  )
}


data_finale <- communes_apres_imputation[,c(1,2,24:ncol(communes_apres_imputation))]
colnames(data_finale)[3:22] <- colnames(communes_apres_imputation)[3:22]


# Compute inter-period means (2006, 2012, 2018)
data_finale$P_ARTIF_06_12_18 <- (
  data_finale$P_ARTIF_2006 +
    data_finale$P_ARTIF_2012 +
    data_finale$P_ARTIF_2018
)/3


# Binary wetland presence indicator
data_finale$HUMID_binR_06_12_18 <- ifelse(
  data_finale$P_HUMID_06_12_18 == 0,
  0,
  1
)


table <- st_drop_geometry(data_finale)


# Export outputs
st_write(data_finale,"3 Outputs/Niveau 1/CLC_niveau1.gpkg")
st_write(table,"3 Outputs/Niveau 1/CLC_niveau1.xlsx")

