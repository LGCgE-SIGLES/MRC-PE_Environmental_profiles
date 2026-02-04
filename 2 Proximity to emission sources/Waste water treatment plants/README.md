# Wastewater treatment plants proximity indicators – Collective sanitation portal (France)

## 1. Data source overview

Indicators included in the MRC-PE dataset were derived from the French collective sanitation portal (Portail sur l’assainissement collectif), a national information system describing wastewater treatment plants (WWTPs) in France. The database is managed by public authorities and provides geolocated information on wastewater treatment facilities.

The database includes, for each wastewater treatment plant, information on geographical location, technical characteristics, and administrative descriptors. Facilities are reported as point locations.

For the MRC-PE project, the database was downloaded in 2022. As systematic historical archiving is not available, the data reflect the state of registered wastewater treatment plants at the time of data extraction.

## 2. Indicators derived from this data source

Data from the collective sanitation portal were used to construct a municipal-level indicator describing proximity to wastewater treatment plants. The indicator aims to characterise potential environmental pressure related to wastewater treatment activities in residential environments and is provided at the municipality level in the final MRC-PE dataset.

A single indicator was produced:
- a kernel density–based proximity indicator combining all wastewater treatment plants, without weighting.

The complete definition of the indicator, including temporal coverage and units, is provided in the dataset documentation on Recherche Data Gouv.

## 3. Data processing and indicator construction

### General processing logic

The construction of the proximity indicator followed a spatial workflow identical to that used for classified industrial facilities (S3IC) and contaminated sites (CASIAS).

First, geolocated wastewater treatment plants were extracted from the collective sanitation portal database. All facilities were included and treated homogeneously, without weighting by size, capacity, or operational characteristics. Facilities were treated as point sources.

Second, proximity was modelled using a kernel density estimation (KDE) approach (Wand and Jones 1994; Baddeley et al. 2015). KDE is a spatial smoothing method that transforms a set of point locations into a continuous surface representing the intensity of their presence in space. Each facility contributes to its surrounding environment within a predefined spatial neighbourhood, with an influence that decreases progressively with distance and becomes negligible beyond a given threshold.

In this application, a radius of 4 km was used to define the spatial influence of wastewater treatment plants, in line with methodological choices adopted by INERIS and Santé publique France for the assessment of potential impacts around industrial and environmental facilities (INERIS 2021, 2025). An Epanechnikov kernel function was used. At any given location, KDE values are higher when surrounding facilities are more numerous and closer, and lower when they are fewer or more distant. The resulting surface can be interpreted as a measure of potential proximity to wastewater treatment plants rather than a direct measure of emissions or exposure.

KDE values were computed on a regular spatial grid with a resolution of 1 km × 1 km and subsequently aggregated at the municipal level by calculating the mean value of grid cells intersecting each municipality.

### Software implementation

All processing steps were implemented using standard GIS tools, primarily QGIS. These steps included spatial filtering of facilities, kernel density estimation, raster processing, and aggregation of results at the municipal level. No dedicated R scripts were required for this data source.

## 4. Limitations and points of attention

These indicators should be interpreted as territorial proxies.

Facilities were treated homogeneously, without weighting by size or capacity. As a result, the indicator reflects spatial proximity to wastewater treatment plants rather than the intensity of wastewater treatment activity. Alternative approaches could consider weighting facilities by capacity or load.

Due to the lack of systematic historical archiving, indicators reflect a snapshot of facilities at the time of data extraction and do not capture changes over time.

KDE-based proximity indicators rely on simplifying assumptions regarding spatial influence and do not account for physical dispersion processes, characteristics of discharge points, or pollutant-specific behaviour.

Indicators are intended for comparative and exploratory analyses.

## References

Baddeley A, Rubak E, Turner R (2015) Spatial Point Patterns: Methodology and Applications with R. Chapman and Hall/CRC, New York.

INERIS (2021) Etude des distances d’impact – Règle de Stern | Ineris.

INERIS (2025) Bassins Industriels et Santé (BIS) | Ineris.

Wand MP, Jones MC (1994) Kernel Smoothing. Chapman and Hall/CRC, New York.
