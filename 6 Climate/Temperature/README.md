# Temperature indicators – Santé publique France

## 1. Data source overview

Indicators included in the MRC-PE dataset were partly derived from ambient temperature exposure data produced by Santé publique France (SPF) in the framework of environmental health research.

Temperature exposure estimates were derived from a multi-resolution air temperature model developed by Hough et al. (2020), with spatial resolution ranging from 200 m in urban areas to 1 km in rural areas.

Raw data provided by SPF consist of daily ambient temperature estimates over the 2000–2018 period, including daily mean, minimum and maximum temperatures. Data are provided at municipal level as absolute values and as relative values computed against reference temperatures.

Reference values correspond to decadal climate normals by climate type and department. The year is divided into consecutive 10-day periods, and reference temperatures are defined for each 10-day period within each climate type and department, allowing comparison of local values with a smoothed seasonal baseline.

Further details on data production and the overall analytical framework are provided in Adélaïde et al. (2024).

These data are not openly accessible but are available upon reasonable request from the data producers.

## 2. Indicators derived from this data source

SPF temperature data were used to construct municipal-level indicators describing long-term ambient temperature levels and relative exposure compared to reference values.

The indicators included in the MRC-PE dataset are:

- TMEAN_2000_2018: average daily mean temperature over 2000–2018 (°C)

- TMIN_2000_2018: average daily minimum temperature over 2000–2018 (°C)

- TMAX_2000_2018: average daily maximum temperature over 2000–2018 (°C)


- DIFF_TMEAN_2000_2018: difference between average daily mean temperature and the reference value (°C)

- DIFF_TMIN_2000_2018: difference between average daily minimum temperature and the reference value (°C)

- DIFF_TMAX_2000_2018: difference between average daily maximum temperature and the reference value (°C)


- EXCEED_TMEAN_2000_2018: number of days per year when daily mean temperature exceeds the reference value (days/year)

- EXCEED_TMIN_2000_2018: number of days per year when daily minimum temperature exceeds the reference value (days/year)

- EXCEED_TMAX_2000_2018: number of days per year when daily maximum temperature exceeds the reference value (days/year)

A detailed description of indicator metadata is provided in the dataset documentation (Recherche Data Gouv) and is not repeated here.

## 3. Data processing and indicator construction

Processing was implemented in R through three successive scripts:

- 1_Temperature_AnnualIndicators: aggregation of daily municipal temperatures into annual indicators, including annual means for absolute and relative temperatures and annual counts of exceedance days

- 2_Temperature_InterannualCorrelations: computation of interannual correlation matrices to assess temporal stability of annual indicators

- 3_Temperature_FinalExport: assembly of final municipal datasets aligned with the IGN 2021 framework, and export in tabular and spatial formats

A specific adjustment was required for the municipality of Lyon. In the source dataset, temperature indicators were provided at arrondissement level rather than for the municipality as a whole. Municipal values were therefore reconstructed by averaging arrondissement-level values for each indicator.

Corsican municipalities were excluded, as temperature data were not available for this territory.

## 4. Limitations and points of attention

Temperature indicators are derived from model-based exposure estimates rather than direct meteorological station measurements. They should therefore be interpreted as harmonised exposure surfaces suitable for spatial epidemiology rather than exact local observations.

## References

Adélaïde, L., Hough, I., Seyve, E., Kloog, I., Fifre, G., Launoy, G., Launay, L., Pascal, M., Lepeule, J., 2024. Environmental and social inequities in continental France: an analysis of exposure to heat, air pollution, and lack of vegetation. Journal of Exposure Science and Environmental Epidemiology. https://doi.org/10.1038/s41370-024-00641-6

Hough, I., Just, A.C., Zhou, B., Dorman, M., Lepeule, J., Kloog, I., 2020. A Multi-Resolution Air Temperature Model for France from MODIS and Landsat Thermal Data. Environmental Research 183, 109244. https://doi.org/10.1016/j.envres.2020.109244
