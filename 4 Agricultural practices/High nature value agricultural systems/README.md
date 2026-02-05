# High Nature Value farmland indicators – Solagro

## 1. Data source overview

Indicators included in the MRC-PE dataset were derived from High Nature Value (HNV) farmland data produced by Solagro.

The concept of High Nature Value farmland emerged in the early 2000s following the adoption of the Kiev Resolution (2003), which aimed to support and preserve agricultural systems contributing to biodiversity conservation across European Union Member States.

In France, the methodological framework for identifying and mapping HNV farmland was developed by Solagro in collaboration with the Joint Research Centre of the European Commission.

Detailed methodological foundations and national implementation are described in Pointereau et al. (2010) and Poux and Pointereau (2014).

The HNV assessment relies on three complementary dimensions of agricultural systems:

- crop rotation diversity  

- farming practices extensiveness  

- density of agroecological landscape infrastructures  

These three components are combined into a composite HNV score.

The version of the methodology used in the dataset integrates later adjustments to the original scoring system. While crop rotation diversity still ranges from 1 to 10 points, both farming extensiveness and landscape infrastructure indicators now range from 0 to 10 points. The composite HNV score therefore ranges from 1 to 30 points.

Raw data were provided at the municipal level for three reference years: 2000, 2010 and 2017. Data are not openly accessible and are available upon request from Solagro.

## 2. Indicators derived from this data source

Solagro HNV data were used to construct municipal-level indicators describing the ecological value of agricultural systems.

The indicators included in the MRC-PE dataset are:

- HNV: composite High Nature Value score (average 2000, 2010, 2017)  

- ROTATIONS: crop rotation diversity indicator (average 2000, 2010, 2017)  

- PRACTICES: farming extensiveness indicator (average 2000, 2010, 2017)  

- LANDSCAPE: agroecological landscape elements density indicator (average 2000, 2010, 2017)  

## 3. Data processing and indicator construction

Raw municipal datasets were available for three years (2000, 2010, 2017), each including the four HNV indicators.

Processing was implemented in R and focused on spatial harmonisation, missing data management and temporal aggregation.

Municipal datasets were first harmonised with the IGN 2021 municipal boundary framework used in the MRC-PE project.

Several types of missing or anomalous values were identified:

- structurally missing data in municipalities without agricultural activity  

- missing values linked to municipal boundary changes  

- anomalous zero values interpreted as missing data in 2017  

After harmonisation:

- interannual averages were calculated using available millésimes  

- averages were computed on three, two or one year depending on availability  

- municipalities missing all three years were imputed  

Imputation was conducted using inverse distance weighted averages based on the five nearest neighbouring municipalities.

## 4. Limitations and points of attention

HNV indicators describe the ecological value of agricultural systems rather than overall municipal biodiversity.

## References

Pointereau, P., Coulon, F., Jiguet, F., Doxa, A., Paracchini, M.-L., Terres, J.-M., 2010. Les systèmes agricoles à haute valeur naturelle en France métropolitaine.

Poux, X., Pointereau, P., 2014. L’agriculture à haute valeur naturelle en France métropolitaine. Un indicateur pour le suivi de la biodiversité et l’évaluation de la politique de développement rural. Rapport d’étude au Ministère de l’agriculture de l’agroalimentaire et de la forêt.
