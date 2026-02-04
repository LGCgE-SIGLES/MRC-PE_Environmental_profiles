# Industrial accident density indicators – ARIA

## 1. Data source overview

Indicators included in the MRC-PE dataset were derived from the ARIA database (Analyse, Recherche et Information sur les Accidents), a national information system documenting industrial and technological accidents in France. The database is maintained by public authorities and provides descriptive information on accidental events affecting industrial installations.

ARIA records accidents over a long historical period and includes, for each event, information on the date, location (municipality and department), and general characteristics of the accident. The database does not provide precise geographical coordinates for accident locations.

For the MRC-PE project, ARIA records corresponding to accidents that occurred in France were extracted. Accidents recorded over the period 1960–2024 were considered. As systematic historical geolocation is not available, indicators derived from ARIA should be interpreted as describing cumulative accident occurrence at the municipal level.

## 2. Indicators derived from this data source

ARIA data were used to construct a municipal-level indicator describing the density of industrial accidents. The indicator aims to characterise the historical intensity of industrial accident occurrence in residential environments and is provided at the municipality level in the final MRC-PE dataset.

A single indicator was produced:

* an indicator of the number of industrial accidents per unit of municipal area (number per km²).

All accidents were considered uniformly, regardless of their type or severity.

The complete definition of the indicator, including temporal coverage and units, is provided in the dataset documentation on Recherche Data Gouv.

## 3. Data processing and indicator construction

### General processing logic

The construction of the indicator followed a multi-step workflow.

First, ARIA raw data were filtered to retain only accidents recorded in France. Accidents were then aggregated at the municipal level. As ARIA does not provide geographical coordinates, the localisation of accidents relied on the reported municipality name and department code.

Second, accident records were linked to the municipal reference dataset used in the MRC-PE project (IGN municipal boundaries, 2021 version). Record linkage was performed using a double condition combining municipality name and department code, in order to resolve cases where different municipalities share the same name.

Third, for each municipality, the total number of accidents recorded over the period 1960–2024 was computed. This count was normalised by municipal area to derive an accident density indicator expressed as the number of accidents per square kilometre.

Unlike other proximity-based indicators in the MRC-PE project, no kernel density estimation (KDE) approach was applied, as accidents are not geolocated within municipalities.

### Software implementation

Data preparation and indicator construction were implemented using standard data processing and GIS tools, including spreadsheet-based workflows and QGIS for spatial joins and area calculations. No dedicated R scripts were required for this data source.

## 4. Limitations and points of attention

These indicators should be interpreted as territorial proxies rather than direct measures of exposure or risk.

ARIA is an event-based database relying on reported accidents. Reporting practices and completeness may vary over time, and the indicator does not account for changes in industrial activity or reporting intensity.

Accidents are located at the municipal level only. Within-municipality spatial heterogeneity cannot be captured, and no information is available on the exact location of accidents.

The indicator aggregates accidents over a long historical period (1960–2024) and therefore reflects cumulative accident occurrence rather than current risk levels.

Indicators are intended for comparative and exploratory analyses.
