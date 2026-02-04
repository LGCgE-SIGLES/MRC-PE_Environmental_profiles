# Air pollution indicators

## 1. Data source overview

Air pollution indicators included in the MRC-PE dataset were derived from long-term modeled air quality concentration datasets produced by the Institut national de l’environnement industriel et des risques (INERIS). These datasets provide background concentrations of major atmospheric pollutants over metropolitan France, reconstructed using a combination of monitoring data, chemistry–transport modeling and spatial interpolation techniques (Real et al., 2022).

The data describe background ambient air pollution, representative of general outdoor air quality conditions, and are not intended to capture highly localized exposures in the immediate vicinity of emission sources (e.g. major roads or industrial facilities).

The data are provided as gridded raster datasets covering metropolitan France, with a spatial resolution of 4 km × 4 km until 2017 and 2 km × 2 km from 2018 onward. Daily concentrations are available over the period 2009–2020 for particulate matter (PM₂.₅ and PM₁₀), nitrogen dioxide (NO₂) and ozone (O₃).

## 2. Indicators derived from this data source

INERIS air pollution data were used to derive a comprehensive set of municipal-level indicators included in the MRC-PE dataset. These indicators describe long-term average concentrations, frequency of exceedance of WHO guideline thresholds, and temporal changes over the study period.

Indicators are available for the following pollutants:
- particulate matter PM₂.₅,
- particulate matter PM₁₀,
- nitrogen dioxide (NO₂),
- ozone (O₃).

They include:
- long-term averages of daily concentrations,
- long-term averages of daily maximum concentrations (for NO₂ and O₃),
- average annual number of days exceeding WHO 2021 guideline thresholds (when applicable),
- percentage change between two multi-year periods (2009–2014 vs 2015–2020).

A detailed list of indicator names, definitions, units and temporal coverage is provided in the dataset documentation on Recherche Data Gouv and is not repeated here.

## 3. Data processing and indicator construction

### General processing logic

For each pollutant, indicator construction follows a three-step logic, which is reflected in the numbering of the scripts provided in this repository:

1. Computation of long-term mean concentrations  
2. Derivation of exceedance indicators (when applicable)  
3. Computation of temporal change indicators  

Scripts are numbered accordingly (`1_`, `2_`, `3_`) to make this dependency explicit. Scripts corresponding to steps 2 and 3 reuse intermediate outputs produced during step 1 and are therefore not designed to be executed independently.

### Temporal aggregation

Daily pollutant concentration rasters were aggregated to derive:
- annual means of daily concentrations,
- annual means of daily maximum concentrations (for NO₂ and O₃),
- annual counts of days exceeding WHO 2021 guideline thresholds.

Long-term indicators were computed as averages over the period 2009–2020. Temporal change indicators were derived by comparing average concentrations between two periods (2009–2014 and 2015–2020) and expressed as percentage change.

For ozone (O₃), two distinct temporal scopes were considered:
- full-year indicators, based on all days of the year;
- seasonal indicators (May–October), corresponding to the period of highest photochemical activity.

### Spatial processing and aggregation

To ensure spatial consistency over time, rasters produced before 2018 (4 km resolution) were resampled to the 2 km grid used from 2018 onward, using nearest-neighbor resampling.

All raster-based indicators were then aggregated to the municipal level. For each municipality, indicator values correspond to the mean of raster cell values intersecting the municipal boundary.

### Software implementation

All processing steps were implemented in R using standard spatial analysis libraries. 

## 4. Limitations and points of attention

- Spatial scale: indicators describe average background air pollution levels at the municipal scale and do not capture fine-scale spatial variability near specific emission sources.
- Temporal aggregation: long-term averages may mask short-term pollution peaks and episodic exposure events.

## References: 

Real E, Couvidat F, Ung A, et al (2022) Historical reconstruction of background air pollution over France for 2000–2015. Earth System Science Data 14:2419–2443. https://doi.org/10.5194/essd-14-2419-2022

