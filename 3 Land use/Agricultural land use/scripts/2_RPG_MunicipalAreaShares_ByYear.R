# Script 2 — Convert annual crop areas (ha) into shares of municipal area (%)
# Objective:
# - Merge harmonised annual RPG tables into one multi-year table.
# - Join municipal surface area (ha) from IGN 2021 boundaries.
# - Convert crop areas (ha) to % of municipal area for each year.

# Package management with renv
# renv::init()
# renv::snapshot()
renv::restore()

# Load required libraries
library(dplyr)
library(sf)
library(readxl)
library(purrr)
library(stringr)

# Load harmonised annual tables (areas in hectares by crop group)
RPG_2007 <- read_excel("3 Outputs/2 RPG final/Surfaces RPG final/RPG_2007.xlsx")
RPG_2008 <- read_excel("3 Outputs/2 RPG final/Surfaces RPG final/RPG_2008.xlsx")
RPG_2009 <- read_excel("3 Outputs/2 RPG final/Surfaces RPG final/RPG_2009.xlsx")
RPG_2010 <- read_excel("3 Outputs/2 RPG final/Surfaces RPG final/RPG_2010.xlsx")
RPG_2011 <- read_excel("3 Outputs/2 RPG final/Surfaces RPG final/RPG_2011.xlsx")
RPG_2012 <- read_excel("3 Outputs/2 RPG final/Surfaces RPG final/RPG_2012.xlsx")
RPG_2013 <- read_excel("3 Outputs/2 RPG final/Surfaces RPG final/RPG_2013.xlsx")
RPG_2014 <- read_excel("3 Outputs/2 RPG final/Surfaces RPG final/RPG_2014.xlsx")
RPG_2015 <- read_excel("3 Outputs/2 RPG final/Surfaces RPG final/RPG_2015.xlsx")
RPG_2016 <- read_excel("3 Outputs/2 RPG final/Surfaces RPG final/RPG_2016.xlsx")
RPG_2017 <- read_excel("3 Outputs/2 RPG final/Surfaces RPG final/RPG_2017.xlsx")
RPG_2018 <- read_excel("3 Outputs/2 RPG final/Surfaces RPG final/RPG_2018.xlsx")
RPG_2019 <- read_excel("3 Outputs/2 RPG final/Surfaces RPG final/RPG_2019.xlsx")
RPG_2020 <- read_excel("3 Outputs/2 RPG final/Surfaces RPG final/RPG_2020.xlsx")
RPG_2021 <- read_excel("3 Outputs/2 RPG final/Surfaces RPG final/RPG_2021.xlsx")
RPG_2022 <- read_excel("3 Outputs/2 RPG final/Surfaces RPG final/RPG_2022.xlsx")

# Build a named list of annual datasets
datasets <- list(
  "2007" = RPG_2007,
  "2008" = RPG_2008,
  "2009" = RPG_2009,
  "2010" = RPG_2010,
  "2011" = RPG_2011,
  "2012" = RPG_2012,
  "2013" = RPG_2013,
  "2014" = RPG_2014,
  "2015" = RPG_2015,
  "2016" = RPG_2016,
  "2017" = RPG_2017,
  "2018" = RPG_2018,
  "2019" = RPG_2019,
  "2020" = RPG_2020,
  "2021" = RPG_2021,
  "2022" = RPG_2022
)

# Robust fix for INSEE codes:
# - keep alphanumeric codes,
# - trim whitespace,
# - left-pad numeric codes to 5 characters (e.g., "1234" -> "01234")
datasets <- lapply(datasets, function(data) {
  data <- data %>%
    mutate(
      INSEE_COM = str_trim(as.character(INSEE_COM)),
      INSEE_COM = ifelse(
        nchar(INSEE_COM) < 5,
        str_pad(INSEE_COM, width = 5, side = "left", pad = "0"),
        INSEE_COM
      )
    )
  return(data)
})

# Load municipal boundaries (IGN 2021) and compute municipal area (ha)
communes <- st_read("1 Donnees brutes/Contour communes 2021/Shape communes 2021.sqlite")
st_crs(communes) <- 2154
communes$surf_com_ha <- as.numeric(st_area(communes)) / 10000

# Add the year suffix to each crop column, then merge all years into one wide table
merged_data <- datasets %>%
  imap(function(df, year) {
    df %>%
      rename_with(~ paste0(., "_", year), -c(NOM, INSEE_COM))
  }) %>%
  reduce(full_join, by = c("NOM", "INSEE_COM"))

# Join municipal surface (ha)
merged_data <- merge(
  merged_data,
  st_drop_geometry(communes[, c("insee_com", "surf_com_ha")]),
  by.x = "INSEE_COM",
  by.y = "insee_com",
  all.x = TRUE
)

# Convert crop areas (ha) into % of municipal area for selected crop groups
cols_to_convert <- colnames(merged_data)[grepl(
  "^(AUTRES_CEREALES|AUTRES_OLEAGINX|BLE|CEREALES|COLZA|CULT_INDUST|DIVERS|ESTIVES_LANDES|FIBRES|FOURRAGE|FRUITS_COQUES|JACHERE|LEGUMES_FLEURS|LEGUMINEUSES_GRAINS|MAIS|OLEAGINX|OLIVIERS|ORGE|PRAIRIES|PRAIRIES_PERM|PRAIRIES_TEMP|PROTEAGINX|RIZ|TOURNESOL|VERGERS|VIGNES)",
  colnames(merged_data)
)]

merged_data <- merged_data %>%
  mutate(across(all_of(cols_to_convert), ~ . / surf_com_ha * 100, .names = "{.col}_perc"))

# Keep only percentage columns (plus identifiers)
merged_data <- merged_data[, c(1, 2, 420:834)]

# Cap potential rounding / overlay artefacts above 100%
merged_data[, -c(1, 2)] <- lapply(merged_data[, -c(1, 2)], function(x) ifelse(x > 100, 100, x))

# Export the annual municipal shares table
st_write(merged_data, "3 Outputs/2 RPG final/% RPG final/RPG_perc_par_annee.xlsx", driver = "xlsx")

 