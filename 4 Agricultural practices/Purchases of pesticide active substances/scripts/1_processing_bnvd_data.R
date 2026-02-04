# Package management with renv
# renv::init()
# renv::snapshot()
renv::restore() # Restores the correct versions of all packages used in the RStudio project

library(writexl)
library(dplyr)

BNVD_brute <- read.csv(file ="1 Donnees brutes/BNVD Achat Substances 2013-2021.csv",header = TRUE, dec = ".",sep=";",fileEncoding = "UTF-8")

# Rename columns using the short header (instead of the detailed header)
colnames(BNVD_brute) <- BNVD_brute[1,]
# Remove the first row (it contains the column names)
BNVD_brute <- BNVD_brute[-1,]

# Exclude years 2013 and 2014
BNVD_1521 <- subset(BNVD_brute, subset= !( BNVD_brute$ANNEE %in% c('2013','2014')))

# Exclude rows where the buyer's postal code is missing
BNVD_1521 <- subset(BNVD_1521, subset= !( BNVD_1521$CODE_POSTAL %in% c('0')))

# Exclude rows where the purchased quantity is missing
BNVD_1521 <- subset(BNVD_1521, subset= !( BNVD_1521$QUANTITE_SUBSTANCE %in% c('')))

# For postal codes in departments 01–09, a leading 0 is missing in the raw data
# Fix this issue
BNVD_1521$CODE_POSTAL <- ifelse(nchar(BNVD_1521$CODE_POSTAL) == 4,
                         paste0("0", BNVD_1521$CODE_POSTAL),
                         BNVD_1521$CODE_POSTAL)


# Convert selected fields to factors
BNVD_1521$ANNEE <- as.factor(BNVD_1521$ANNEE)
BNVD_1521$SUBSTANCE <- as.factor(BNVD_1521$SUBSTANCE)
BNVD_1521$FONCTION <- as.factor(BNVD_1521$FONCTION)
BNVD_1521$CMR <- as.factor(BNVD_1521$CMR)
BNVD_1521$SEGMENT <- as.factor(BNVD_1521$SEGMENT)
BNVD_1521$UAB <- as.factor(BNVD_1521$UAB)
BNVD_1521$CODE_POSTAL <- as.factor(BNVD_1521$CODE_POSTAL)


# Convert QUANTITE_SUBSTANCE to numeric
BNVD_1521$QUANTITE_SUBSTANCE <- as.numeric(BNVD_1521$QUANTITE_SUBSTANCE)

# Explore how substances are distributed by function, segment, CMR category, etc.
resultat <- BNVD_1521 %>%
  group_by(FONCTION) %>%
  summarise(nombre_substances = n_distinct(SUBSTANCE))

resultat <- BNVD_1521 %>%
  group_by(SEGMENT) %>%
  summarise(nombre_substances = n_distinct(SUBSTANCE))

resultat <- BNVD_1521 %>%
  group_by(CMR) %>%
  summarise(nombre_substances = n_distinct(SUBSTANCE))


resultat <- BNVD_1521 %>%
  group_by(FONCTION) %>%
  summarise(somme_substances = round(sum(QUANTITE_SUBSTANCE)))

resultat <- BNVD_1521 %>%
  group_by(SEGMENT) %>%
  summarise(somme_substances = round(sum(QUANTITE_SUBSTANCE)))

resultat <- BNVD_1521 %>%
  group_by(CMR) %>%
  summarise(somme_substances = round(sum(QUANTITE_SUBSTANCE)))


# It is therefore important to filter by use type
# Filter using the 'SEGMENT' field
UA <- subset(BNVD_1521, subset = BNVD_1521$SEGMENT %in% c('UA','UAZNA'))
BIOC <- subset(BNVD_1521, subset = BNVD_1521$SEGMENT %in% c('BIO','BIOEAJ'))
UNA <- subset(BNVD_1521, subset = BNVD_1521$SEGMENT %in% c('ZNA','ZNAA'))

# Then, focusing on agricultural use
# Filter substances according to whether they are authorised in organic farming (AB)
UA_nonAB <- subset(UA, subset = UA$UAB %in% c('false'))
UA_AB <- subset(UA, subset = UA$UAB %in% c('true'))

# Still focusing on agricultural use
# Filter substances by function
FONG_UA <- subset(UA, subset = UA$FONCTION %in% c('Fongicide'))
HERB_UA <- subset(UA, subset = UA$FONCTION %in% c('Herbicide'))
INSECT_UA <- subset(UA, subset = UA$FONCTION %in% c('Insecticide'))
CROISS_UA <- subset(UA, subset = UA$FONCTION %in% c('Régulateur de croissance'))
MOLLUSC_UA <- subset(UA, subset = UA$FONCTION %in% c('Molluscicide'))
ADJUV_UA <- subset(UA, subset = UA$FONCTION %in% c('SAnonPhyto Coformulant & Adjuvant'))


