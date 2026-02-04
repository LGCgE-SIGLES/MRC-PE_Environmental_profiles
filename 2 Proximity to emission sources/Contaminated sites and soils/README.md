# Contaminated sites proximity indicators – CASIAS (France)

## 1. Data source overview

Indicators included in the MRC-PE dataset were derived from the CASIAS database (Carte des Anciens Sites Industriels et Activités de Service), a national inventory of former industrial and service sites in France. The database is managed by public authorities and provides geolocated information on sites where past industrial or service activities may have resulted in soil and groundwater contamination.

The CASIAS database includes, for each site, information on geographical location, type of former activity, and administrative characteristics. CASIAS primarily documents historical sites, including sites that are no longer in operation.

For the MRC-PE project, the CASIAS database was downloaded in 2024. As systematic historical archiving is not available, the data reflect the state of the inventory at the time of data extraction.

## 2. Indicators derived from this data source

CASIAS data were used to construct a municipal-level indicator describing proximity to polluted sites and soils. The indicator aims to characterise potential environmental pressure related to historical industrial and service activities in residential environments and is provided at the municipality level in the final MRC-PE dataset.

A single indicator was produced:

* a kernel density–based proximity indicator combining all CASIAS sites without weighting.

The complete definition of the indicator, including temporal coverage and units, is provided in the dataset documentation on Recherche Data Gouv.

## 3. Data processing and indicator construction

### General processing logic

The construction of the proximity indicator followed a spatial workflow.

First, geolocated CASIAS sites were extracted from the database. All sites were included without weighting by activity type or administrative status. Sites were treated as point sources.

Second, proximity was modelled using a kernel density estimation (KDE) approach (Wand and Jones 1994; Baddeley et al. 2015). KDE is a spatial smoothing method that transforms a set of point locations into a continuous surface representing the intensity of their presence in space. Each site contributes to its surrounding environment within a predefined spatial neighbourhood, with an influence that decreases progressively with distance and becomes negligible beyond a given threshold.

In this application, a radius of 4 km was used to define the spatial influence of sites, in line with methodological choices adopted by INERIS and Santé publique France for the assessment of potential impacts around industrial activities (INERIS 2021, 2025). An Epanechnikov kernel function was used. At any given location, KDE values are higher when surrounding sites are more numerous and closer, and lower when they are fewer or more distant. The resulting surface can be interpreted as a measure of potential proximity to polluted sites and soils rather than a direct measure of contamination or exposure.

KDE values were computed on a regular spatial grid with a resolution of 1 km × 1 km and subsequently aggregated at the municipal level by calculating the mean value of grid cells intersecting each municipality.

### Software implementation

All processing steps were implemented using standard GIS tools, primarily QGIS. These steps included spatial filtering of sites, kernel density estimation, raster processing, and aggregation of results at the municipal level. No dedicated R scripts were required for this data source.

## 4. Limitations and points of attention

These indicators should be interpreted as territorial proxies rather than direct measures of exposure.

CASIAS is an inventory of former sites. The presence of a site does not imply current industrial activity, nor does it provide information on actual contamination levels, remediation status, or current land use.

Due to the lack of systematic historical archiving, indicators reflect a snapshot of the inventory at the time of data extraction and do not capture changes over time.

KDE-based proximity indicators rely on simplifying assumptions regarding spatial influence and do not account for physical dispersion processes, prevailing winds, topography, or pollutant-specific characteristics.

Indicators are intended for comparative and exploratory analyses.

## References

Baddeley A, Rubak E, Turner R (2015) Spatial Point Patterns: Methodology and Applications with R. Chapman and Hall/CRC, New York.

INERIS (2021) Etude des distances d’impact – Règle de Stern | Ineris.

INERIS (2025) Bassins Industriels et Santé (BIS) | Ineris.

Wand MP, Jones MC (1994) Kernel Smoothing. Chapman and Hall/CRC, New York.
