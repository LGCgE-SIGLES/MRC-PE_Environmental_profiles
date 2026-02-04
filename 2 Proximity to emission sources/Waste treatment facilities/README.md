# Waste management facilities proximity indicators – SINOE (France)

## 1. Data source overview

Indicators included in the MRC-PE dataset were derived from the SINOE database (Système d’Information sur les Déchets), a national information system describing waste management facilities in France. The database is managed by public authorities and provides geolocated information on facilities involved in waste treatment, storage, and disposal activities.

The SINOE database includes, for each facility, information on location, type of waste management activity, and administrative characteristics.

For the MRC-PE project, the database was downloaded in 2024. As systematic historical archiving is not available, the data reflect the state of registered facilities at the time of data extraction.

## 2. Indicators derived from this data source

SINOE data were used to construct municipal-level indicators describing proximity to waste management facilities. Indicators aim to characterise potential environmental pressure related to waste management activities in residential environments and are provided at the municipality level in the final MRC-PE dataset.

Several indicators were produced based on different subsets of facilities, corresponding to specific categories of waste management activities. The indicators are based on a common spatial modelling approach and differ only in the selection of facilities included.

The complete list of indicators, along with their definitions and units, is provided in the dataset documentation on Recherche Data Gouv.

## 3. Data processing and indicator construction

### General processing logic

The construction of proximity indicators followed a spatial workflow.

First, geolocated waste management facilities were extracted from the SINOE database and filtered according to activity-based and regulatory criteria, depending on the indicator considered. Facilities were treated as point sources.

Second, proximity indicators were constructed using a kernel density estimation (KDE) approach (Wand and Jones 1994; Baddeley et al. 2015). KDE is a spatial smoothing method that transforms a set of point locations into a continuous surface representing the intensity of their presence in space. Each facility contributes to its surrounding environment within a predefined spatial neighbourhood, with an influence that decreases progressively with distance and becomes negligible beyond a given threshold.

In this application, a bandwidth of 4 km was used to define the spatial influence of waste management facilities, in line with methodological choices adopted by INERIS and Santé publique France for the assessment of potential impacts around industrial and waste-related facilities (INERIS 2021, 2025). At any given location, KDE values are higher when surrounding facilities are more numerous and closer, and lower when they are fewer or more distant. The resulting surface can be interpreted as a measure of potential proximity to waste management facilities rather than a direct measure of emissions or exposure.

KDE values were computed on a regular spatial grid and subsequently aggregated at the municipal level by calculating the mean value of grid cells intersecting each municipality.

### Software implementation

All processing steps were implemented using standard GIS tools, primarily QGIS. These steps included spatial filtering of facilities, kernel density estimation, raster handling, and aggregation of results at the municipal level. No dedicated R scripts were required for this data source.

## 4. Limitations and points of attention

These indicators should be interpreted as territorial proxies rather than direct measures of exposure.

SINOE is an administrative database. The presence of a facility does not imply continuous activity, nor does it provide information on quantities of waste processed, emission intensity, operating conditions, or temporal variability.

Due to the lack of systematic historical archiving, indicators reflect a snapshot of facilities at the time of data extraction and do not capture changes over time.

KDE-based proximity indicators rely on simplifying assumptions regarding spatial influence and do not account for physical dispersion processes, prevailing winds, topography, or pollutant-specific characteristics.

Indicators are intended for comparative and exploratory analyses.

## References

Baddeley A, Rubak E, Turner R (2015) Spatial Point Patterns: Methodology and Applications with R. Chapman and Hall/CRC, New York.

INERIS (2021) Etude des distances d’impact – Règle de Stern | Ineris.

INERIS (2025) Bassins Industriels et Santé (BIS) | Ineris.

Wand MP, Jones MC (1994) Kernel Smoothing. Chapman and Hall/CRC, New York.
