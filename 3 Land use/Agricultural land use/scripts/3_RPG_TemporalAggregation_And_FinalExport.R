# Script 3 — Temporal aggregation (2009–2021 averages) and final export
# Objective:
# - Starting from annual municipal shares (%), compute multi-year averages (2009–2021).
# - Create aggregated indicators by crop group (one column per crop category).
# - Export a table and a spatial file joined to IGN 2021 municipal boundaries.

# Package management with renv
# renv::init()
# renv::snapshot()
renv::restore()

# Load required libraries
library(dplyr)
library(tidyr)
library(sf)
library(readxl)
library(purrr)
library(stringr)

# Load annual percentage table (already filtered to the 2009–2021 window)
data <- read_excel("3 Outputs/2 RPG final/% RPG final/RPG_perc_09_21.xlsx")

# Sort columns alphabetically (after identifiers)
sorted_data <- data %>%
  select(INSEE_COM, NOM, sort(colnames(data)[-(1:2)]))

# Compute row-wise means over years for each crop category
# Note: column index ranges correspond to the expected block structure in the input file.
averages <- sorted_data %>%
  mutate(
    AUTRES_CEREALES = rowMeans(select(., 3:15), na.rm = TRUE),
    AUTRES_OLEAGINX = rowMeans(select(., 16:28), na.rm = TRUE),
    BLE            = rowMeans(select(., 29:41), na.rm = TRUE),
    CEREALES       = rowMeans(select(., 42:54), na.rm = TRUE),
    COLZA          = rowMeans(select(., 55:67), na.rm = TRUE),
    CULT_INDUST    = rowMeans(select(., 68:80), na.rm = TRUE),
    DIVERS         = rowMeans(select(., 81:93), na.rm = TRUE),
    ESTIVES_LANDES = rowMeans(select(., 94:106), na.rm = TRUE),
    FIBRES         = rowMeans(select(., 107:119), na.rm = TRUE),
    FOURRAGE       = rowMeans(select(., 120:132), na.rm = TRUE),
    FRUITS_COQUES  = rowMeans(select(., 133:145), na.rm = TRUE),
    JACHERE        = rowMeans(select(., 146:158), na.rm = TRUE),
    LEGUMES_FLEURS = rowMeans(select(., 159:171), na.rm = TRUE),
    LEGUMINEUSES_GRAINS = rowMeans(select(., 172:184), na.rm = TRUE),
    MAIS           = rowMeans(select(., 185:197), na.rm = TRUE),
    OLEAGINX       = rowMeans(select(., 198:210), na.rm = TRUE),
    OLIVIERS       = rowMeans(select(., 211:223), na.rm = TRUE),
    ORGE           = rowMeans(select(., 224:236), na.rm = TRUE),
    PRAIRIES       = rowMeans(select(., 237:249), na.rm = TRUE),
    PRAIRIES_PERM  = rowMeans(select(., 250:262), na.rm = TRUE),
    PRAIRIES_TEMP  = rowMeans(select(., 263:275), na.rm = TRUE),
    PROTEAGINX     = rowMeans(select(., 276:288), na.rm = TRUE),
    RIZ            = rowMeans(select(., 289:301), na.rm = TRUE),
    TOURNESOL      = rowMeans(select(., 302:314), na.rm = TRUE),
    VERGERS        = rowMeans(select(., 315:327), na.rm = TRUE),
    VIGNES         = rowMeans(select(., 328:340), na.rm = TRUE)
  ) %>%
  select(
    INSEE_COM, NOM,
    AUTRES_CEREALES, AUTRES_OLEAGINX, BLE, CEREALES, COLZA, CULT_INDUST,
    DIVERS, ESTIVES_LANDES, FIBRES, FOURRAGE, FRUITS_COQUES, JACHERE,
    LEGUMES_FLEURS, LEGUMINEUSES_GRAINS, MAIS, OLEAGINX, OLIVIERS, ORGE,
    PRAIRIES, PRAIRIES_PERM, PRAIRIES_TEMP, PROTEAGINX, RIZ, TOURNESOL,
    VERGERS, VIGNES
  )

# Join to IGN 2021 municipal boundaries for GIS export
communes <- st_read("1 Donnees brutes/Contour communes 2021/Shape communes 2021.sqlite")
st_crs(communes) <- 2154

merged_data <- merge(communes, averages[, c(1, 3:28)], by.y = "INSEE_COM", by.x = "insee_com", all.x = TRUE)

# Export final outputs
st_write(averages, "4 Résultat final/RPG_perc_moy_09_21.xlsx", driver = "xlsx")
st_write(merged_data, "4 Résultat final/RPG_perc_moy_09_21.gpkg", driver = "gpkg")