# Similarly, for each function, split substances by whether they are authorised in organic farming (AB)
FONG_UA_nonAB <- subset(FONG_UA, subset = FONG_UA$UAB %in% c('false'))
FONG_UA_AB <- subset(FONG_UA, subset = FONG_UA$UAB %in% c('true'))
# HERB_UA_nonAB <- subset(HERB_UA, subset = HERB_UA$UAB %in% c('false'))
# HERB_UA_AB <- subset(HERB_UA, subset = HERB_UA$UAB %in% c('true'))
INSECT_UA_nonAB <- subset(INSECT_UA, subset = INSECT_UA$UAB %in% c('false'))
INSECT_UA_AB <- subset(INSECT_UA, subset = INSECT_UA$UAB %in% c('true'))
# CROISS_UA_nonAB <- subset(CROISS_UA, subset = CROISS_UA$UAB %in% c('false'))
# CROISS_UA_AB <- subset(CROISS_UA, subset = CROISS_UA$UAB %in% c('true'))
# MOLLUSC_nonAB <- subset(MOLLUSC_UA, subset = MOLLUSC_UA$UAB %in% c('false'))
# MOLLUSC_UA_AB <- subset(MOLLUSC_UA, subset = MOLLUSC_UA$UAB %in% c('true'))
# ADJUV_UA_nonAB <- subset(ADJUV_UA, subset = ADJUV_UA$UAB %in% c('false'))
# ADJUV_UA_AB <- subset(ADJUV_UA, subset = ADJUV_UA$UAB %in% c('true'))


# Still focusing on agricultural use
# Filter substances by CMR classification
CMR1_UA <- subset(UA, subset = UA$CMR %in% c('CMR1'))
CMR2_UA <- subset(UA, subset = UA$CMR %in% c('CMR2'))
CMR_UA <- subset(UA, subset = UA$CMR %in% c('CMR1','CMR2'))
nonCMR_UA <- subset(UA, subset = !(UA$CMR %in% c('CMR1','CMR2')))


# Finally, compute all indicators on an annual basis.
# Pivot table by year and postal code.

# Create a function that takes a dataframe as input,
# performs aggregation and summation, and returns the transformed dataframe
process_dataframe <- function(df) {
  # Compute the sum of QUANTITE_SUBSTANCE by CODE_POSTAL and ANNEE
  aggregated_df <- aggregate(QUANTITE_SUBSTANCE ~ CODE_POSTAL + ANNEE, data = df, sum)
  
  # Reshape so that years become columns
  resultat <- xtabs(QUANTITE_SUBSTANCE ~ CODE_POSTAL + ANNEE, data = aggregated_df)
  
  # Convert the contingency table to a dataframe
  resultat_df <- as.data.frame.matrix(resultat)
  
  # Add CODE_POSTAL as a column
  resultat_df$CODE_POSTAL <- rownames(resultat_df)
  rownames(resultat_df) <- NULL
  
  # Reorder columns to put CODE_POSTAL first
  resultat_df <- resultat_df[, c("CODE_POSTAL", setdiff(names(resultat_df), "CODE_POSTAL"))]
  
  return(resultat_df)
}


dataframes <- list(ADJUV_UA, BIOC, BNVD_1521, CMR1_UA, CMR2_UA, CMR_UA, nonCMR_UA, CROISS_UA, FONG_UA, FONG_UA_AB, FONG_UA_nonAB, HERB_UA, 
                   INSECT_UA, INSECT_UA_AB, INSECT_UA_nonAB, MOLLUSC_UA, UA, UA_AB, UA_nonAB, UNA)

noms <- c("ADJUV_UA", "BIOC", "BNVD_1521","CMR1_UA", "CMR2_UA", "CMR_UA", "nonCMR_UA","CROISS_UA", "FONG_UA", "FONG_UA_AB", "FONG_UA_nonAB", 
          "HERB_UA", "INSECT_UA", "INSECT_UA_AB", "INSECT_UA_nonAB", "MOLLUSC_UA", "UA", "UA_AB", 
          "UA_nonAB", "UNA")

resultats <- lapply(dataframes, process_dataframe)
names(resultats) <- noms

# Export each dataframe to a separate Excel sheet
write_xlsx(resultats, path = "3 Outputs/Indicateurs Code Postal/Avec NA/Resultats_indicateurs_cdepostal.xlsx")