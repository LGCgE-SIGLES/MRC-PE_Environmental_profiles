# Soil contamination indicators – RMQS

## 1. Data source overview

Soil contamination indicators included in the MRC-PE dataset were derived from data produced within the French Soil Quality Monitoring Network (Réseau de Mesure de la Qualité des Sols, RMQS). The RMQS is a national monitoring program designed to characterize soil properties and contamination levels across metropolitan France using a harmonized sampling strategy.

The first RMQS sampling campaign was conducted between 2000 and 2009 and is based on a systematic grid of approximately 16 km × 16 km, resulting in 2,240 sampling sites evenly distributed over the national territory. At each site, soil samples were collected and analyzed using standardized protocols. In the MRC-PE project, analyses focus on topsoil horizons (0–30 cm), which are considered the most relevant for potential human exposure.

RMQS data provide measurements for two main families of contaminants:
- trace metals and metalloids (TM), including both total concentrations and, for a subset of elements, extractable concentrations intended to better reflect the mobile and potentially bioavailable fraction;
- polycyclic aromatic hydrocarbons (PAHs), for which total concentrations are provided as the sum of 15 individual compounds.

Because RMQS measurements are spatially discrete, continuous concentration maps were produced prior to the MRC-PE project using spatial interpolation and prediction models. For trace metals, these models combine observed concentrations with environmental covariates such as land use, topography and climate, using regression-based spatial prediction approaches (Saby et al., 2023). For PAHs, a specific geostatistical modeling framework was developed to account for strong spatial heterogeneity and the presence of localized extreme values, particularly in historically industrialized areas (Froger et al., 2021).

The resulting interpolated concentration maps are provided at a spatial resolution of 1 km × 1 km and represent long-term average soil contamination patterns. These maps constitute the input data used to derive soil contamination indicators in the MRC-PE dataset.

## 2. Indicators derived from this data source

RMQS data were used to derive municipal-level indicators describing concentrations of:
- trace metals (total and/or extractable concentrations), and
- polycyclic aromatic hydrocarbons (PAHs; sum of 15 compounds).

The detailed list of indicator names, definitions, units and temporal coverage is provided in the dataset documentation on Recherche Data Gouv and is not repeated here. For reference, RMQS-based indicators in MRC-PE include:
- total concentrations (mg/kg) for As, Cd, Co, Cr, Cu, Hg, Mo, Ni, Pb, Zn and Tl,
- extractable concentrations (mg/kg) for Cd, Cr, Cu, Ni, Pb and Zn,
- total PAH content (sum of 15 PAHs; µg/kg).

Temporal coverage reflects the RMQS sampling campaigns (mainly 2001–2009 for metals; 2000–2010 for PAHs).

## 3. Data processing and indicator construction

### General processing logic

Indicator construction follows a stepwise logic that is reflected in the numbering of the scripts provided in this repository:

1. Raster preprocessing and aggregation to municipalities (municipal means)
2. Handling of a first subset of missing values (metals only) using coarser-resolution rasters
3. Imputation of remaining missing values using a neighbour-based, distance-weighted approach

Scripts are numbered accordingly (`1_`, `2_`, `3_`). Steps 2 and 3 reuse intermediate outputs produced in step 1 and are therefore not intended to be executed independently.

### Spatial aggregation to municipalities

For each contaminant raster, values were aggregated to the municipal level by extracting raster cell values intersecting each municipality and computing the mean value per municipality. In practice, the workflow uses exact extraction options to account for partial overlaps between raster cells and municipal boundaries, and then computes municipality-level means.

### Missing-value handling and imputation

Metals:
- A first missing-value handling step uses additional RMQS rasters at 16 km resolution to fill specific gaps, notably where 1 km rasters do not provide coverage and in some border areas. Coarser rasters are not available for all metals (e.g., cobalt and molybdenum are not covered in the 16 km products used here).
- Remaining missing values are then imputed using an inverse-distance weighted approach based on the nearest municipalities with non-missing values (up to five neighbours).

PAHs:
- PAH indicators follow the same general logic (municipal aggregation, then imputation), without the intermediate 16 km filling step.

## 4. Limitations and points of attention

Soil contamination indicators derived from RMQS data should be interpreted with caution, taking into account several methodological and conceptual limitations related to the nature of the data and the processing steps involved.

First, RMQS measurements are based on a single national sampling campaign conducted between 2000 and 2009. As a result, temporal variability cannot be assessed. The resulting indicators should therefore be interpreted as representing long-term or historical contamination patterns. This limitation is partially mitigated by the fact that many soil contaminants, particularly trace metals, exhibit high persistence and slow temporal dynamics.

Several studies have shown that concentrations of trace metals in soils tend to vary only slightly over periods of several decades. For example, comparisons of soil surveys conducted nearly twenty years apart have reported limited changes for most metals, supporting the interpretation of RMQS-based indicators as markers of long-term contamination (Wang et al., 2023).

For polycyclic aromatic hydrocarbons (PAHs), although degradation processes may occur, elevated concentrations observed in certain regions are largely associated with historical industrial and combustion-related emissions, particularly from the late nineteenth to mid-twentieth century. In this context, PAH concentrations derived from RMQS data primarily reflect legacy pollution rather than recent emissions.

Third, the indicators rely on spatial interpolation models developed from point measurements. Although these models were evaluated and validated in previous studies, their accuracy may be lower in certain contexts, especially in highly heterogeneous environments such as urban or industrial areas, where contamination gradients can be very localized.

In addition, total concentrations of trace metals reflect both anthropogenic inputs and natural background levels linked to the geochemical composition of parent materials. This is particularly relevant for elements such as arsenic, chromium or nickel. When available, extractable concentrations provide a more relevant approximation of the mobile and potentially bioavailable fraction of metals, but they remain indirect proxies of actual exposure.

Finally, it should be emphasized that these soil contamination indicators are designed for comparative spatial analyses at the national scale. They are suitable for identifying broad spatial patterns and contrasting environmental contexts between territories, but they are not intended for site-specific risk assessment.

## References

Froger C, Saby NPA, Jolivet CC, et al (2021) Spatial variations, origins, and risk assessments of polycyclic aromatic hydrocarbons in French soils. SOIL 7:161–178. https://doi.org/10.5194/soil-7-161-2021

Saby N (2023) Prédictions spatialisées des distributions des éléments As, Cd, Co, Cr, Cu, Hg, Ni, Mo, Pb, Tl, Zn dans les sols de France à partir du RMQS

Wang C-C, Zhang Q-C, Yan C-A, et al (2023a) Heavy metal(loid)s in agriculture soils, rice, and wheat across China: Status assessment and spatiotemporal analysis. Sci Total Environ 882:163361. https://doi.org/10.1016/j.scitotenv.2023.163361
