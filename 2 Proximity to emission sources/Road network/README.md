# Road network density indicators – BD TOPO (IGN)

## 1. Data source overview

Road network indicators included in the MRC-PE dataset were derived from road network objects extracted from the BD TOPO® database produced by the French National Institute of Geographic and Forest Information (IGN).

Within BD TOPO® (Transport theme), road segments are characterized by an “importance” attribute, which provides a functional hierarchy of the road network. In simplified terms, lower importance values correspond to roads with a higher functional role in the network. Importance class 1 typically includes major motorways and national roads, class 2 includes other major interurban roads, while classes 3 and 4 correspond to secondary and local roads. 

For the MRC-PE project, BD TOPO® data were downloaded in 2024 and processed as a static snapshot of the road network covering metropolitan France.

## 2. Indicators derived from this data source

BD TOPO® road network data were used to derive municipal-level indicators describing the density of the road network. Indicators are based on the total length of road segments intersecting each municipality, normalized by municipal area to ensure comparability across territories.

Indicators were constructed using different subsets of the road network defined by the “importance” attribute, allowing the density of major roads to be distinguished from that of the overall road network.

Three indicators were constructed, depending on the “importance” classes considered:
- importance 1 to 4,
- importance 1 and 2,
- importance 1 only.

Indicators are expressed as road length per unit area (km/km²). A detailed list of indicator codes, definitions and units is provided in the dataset documentation on Recherche Data Gouv and is not repeated here.

## 3. Data processing and indicator construction

### General processing logic

Road segments were first filtered according to the targeted “importance” classes. For each set of classes, the following steps were applied:
1. spatial intersection between filtered road segments and municipal boundaries;
2. removal of non-linear geometries potentially created by intersection operations (e.g. POINT geometries);
3. computation of segment lengths (km);
4. aggregation of total road length by municipality;
5. normalization by municipal area (km²) to obtain a density indicator.

Scripts are organized so that the same processing function can be applied to different subsets of “importance” classes.

### Software implementation

All processing steps were implemented in R using standard spatial analysis libraries. 

## 4. Limitations and points of attention

These indicators describe the density of mapped road infrastructures at the municipal level and should be interpreted as territorial proxies rather than direct measures of individual exposure.

First, the indicators do not include information on traffic intensity, vehicle flows or temporal variability in road use. They therefore cannot be interpreted as direct measures of exposure to traffic-related air pollution or noise.

Second, the road network is treated as a static object based on the BD TOPO® snapshot downloaded in 2024. Changes in road infrastructure occurring before or after this date are not captured.
