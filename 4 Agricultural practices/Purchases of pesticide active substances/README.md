# Pesticide active substances purchase indicators – BNVD



## 1. Data source overview



Indicators included in the MRC-PE dataset were derived from the Banque Nationale des Ventes de produits phytopharmaceutiques (BNVD), a French national database reporting purchases/sales of plant protection products and quantities of active substances.



For this work, we used the BNVD “Achat” extract geocoded at the buyer’s postal code ("code postal de l’acheteur") over 2013–2021. Following the methodological notice distributed with the dataset, years 2013 and 2014 were considered non-representative for this extract and were excluded; the analysis therefore focuses on 2015–2021.



The raw extract contains 19 fields, including:



* ANNEE (year of purchase),

* CODE_POSTAL (buyer postal code),

* SUBSTANCE (active substance name),

* QUANTITE_SUBSTANCE (quantity of active substance purchased),

* SEGMENT (use segment),

* FONCTION (substance function),

* CMR (CMR category: CMR1 / CMR2 / non-CMR),

* UAB (authorised in organic farming: yes/no),

&nbsp; as well as additional administrative descriptors (region, department, municipality) and flags (e.g. purchases abroad).



## 2. Indicators derived from this data source



BNVD data were used to construct territorial indicators of purchases of active substances, expressed as purchase intensity per unit area (kg/ha per year) and provided at the municipal level in the final MRC-PE dataset.



Indicators cover the period 2015–2021 (annual values) and are released as an average over 2015–2021 in the MRC-PE dataset (see the dataset documentation on Recherche Data Gouv for the authoritative metadata).



Twenty indicators were constructed to characterise different dimensions of plant protection product purchases, with a specific focus on substances intended for agricultural use. Indicators distinguish overall purchases, agricultural versus non-agricultural uses, major functional classes, organic authorisation status, and CMR categories.



A detailed list of indicator definitions and units is provided in the dataset documentation on Recherche Data Gouv.



## 3. Data processing and indicator construction



### General processing logic



Processing was implemented as a three-step workflow:



1. Raw data cleaning and aggregation at the postal code level, including exclusion of non-representative years, correction of postal-code formatting issues, and aggregation of quantities of active substances by year and postal code for different subsets of interest (use segment, function, organic authorisation, CMR category).



2. Spatial normalisation and treatment of missing values at the postal code level, including normalisation by polygon area to obtain purchase intensity (kg/ha) and imputation of remaining missing values using a distance-based approach relying on neighbouring postal codes.



3. Spatial transfer from postal codes to municipalities using area-weighted allocation based on polygon intersections, resulting in municipal-level indicators.



Detailed calculation steps and parameter choices are documented directly in the R scripts provided in this repository.



### Scripts



The workflow is implemented in the following scripts (in this folder):



* 1_processing_bnvd_data.R — raw BNVD cleaning, subsetting, annual aggregation, and export at postal-code level

* 2_imputation_missing_values.R — area normalisation at postal-code level and missing-value diagnostics and imputation

* 3_conversion_postal_codes_municipalities.R — spatial transfer from postal codes to municipalities (area-weighted)



### Software implementation



All processing steps were implemented in R using standard spatial analysis libraries.



## 4. Limitations and points of attention



BNVD data describe purchases rather than actual applications and should therefore be interpreted as proxies of potential agricultural pressure.



Spatial allocation from postal codes to municipalities relies on polygon-based spatial overlays and area-weighted allocation, which may introduce uncertainty, particularly in areas with heterogeneous land use.



Indicators are intended for comparative and exploratory analyses and should not be interpreted as direct measures of pesticide use.
