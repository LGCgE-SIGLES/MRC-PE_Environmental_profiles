# Agricultural land use indicators – RPG (IGN)

## 1. Data source overview

Indicators included in the MRC-PE dataset were derived from the Registre Parcellaire Graphique (RPG) produced by the French National Institute of Geographic and Forest Information (IGN).

The RPG is a geospatial database created in the context of the Common Agricultural Policy (CAP). It is updated annually based on farmer declarations submitted to claim CAP subsidies and provides information on agricultural land use.

A major methodological break occurs in 2015:

- from 2007 to 2014 (RPG v1), the dataset represents “îlots culturaux” (blocks of contiguous parcels managed by a farm) and the main crop group, using a limited crop-group nomenclature (about 24–28 groups depending on year);

- from 2015 onward (RPG v2), the geometry is more detailed (parcel-level) and the nomenclature becomes much more granular (hundreds of crop codes), which requires harmonisation to ensure comparability over time.

For the MRC-PE project, RPG data were processed for multiple years and ultimately used to produce municipal indicators describing the share of municipal territory occupied by broad crop groups.

More details on RPG access, nomenclature and documentation are available from IGN: https://geoservices.ign.fr/rpg

## 2. Indicators derived from this data source

RPG data were used to derive municipal indicators expressed as percentages of municipal area occupied by selected crop categories, averaged over 2009–2021.

The indicators included in the MRC-PE dataset are:

- WHEAT

- MAIZE

- BARLEY

- OTHER_CEREALS

- CEREALS

- RAPESEED

- SUNFLOWER

- OTHER_OILSEEDS

- OILSEEDS

- PERMANENT_GRASSLANDS

- TEMPORARY_GRASSLANDS

- GRASSLANDS

- INDUSTRIAL_CROPS

- VEGETABLES_FLOWERS

- PROTEIN_CROPS

- FIBER_PLANTS

- GRAIN_LEGUMES

- FODDER_CROPS

- RICE

- ORCHARDS

- VINEYARDS

- OLIVE_GROVES

- NUT_CROPS

- PASTURES_HEATHS

- FALLOW

- MISC_CROPS

## 3. Data processing and indicator construction

Processing combined two successive stages:

- geospatial processing under Python ;

- harmonisation and indicator construction under R.

### Geospatial processing (Python)

For each year, RPG geometries were intersected with the municipal boundary layer (IGN 2021 framework used in MRC-PE). Processing outputs were municipal tables reporting crop areas (in hectares) by crop code:

- for 2007–2014: areas by crop-group code (pre-2015 nomenclature);

- for 2015 onward: areas by detailed crop code (post-2015 nomenclature).

A preliminary geometry validation step was applied to RPG polygons, and invalid geometries (e.g., self-intersections) were removed before intersection. A summary of the share of excluded polygons was produced in the provider deliverables.

Note: The MRC-PE repository documents this stage at a conceptual level, but only the R scripts used for harmonisation and indicator construction are distributed alongside the dataset.

### Harmonisation and indicator construction (R)

Because the RPG nomenclature changes in 2015, post-2015 crop codes were mapped to pre-2015 crop groups using an equivalence table (crop code → crop-group code). The mapping was completed when needed by consulting the most recent RPG nomenclatures (e.g., 2020) to ensure all crop codes could be assigned to a crop group.

Additional harmonisation was applied to ensure comparability across years:

- fallow/“set-aside” categories were consolidated so that early years (where several fallow codes existed) were made consistent with later years;

- crop-group codes no longer used after 2015 (e.g., seeds; specific fallow subclasses; legacy “arboriculture”) were reassigned to their closest equivalent groups to maintain continuity;

- extremely marginal categories observed sporadically in mainland France (e.g., sugar cane) were removed to simplify the harmonised time series.

After harmonisation, annual municipal crop areas (ha) were converted into percentages of municipal area using the municipal surface (ha) derived from the IGN 2021 municipal boundary layer.

Finally, temporal aggregation was performed by averaging annual percentages over 2009–2021. Composite indicators were created by summing relevant crop groups (e.g., CEREALS = wheat + maize + barley + other cereals; OILSEEDS = rapeseed + sunflower + other oilseeds; GRASSLANDS = permanent + temporary grasslands).

The R workflow was implemented through three successive scripts:

- 1_RPG_Harmonisation_PrePost2015_Nomenclature

- 2_RPG_MunicipalAreaShares_ByYear

- 3_RPG_TemporalAggregation_And_FinalExport

## 4. Limitations and points of attention

RPG data are based on CAP declarations and may not cover all agricultural areas. Consequently, some agricultural surfaces can be missing when they are not declared or not eligible for subsidies. This limitation has been documented empirically in comparisons with agricultural census sources: for instance, Preux et al. (2014) report a coverage gap of about 7.5% of agricultural area in 2010 in Basse-Normandie when comparing RPG data with agricultural census results.

Under-reporting can be crop-specific. In particular, under-reporting of vineyard parcels is documented in RPG use and is an issue currently addressed by IGN.

The methodological break in 2015 implies that harmonisation is necessary but comes with information loss: post-2015 detailed crop codes are aggregated back to broader pre-2015 crop groups to ensure time comparability.

## References

Preux, P., et al., 2014. Comparison of RPG declarations with agricultural census results in Basse-Normandie (reported coverage gap around 7.5% of agricultural area in 2010).
