# Potential naturalness indicators – IUCN CartNat

## 1. Data source overview

Indicators included in the MRC-PE dataset were partly derived from the CartNat project developed by the International Union for Conservation of Nature (IUCN).

CartNat provides a national-scale assessment of landscape naturalness through the construction of a composite indicator called the potential naturalness gradient. This approach is based on a conceptual framework structured around three complementary dimensions: biophysical integrity of land cover, spontaneity of ecological processes, and spatial continuity of landscapes (Guetté et al., 2018; Guetté et al., 2021).

Biophysical integrity reflects the extent to which current land cover differs from its estimated state in the absence of anthropogenic transformation. This component was assessed by comparing contemporary land cover with historical land-use data dating from the eighteenth and nineteenth centuries.

Process spontaneity evaluates the degree of human intervention in ecological dynamics using proxies of anthropogenic pressure, namely distance to roads and building density.

Spatial continuity captures landscape connectivity and ecological permeability and was modelled using the Omniscape connectivity framework (Landau et al., 2021).

## 2. Indicators derived from this data source

CartNat data were used to derive municipal-level indicators describing landscape naturalness and its underlying components.

The indicators included in the MRC-PE dataset are:

- biophysical_integrity_2021: biophysical integrity of land cover  

- process_spontaneity_2021: spontaneity of ecological processes  

- spatial_continuity_2021: spatial continuity of landscapes  

- potential_naturalness_2021: composite potential naturalness index  

The composite index corresponds to the unweighted sum of the three sub-indices described above.

## 3. Data processing and indicator construction

CartNat indicators were originally provided as raster datasets.

Processing steps focused on spatial aggregation to the municipal scale used in the MRC-PE project. Raster layers were intersected with municipal boundaries and summarised to produce municipal-level indicator values.

All spatial processing operations were performed in QGIS.

No additional transformations or imputations were applied beyond raster-to-municipality aggregation.

## 4. Limitations and points of attention

Naturalness indicators rely on a conceptual and model-based framework integrating historical reconstructions, spatial modelling and proxy variables. They should therefore be interpreted as synthetic ecological indicators rather than direct environmental measurements.

The spontaneity sub-index is based on proxies of human pressure limited to road proximity and building density, which may not capture all forms of anthropogenic influence.

## References

Guetté, A., Carruthers-Jones, J., Carver, S.J., 2021. Projet CARTNAT Cartographie de la Naturalité – Notice technique.

Guetté, A., Carruthers-Jones, J., Godet, L., Robin, M., 2018. « Naturalité » : concepts et méthodes appliqués à la conservation de la nature. Cybergeo: European Journal of Geography. https://doi.org/10.4000/cybergeo.29140

Landau, V., Shah, V., Anantharaman, R., Hall, K., 2021. Omniscape.jl: Software to compute omnidirectional landscape connectivity. Journal of Open Source Software, 6, 2829. https://doi.org/10.21105/joss.02829
