# Biophysical and use indicators – Corine Land Cover (CLC)

## 1. Data source overview

Indicators included in the MRC-PE dataset were partly derived from the Corine Land Cover (CLC) programme, a pan-European land cover and land use inventory coordinated within the Copernicus Land Monitoring Service.

CLC provides harmonised land cover maps based on a hierarchical nomenclature structured into three levels. The database describes the biophysical occupation of land surfaces across Europe and is updated at regular intervals. Reference years available include 1990, 2000, 2006, 2012 and 2018.

CLC data are produced using a minimum mapping unit of 25 hectares and a minimum mapping width of 100 metres. As a result, small land cover patches and fine-scale spatial patterns are not systematically captured.

For the MRC-PE project, CLC data were used in the form of municipal-level surface tables already aggregated by land cover class and reference year. Processing steps conducted in R focused on harmonisation with the municipal reference framework used in the project, treatment of missing values, and construction of final indicators expressed as percentages of municipal area.

## 2. Indicators derived from this data source

CLC data were used to construct indicators describing land use composition at the municipal level. Indicators correspond to the proportion of municipal area occupied by major land cover groups and selected subcategories.

At nomenclature level 1, indicators were produced for the following broad land cover groups:

- artificial surfaces  

- agricultural areas  

- natural and semi-natural areas  

- wetlands  

For each group, indicators were calculated for multiple CLC reference years and summarised using an inter-period mean over 2006, 2012 and 2018. A binary indicator describing the presence of wetlands over the same period was also derived.

At nomenclature level 2, indicators focus on artificial land uses related to industrial, commercial, transport and extractive activities. Percentages of municipal area were calculated separately for industrial surfaces and mineral extraction or dump sites, as well as for their combined footprint. Inter-period means and binary presence indicators were also produced for these components.

A detailed list of indicator names, definitions and units is provided in the dataset documentation and is not repeated here.

## 3. Data processing and indicator construction

Processing of Corine Land Cover indicators is implemented through two complementary R scripts:

- CLC_Level1_LandUse_Processing.R: construction of broad land-use composition indicators based on CLC nomenclature level 1.

- CLC_Level2_Industrial_Extraction_Processing.R: construction of indicators focusing on industrial, commercial, transport and extractive land uses derived from CLC level 2 classes.

CLC municipal tables were first harmonised to the municipal boundary framework used in the MRC-PE project (IGN 2021 edition). This step ensured consistency across all environmental indicators.

For each reference year and land cover component, surface areas were converted into percentages of municipal area. When necessary, values exceeding 100 percent due to inconsistencies between reported surfaces and municipal geometry were capped.

Missing values resulting from boundary harmonisation or incomplete coverage were imputed using a spatial proximity approach. Values were estimated from neighbouring municipalities based on inverse-distance weighting.

To provide stable indicators representative of recent land use conditions, inter-period means were calculated over the 2006, 2012 and 2018 CLC vintages. Binary indicators were derived to describe the presence or absence of selected land cover components over this period.

All processing steps were implemented in R.

## 4. Limitations and points of attention

CLC is designed for European-scale comparability and relies on a minimum mapping unit of 25 hectares. Consequently, small land cover patches and fine-scale spatial configurations such as dispersed urban development may not be represented.
