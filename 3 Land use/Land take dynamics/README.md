# Land artificialization indicators – National Artificialization Monitoring Portal

## 1. Data source overview

Indicators included in the MRC-PE dataset were partly derived from data disseminated through the French National Artificialization Monitoring Portal, coordinated by the Centre d’études et d’expertise sur les risques, l’environnement, la mobilité et l’aménagement (CEREMA).

The portal provides national monitoring indicators describing land-use changes and artificialization dynamics over time. These indicators are computed from the Fichiers fonciers, a national cadastral and fiscal database originally developed for property tax management and subsequently repurposed for land-use monitoring.

Artificialization flux corresponds to surfaces that transitioned from natural, agricultural or forest land uses to artificial surfaces. Data are disseminated at the municipal level and updated regularly.

For the MRC-PE project, the dataset used describes cumulative artificialization between 2009 and 2023.

## 2. Indicators derived from this data source

Artificialization portal data were used to construct a municipal-level indicator describing recent land artificialization dynamics.

The indicator produced is:

- artificialization_2009_2023: share of municipal area converted into artificial surfaces between 2009 and 2023, expressed as a percentage of municipal area.

A detailed description of the indicator definition and metadata is provided in the dataset documentation and is not repeated here.

## 3. Data processing and indicator construction

Raw artificialization data were provided as municipal aggregates. Processing steps conducted in R focused on harmonisation with the municipal boundary framework used in the MRC-PE project and treatment of missing values.

Artificialization tables were joined to the IGN 2021 municipal layer using municipal identifiers. Resulting datasets were exported both before and after missing-value treatment for traceability.

Missing values were imputed using a spatial proximity approach based on inverse-distance weighting from neighbouring municipalities.

All processing steps were implemented in R.

## 4. Limitations and points of attention

Artificialization indicators are derived from cadastral land files originally designed for fiscal purposes. Their use for land-use monitoring relies on reclassification and interpretation processes that may introduce uncertainties.

The database covers cadastral parcels. Certain land uses such as transport infrastructures or water bodies may therefore be underrepresented. These surfaces nevertheless account for a limited share of the national territory, estimated at around 4 % of metropolitan France (Bocquet et al., 2022).

Indicators describe cumulative land-use change over the 2009–2023 period and do not capture intra-period dynamics or annual variability.

## References

Bocquet, M., Pierreuse, E., Dupré, O., Lory, P., 2022. Mesure de la consommation d’espaces à l’aide des Fichiers Fonciers : Définitions, précisions méthodologiques, limites et précautions d’interprétation. Cerema.
