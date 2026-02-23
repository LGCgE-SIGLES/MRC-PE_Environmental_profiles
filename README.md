# Environmental Indicator Production – MRC-PE Project

## 1. Project overview

Chronic kidney disease is a broad public health issue whose main risk is progression to end-stage kidney disease (ESKD), with major consequences for patients and healthcare systems. In addition to well-established clinical risk factors, growing evidence suggests that environmental and territorial characteristics may play an important role in the spatial distribution of CKD incidence.

The MRC-PE project (Chronic Kidney Disease – Environmental Profiles) aims to investigate, at the national scale, the association between territorial environmental profiles and the incidence of ESKD in metropolitan France, at the municipal level. The project also examines the potential mediating role of diabetes, arterial hypertension, and other socio-environmental determinants, such as social disadvantage and access to healthcare.

This multidisciplinary project relies on the linkage of large-scale health data (REIN registry, SNDS) with a comprehensive set of spatialized environmental indicators.

---

## 2. Relation to the published dataset

The final environmental indicators produced within the MRC-PE project are publicly available through the Recherche Data Gouv platform:

Paumelle, M., Deram, A., Lanier, C., Occelli, F. (2026). *Environmental profiles of municipalities in metropolitan France – MRC-PE Project*.
https://doi.org/10.57745/CDXXH6

The published dataset provides 150 municipal-level environmental indicators covering metropolitan France (excluding Corsica), along with detailed metadata and recommended citation.

**This GitHub repository does not contain the final dataset.**  
Its purpose is to document how the environmental indicators were produced, including data sources, processing steps, analytical assumptions, and limitations associated with data source or indicator construction.

---

## 3. Scope and purpose of this repository

This repository is intended as a methodological companion to the published dataset. It provides:

- documentation of the data sources used to construct environmental indicators;
- R scripts used for data processing, spatial aggregation, and indicator computation;
- descriptions of processing steps performed using GIS software (QGIS) when no R scripts were involved;
- information on data quality, interpretative limits, and reproducibility constraints.

Due to licensing restrictions and data volume considerations, raw data are not redistributed in this repository. As a result, some scripts are not directly executable without prior access to the original data sources.

---

## 4. Thematic organization of indicators

Environmental indicators are organized into six main thematic domains:

- contamination levels of environmental media (e.g. air pollution, soil contamination);
- proximity to emission and nuisance sources (e.g. industrial facilities, contaminated sites and soils);
- land use (e.g. artificial surfaces, agricultural land use);
- agricultural practices (e.g. purchases of pesticide actives substances, stocking density);
- environmental amenities (e.g. green spaces, vegetation indices);
- climate (e.g. temperature).

Each thematic domain is implemented as a dedicated directory within the repository.

---

## 5. Repository structure

The repository is organized around two complementary levels of documentation.

First, a general documentation directory (`0 Docs/`) provides transversal information applicable to the entire dataset:

- `general_limitations.md` documents general limitations and usage recommendations common to all indicators;
- `data_sources_overview.md` provides a synthetic overview of all data sources used in the project;

Second, the repository is structured by thematic domain and by data source. Each data source is documented independently in order to clearly describe how the corresponding indicators were derived.

A typical structure is as follows:

```text
1 Contamination levels of environmental media/
└── Air pollution/
    ├── README.md
    ├── scripts/
    └── renv.lock
```

Each data-source directory includes:

- a `README.md` describing the original data, the indicators produced, the main processing steps, and the interpretative limitations of these indicators;
- R scripts when applicable;
- a `renv.lock` file documenting R package dependencies.

---

## 6. Reproducibility and software environment

All data processing was conducted using:

- **R** (R Core Team, 2024) for data handling, spatial processing, and indicator computation;
- **QGIS** (QGIS Development Team, 2024) for selected GIS-based operations.

R dependencies were managed using the `renv` package. For each data source processed in R, a dedicated R project was used and the corresponding `renv.lock` file is provided.

Users can restore the R environment using:

```r
renv::restore()
```

Reproducibility is therefore conditional on access to the original input data.

---

## 7. Data availability and licensing constraints

**All code and documentation provided in this repository are released under the Apache License, Version 2.0.**  
See the `LICENSE` file for details.

The final environmental indicators produced are publicly available through the Recherche Data Gouv platform:

Paumelle, M., Deram, A., Lanier, C., Occelli, F. (2026). *Environmental profiles of municipalities in metropolitan France – MRC-PE Project*.
https://doi.org/10.57745/CDXXH6

Most data sources used in the MRC-PE project are openly accessible. However, some datasets are subject to specific access or reuse conditions defined by their producers.

Consequently:

- raw data are not included in this repository;
- indicators derived from restricted data are documented but not redistributed;
- information on data access conditions is provided in the README file associated with each data source.

---

## 8. Intended use and limitations

The indicators documented in this repository were designed for territorial-scale analyses, particularly in the context of environmental epidemiology.

They describe environmental features of municipalities and should not be interpreted as individual-level exposures. Spatial aggregation at the municipal level may mask substantial within-area heterogeneity, and temporal mismatches between data sources are present.

---

## 9. Citation

If you use the methods, code, or documentation provided in this repository, or make use of the environmental indicators produced within the MRC-PE project, please cite the associated dataset:

Paumelle, M., Deram, A., Lanier, C., Occelli, F. (2026). *Environmental profiles of municipalities in metropolitan France – MRC-PE Project*.  
https://doi.org/10.57745/CDXXH6

---

## 10. Contact

For questions regarding the MRC-PE project or the content of this repository, please contact:

- **Dr. Martin Paumelle** – Université de Lille – martin.paumelle@univ-lille.fr  
- **Dr. Florent Occelli** – Université de Lille – florent.occelli@univ-lille.fr
