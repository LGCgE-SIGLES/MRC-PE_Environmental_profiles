# Green space access indicators – OpenStreetMap (France)

## 1. Data source overview

Indicators included in the MRC-PE dataset were derived from OpenStreetMap (OSM) data describing public green spaces in France.

For this work, we used the Geofabrik extract for France (`france-latest.osm.pbf`), downloaded on 2024/11/25 (OSM data up to 2024/11/24 according to the file metadata). Green-space polygons were extracted from the `multipolygons` layer using OSM tags.

Three indicator variants are produced in the MRC-PE dataset. They differ only by the initial selection of OSM polygons (the processing workflow is identical afterwards):

1. Strictly urban vision (parks and gardens)  
   - `leisure = park`  
   - `leisure = garden`

2. Urban + natural reserves (parks, gardens, nature reserves)  
   - `leisure = park`  
   - `leisure = garden`  
   - `leisure = nature-reserve`

3. Broader vision including forests/wooded areas (parks, gardens, nature reserves, forests/wood)  
   - `leisure = park`  
   - `leisure = garden`  
   - `leisure = nature-reserve`  
   - `landuse = forest`  
   - `natural = wood`

## 2. Indicators derived from this data source

OSM data were used to derive municipal-level indicators describing the spatial density and proximity of green spaces. Green-space polygons were first converted into a regular grid, and a kernel density estimation (KDE) approach was applied to generate a continuous surface reflecting their spatial influence.

Kernel density estimation is a spatial smoothing method that transforms a set of spatial objects into a continuous surface representing the intensity of their presence in space (Wand and Jones 1994; Baddeley et al. 2015). In this framework, each green space contributes to its surrounding environment within a predefined spatial neighbourhood, with an influence that decreases progressively with distance and becomes negligible beyond a given range.

At any given location, the KDE indicator takes higher values when surrounding green spaces are more numerous and/or closer, and lower values when they are fewer or more distant. The resulting surface can therefore be interpreted as a measure of potential proximity or accessibility to green spaces, rather than a direct measure of surface area or number of green spaces.

In the final MRC-PE dataset, three indicators are provided at the municipality level:

- `kde_parks` – KDE based on the strictly urban selection (parks and gardens)
- `kde_parks_natural` – KDE based on the urban + natural reserves selection
- `kde_parks_natural_forests` – KDE based on the broader selection including forests/wooded areas

A detailed list of indicator names, definitions and units is provided in the dataset documentation on Recherche Data Gouv and is not repeated here.

## 3. Data processing and indicator construction

### General processing logic

Processing follows a two-step logic. The same workflow is applied to each of the three OSM selections described above.

1. OSM extraction and KDE (national raster) 
   - Read OSM multipolygons and select green spaces (variant-specific tag selection).  
   - Reproject to Lambert-93 (EPSG:2154), simplify geometries, fix invalid geometries, and dissolve polygons to limit duplicates.  
   - Rasterise the green-space footprint on a 30 m × 30 m grid (presence/absence).  
   - Convert green-space raster cells to points (cell centroids) and run KDE using an Epanechnikov kernel, bandwidth 400 m, and an output grid of 200 m × 200 m.

2. Municipal aggregation (municipality indicators)
   - Apply minor post-processing to the KDE raster (unit conversion to per km², replacement of very small negative values by 0, rounding).  
   - Compute the municipal mean of the KDE surface using exact raster extraction.

Detailed calculation steps and parameter choices are documented directly within the R scripts provided in this repository.

### Scripts

The workflow is implemented in the following scripts (in this folder):

- `1_import_osm_and_kde_france.R` — OSM extraction (three tag selections), geometry processing, rasterisation, and KDE computation (national rasters)
- `2_municipality_aggregation.R` — KDE raster post-processing and aggregation to municipalities (mean value, three municipal indicators)

### Software implementation

All processing steps were implemented in R using standard spatial analysis libraries and utilities for OSM data import.

## 4. Limitations and points of attention

- OSM completeness and tagging: OSM is a collaborative database; mapping completeness and tag usage may vary across territories.
- Conceptual scope: the indicator reflects proximity to mapped green-space polygons (after KDE smoothing). It does not account for accessibility constraints (e.g. entrance locations, barriers), quality of green spaces, or travel time along the street network.
- Smoothing and scale effects: KDE parameters (bandwidth and output resolution) smooth local variability.

## References

Baddeley A, Rubak E, Turner R (2015) Spatial Point Patterns: Methodology and Applications with R. Chapman and Hall/CRC, New York

Wand MP, Jones MC (1994) Kernel Smoothing. Chapman and Hall/CRC, New York
