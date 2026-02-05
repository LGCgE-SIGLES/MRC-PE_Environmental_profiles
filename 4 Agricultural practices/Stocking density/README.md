# Livestock density indicators – Agricultural Census (RGA)

## 1. Data source overview

Indicators included in the MRC-PE dataset were partly derived from the French Agricultural Census conducted by Agreste (Recensement général agricole, RGA).

The agricultural census provides detailed structural information on farming systems across France, including livestock numbers aggregated at the municipal level.

Livestock counts are expressed in Livestock Units (LU), a standardised reference unit allowing aggregation of animals of different species and ages using species-specific coefficients based on their nutritional requirements. For example, a bovine under one year old corresponds to 0.4 LU, while a laying hen corresponds to 0.014 LU.

Data used in the MRC-PE project originate from the 2010 and 2020 agricultural censuses.

## 2. Indicators derived from this data source

Agricultural census data were used to construct a municipal-level indicator describing livestock density.

The indicator produced is:

- livestock_2010_2020: number of Livestock Units per hectare of municipal area, expressed as LU per hectare.

Livestock counts recorded for 2010 and 2020 were normalised by municipal area. A mean value was then calculated across both census years in order to provide a stable estimate of livestock density.

A detailed description of indicator metadata is provided in the dataset documentation and is not repeated here.

## 3. Data processing and indicator construction

Raw livestock data were provided as municipal aggregates. Processing steps conducted in R focused on harmonisation with the municipal boundary framework used in the MRC-PE project and treatment of missing values.

Livestock counts for 2010 and 2020 were first joined to the IGN 2021 municipal layer. Counts were then normalised by municipal area to obtain livestock density expressed in LU per hectare.

Before aggregation, temporal consistency between both census years was assessed through correlation analysis. Pearson and Spearman coefficients indicated strong stability between 2010 and 2020, supporting the calculation of an inter-census mean.

The final indicator corresponds to the mean livestock density across both years.

Missing values, affecting a limited number of municipalities, were imputed using an inverse-distance weighted mean based on the five nearest neighbouring municipalities.

All processing steps were implemented in R.

## 4. Limitations and points of attention

Livestock indicators rely on census data collected at discrete time points and therefore describe structural agricultural conditions rather than continuous temporal dynamics.

Although Livestock Units provide a harmonised aggregation metric, they remain an indirect proxy of environmental pressures. Differences in farming practices, housing systems or manure management are not captured.
