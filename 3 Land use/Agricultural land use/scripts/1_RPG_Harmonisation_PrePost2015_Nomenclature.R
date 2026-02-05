# Script 1 — RPG harmonisation (pre-2015 vs post-2015 nomenclature)
# Objective:
# - Harmonise crop categories over time despite the 2015 break in RPG nomenclature.
# - For 2007–2014 (pre-2015): apply small recodings to make crop-group codes consistent across years.
# - For 2015–2022 (post-2015): convert detailed crop codes into pre-2015 crop groups using an equivalence table.

# Package management with renv
# renv::init()
# renv::snapshot()
renv::restore()  # Restore exact package versions used in the project

# Load required libraries
library(sf)
library(dplyr)
library(tidyr)

# Step 1 — Pre-2015 years (2007–2014): small harmonisations across annual crop-group tables
# Notes:
# - In 2007/2008/2009, fallow/set-aside is split across codes 11/12/13.
# - From 2009 to 2014, fallow is consolidated under a single code (legacy naming differences across files).
# - To ensure comparability, we consolidate all fallow categories under one code (X11).
# - “Arboriculture” (code 27) is merged into “Orchards” (code 20) based on later nomenclatures.
# - “Sugar cane” (code 26) appears sporadically in mainland France (2011, 2012, 2014): removed as marginal.
# - “Seeds” (code 10) is removed because post-2015 it is reallocated across crop groups; pre-2015 cannot be reallocated.

# Load all pre-2015 annual municipal tables delivered by the provider
RPG_2007 <- read.csv("1 Donnees brutes/Livraison wavestone/Avant 2015/2007/2007_Aires_Cultures_France.csv", sep=",", dec=".")
RPG_2008 <- read.csv("1 Donnees brutes/Livraison wavestone/Avant 2015/2008/2008_Aires_Cultures_France.csv", sep=",", dec=".")
RPG_2009 <- read.csv("1 Donnees brutes/Livraison wavestone/Avant 2015/2009/2009_Aires_Cultures_France.csv", sep=",", dec=".")
RPG_2010 <- read.csv("1 Donnees brutes/Livraison wavestone/Avant 2015/2010/2010_Aires_Cultures_France.csv", sep=",", dec=".")
RPG_2011 <- read.csv("1 Donnees brutes/Livraison wavestone/Avant 2015/2011/2011_Aires_Cultures_France.csv", sep=",", dec=".")
RPG_2012 <- read.csv("1 Donnees brutes/Livraison wavestone/Avant 2015/2012/2012_Aires_Cultures_France.csv", sep=",", dec=".")
RPG_2013 <- read.csv("1 Donnees brutes/Livraison wavestone/Avant 2015/2013/2013_Aires_Cultures_France.csv", sep=",", dec=".")
RPG_2014 <- read.csv("1 Donnees brutes/Livraison wavestone/Avant 2015/2014/2014_Aires_Cultures_France.csv", sep=",", dec=".")

# Consolidate fallow/set-aside codes for 2007–2009: X11 <- X11 + X12 + X13, then remove X12/X13
RPG_2007$X11 <- (RPG_2007$X11 + RPG_2007$X12 + RPG_2007$X13)
RPG_2007 <- RPG_2007[, !names(RPG_2007) %in% c("X12", "X13")]

RPG_2008$X11 <- (RPG_2008$X11 + RPG_2008$X12 + RPG_2008$X13)
RPG_2008 <- RPG_2008[, !names(RPG_2008) %in% c("X12", "X13")]

RPG_2009$X11 <- (RPG_2009$X11 + RPG_2009$X12 + RPG_2009$X13)
RPG_2009 <- RPG_2009[, !names(RPG_2009) %in% c("X12", "X13")]

# In some later files, the consolidated fallow variable is already present but under a different column name.
# The following lines rename the corresponding column to "X11" so that all years share the same convention.
colnames(RPG_2010)[12] <- "X11"
colnames(RPG_2011)[5]  <- "X11"
colnames(RPG_2012)[15] <- "X11"
colnames(RPG_2013)[16] <- "X11"
colnames(RPG_2014)[13] <- "X11"

# Merge “arboriculture” (X27) into “orchards” (X20), then drop X27
RPG_2007$X20 <- (RPG_2007$X20 + RPG_2007$X27); RPG_2007 <- RPG_2007[, !names(RPG_2007) %in% c("X27")]
RPG_2008$X20 <- (RPG_2008$X20 + RPG_2008$X27); RPG_2008 <- RPG_2008[, !names(RPG_2008) %in% c("X27")]
RPG_2009$X20 <- (RPG_2009$X20 + RPG_2009$X27); RPG_2009 <- RPG_2009[, !names(RPG_2009) %in% c("X27")]
RPG_2010$X20 <- (RPG_2010$X20 + RPG_2010$X27); RPG_2010 <- RPG_2010[, !names(RPG_2010) %in% c("X27")]
RPG_2011$X20 <- (RPG_2011$X20 + RPG_2011$X27); RPG_2011 <- RPG_2011[, !names(RPG_2011) %in% c("X27")]
RPG_2012$X20 <- (RPG_2012$X20 + RPG_2012$X27); RPG_2012 <- RPG_2012[, !names(RPG_2012) %in% c("X27")]
RPG_2013$X20 <- (RPG_2013$X20 + RPG_2013$X27); RPG_2013 <- RPG_2013[, !names(RPG_2013) %in% c("X27")]
RPG_2014$X20 <- (RPG_2014$X20 + RPG_2014$X27); RPG_2014 <- RPG_2014[, !names(RPG_2014) %in% c("X27")]

