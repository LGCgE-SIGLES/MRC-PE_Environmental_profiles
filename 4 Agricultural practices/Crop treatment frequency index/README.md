# Treatment Frequency Index (TFI) – Solagro

## 1. Data source overview

Indicators included in the MRC-PE dataset were partly derived from Treatment Frequency Index (TFI) data produced by Solagro.

The TFI is an agronomic indicator used to estimate pesticide application intensity. It reflects the number of standard treatment doses applied per hectare over a given period. The indicator integrates all phytosanitary treatments applied to crops, based on reference treatment regimes defined at national and regional levels.

At the municipal scale, TFI values are calculated by combining crop distribution within the municipality with crop-specific reference TFI values.

Raw datasets were provided already aggregated at the municipal level using the January 2023 Admin Express municipal boundary framework. Data coverage includes metropolitan France and Corsica.

Data are not openly accessible but are available upon request from Solagro. Further methodological details are provided in Solagro technical documentation (Chayre et al., 2024a; 2024b).

## 2. Indicators derived from this data source

Solagro data were used to construct municipal-level indicators describing pesticide treatment intensity across several treatment categories.

The indicators included in the MRC-PE dataset are:

- tfi_total_2020_2021: average total Treatment Frequency Index  

- tfi_total_excl_biocontrol_2020_2021: TFI excluding biocontrol products  

- tfi_herbicide_2020_2021: herbicide TFI  

- tfi_excl_herbicide_2020_2021: TFI excluding herbicides  

- tfi_excl_herbicide_biocontrol_2020_2021: TFI excluding herbicides and biocontrol  

- tfi_biocontrol_2020_2021: biocontrol TFI  

Indicators correspond to the mean value of 2020 and 2021 municipal estimates.

## 3. Data processing and indicator construction

Raw municipal tables were first merged with the IGN 2021 municipal boundary framework used in the MRC-PE project.

A small number of municipalities could not be matched due to boundary code inconsistencies. These cases were treated as missing data.

For municipalities with no agricultural area, TFI values were set to zero. In such situations, the absence of agricultural land implies no phytosanitary treatment exposure.

For municipalities with missing values unrelated to agricultural absence, missing data were imputed using inverse-distance weighting based on the five nearest neighbouring municipalities.

Following imputation, interannual averages were calculated across 2020 and 2021 to produce the final indicators.

Processing and imputation were implemented in R.

## 4. Limitations and points of attention

TFI values relate exclusively to agricultural surfaces within municipalities, regardless of the share of agricultural land in total municipal area. Municipalities with limited agricultural land may therefore exhibit high TFI values despite low territorial agricultural coverage.

Conversely, municipalities without agricultural land systematically present null indicators.

TFI indicators rely on reference treatment regimes and crop distribution modelling rather than direct pesticide application measurements. They should therefore be interpreted as proxy indicators of pesticide pressure.

## References

Chayre, A., Gibert, C., Mezilet, Y., Pointereau, P., 2024a. Carte ADONIS présentant par commune l’usage des pesticides au travers de l’indice de fréquence de traitement (IFT) : évolutions 2020–2022. Solagro.

Chayre, A., Pointereau, P., Mezilet, Y., 2024b. Carte ADONIS des IFT : Méthodologie de calcul de l’indicateur de fréquence de traitement phytosanitaire en agriculture par commune. Solagro.
