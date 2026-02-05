# Vegetation indicators – NDVI (Santé publique France)

## 1. Data source overview

Indicators included in the MRC-PE dataset were partly derived from vegetation data produced by Santé publique France (SPF) in the framework of environmental health research.

Vegetation abundance was characterised using the Normalized Difference Vegetation Index (NDVI), a satellite-derived indicator widely used to describe vegetation density and photosynthetic activity. NDVI values range from −1 to 1 and are calculated from the difference in reflectance between near-infrared and red wavelengths.

NDVI indicators correspond to average summer vegetation levels (June to August) calculated annually over the 2000–2018 period.

Data were initially produced at the IRIS level (sub-municipal statistical units) and subsequently aggregated to the municipal scale.

Further details on data production and the broader analytical framework are provided in Adélaïde et al. (2024).

These data are not openly accessible but are available upon reasonable request from the data producers. 

## 2. Indicators derived from this data source

SPF NDVI data were used to construct municipal-level indicators describing vegetation abundance and relative vegetation deficit.

The indicators included in the MRC-PE dataset are:

- NDVI_2000_2018: average summer NDVI over the 2000–2018 period  

- DiffNDVI_2000_2018: difference between average summer NDVI and a climate-specific reference value  

- BelowNDVI_2000_2018: binary indicator equal to 1 when average summer NDVI is below the reference value  

Reference NDVI values were defined by Santé publique France as the median summer NDVI observed in rural areas within each climate type. These reference thresholds therefore vary spatially according to climatic context.

Inter-annual correlation analyses indicated strong temporal stability in NDVI spatial distribution, supporting the use of multi-year averages as representative indicators.

## 3. Data processing and indicator construction

Processing was implemented in R through three successive scripts:

- 1_NDVI_Extraction_and_Annual_Assembly: extraction of yearly municipal NDVI tables and consolidation into a single database for 2000–2018  

- 2_NDVI_Harmonization_IGN2021_Boundaries: harmonisation of municipal identifiers to the IGN 2021 framework and preparation of the municipal dataset used in MRC-PE  

- 3_NDVI_MissingData_Imputation_and_FinalIndicators: correction of missing or anomalous values, recalculation of binary indicators, and computation of 2000–2018 averages  

Data cleaning includes a specific adjustment for Lyon, where source values are provided at arrondissement level and municipal values are reconstructed using arrondissement means.

Missing values associated with anomalous placeholder values were corrected through temporal imputation using adjacent years.

## 4. Limitations and points of attention

NDVI is a proxy indicator describing vegetation presence and density but does not provide information on vegetation accessibility, land use or public availability of green spaces.

## References

Adélaïde, L., Hough, I., Seyve, E., Kloog, I., Fifre, G., Launoy, G., Launay, L., Pascal, M., Lepeule, J., 2024. Environmental and social inequities in continental France: an analysis of exposure to heat, air pollution, and lack of vegetation. Journal of Exposure Science and Environmental Epidemiology. https://doi.org/10.1038/s41370-024-00641-6