# Remove “sugar cane” (X26) from years where it appears
RPG_2011 <- RPG_2011[, !names(RPG_2011) %in% c("X26")]
RPG_2012 <- RPG_2012[, !names(RPG_2012) %in% c("X26")]
RPG_2014 <- RPG_2014[, !names(RPG_2014) %in% c("X26")]

# Remove “seeds” (X10) from all pre-2015 years
RPG_2007 <- RPG_2007[, !names(RPG_2007) %in% c("X10")]
RPG_2008 <- RPG_2008[, !names(RPG_2008) %in% c("X10")]
RPG_2009 <- RPG_2009[, !names(RPG_2009) %in% c("X10")]
RPG_2010 <- RPG_2010[, !names(RPG_2010) %in% c("X10")]
RPG_2011 <- RPG_2011[, !names(RPG_2011) %in% c("X10")]
RPG_2012 <- RPG_2012[, !names(RPG_2012) %in% c("X10")]
RPG_2013 <- RPG_2013[, !names(RPG_2013) %in% c("X10")]
RPG_2014 <- RPG_2014[, !names(RPG_2014) %in% c("X10")]

# Export harmonised pre-2015 datasets
st_write(RPG_2007, "3 Outputs/1 RPG harmonisé/RPG_2007.xlsx")
st_write(RPG_2008, "3 Outputs/1 RPG harmonisé/RPG_2008.xlsx")
st_write(RPG_2009, "3 Outputs/1 RPG harmonisé/RPG_2009.xlsx")
st_write(RPG_2010, "3 Outputs/1 RPG harmonisé/RPG_2010.xlsx")
st_write(RPG_2011, "3 Outputs/1 RPG harmonisé/RPG_2011.xlsx")
st_write(RPG_2012, "3 Outputs/1 RPG harmonisé/RPG_2012.xlsx")
st_write(RPG_2013, "3 Outputs/1 RPG harmonisé/RPG_2013.xlsx")
st_write(RPG_2014, "3 Outputs/1 RPG harmonisé/RPG_2014.xlsx")

# Step 2 — Post-2015 years (2015–2022): convert detailed crop codes to pre-2015 crop groups
# Load post-2015 municipal tables (areas by detailed crop codes)
RPG_2015 <- read.csv("1 Donnees brutes/Livraison wavestone/Après 2015/2015/2015_Aires_Cultures_France.csv", sep=",", dec=".")
RPG_2016 <- read.csv("1 Donnees brutes/Livraison wavestone/Après 2015/2016/2016_Aires_Cultures_France.csv", sep=",", dec=".")
RPG_2017 <- read.csv("1 Donnees brutes/Livraison wavestone/Après 2015/2017/2017_Aires_Cultures_France.csv", sep=",", dec=".")
RPG_2018 <- read.csv("1 Donnees brutes/Livraison wavestone/Après 2015/2018/2018_Aires_Cultures_France.csv", sep=",", dec=".")
RPG_2019 <- read.csv("1 Donnees brutes/Livraison wavestone/Après 2015/2019/2019_Aires_Cultures_France.csv", sep=",", dec=".")
RPG_2020 <- read.csv("1 Donnees brutes/Livraison wavestone/Après 2015/2020/2020_Aires_Cultures_France.csv", sep=",", dec=".")
RPG_2021 <- read.csv("1 Donnees brutes/Livraison wavestone/Après 2015/2021/2021_Aires_Cultures_France.csv", sep=",", dec=".")
RPG_2022 <- read.csv("1 Donnees brutes/Livraison wavestone/Après 2015/2022/2022_Aires_Cultures_France.csv", sep=",", dec=".")

# Load the equivalence table: detailed crop codes (post-2015) -> crop-group codes (pre-2015)
Equivalence <- read.csv("1 Donnees brutes/Equivalence RPG 2015/Table passage nomenclature 2015.csv", sep=";", dec=",")

# Store datasets in a named list for iteration
datasets <- list(
  "2015" = RPG_2015,
  "2016" = RPG_2016,
  "2017" = RPG_2017,
  "2018" = RPG_2018,
  "2019" = RPG_2019,
  "2020" = RPG_2020,
  "2021" = RPG_2021,
  "2022" = RPG_2022
)

results <- list()

# For each year:
# - reshape wide->long (one row per municipality x crop code),
# - attach the pre-2015 crop-group code,
# - aggregate area by municipality x crop group,
# - reshape long->wide (one column per crop group),
# - export the harmonised annual table.
for (year in names(datasets)) {
  RPG <- datasets[[year]]
  
  RPG_long <- RPG %>%
    pivot_longer(
      cols = -c(NOM, INSEE_COM),
      names_to = "CODE_CULTURE",
      values_to = "SURFACE_HA"
    ) %>%
    left_join(Equivalence, by = c("CODE_CULTURE" = "CODE_APRES_2015")) %>%
    group_by(NOM, INSEE_COM, CODE_AVANT_2015) %>%
    summarise(SURFACE_TOTALE = sum(SURFACE_HA, na.rm = TRUE), .groups = "drop") %>%
    pivot_wider(
      names_from = CODE_AVANT_2015,
      values_from = SURFACE_TOTALE,
      values_fill = 0
    )
  
  results[[year]] <- RPG_long
  
  output_path <- paste0("3 Outputs/1 RPG harmonisé/RPG_", year, ".xlsx")
  st_write(RPG_long, output_path)
}
