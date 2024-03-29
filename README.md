
<!-- README.md is generated from README.Rmd. Please edit that file -->

# **Status and Trends of Coral Reefs of the Pacific**

## 1. Introduction

## 2. Code

### A. Cleaning and selection (`01_`)

- `01_benthic_data_sources.R` Extract data sources from
  [gcrmndb_benthos](https://github.com/JWicquart/gcrmndb_benthos).
- `01_clean_bathy.R` Clean bathymetry data from [Natural Earth
  Data](https://www.naturalearthdata.com/downloads/10m-physical-vectors/).
- `01_clean_cyclones.R` Clean cyclone dataset from
  [IBTrACS](https://www.ncei.noaa.gov/products/international-best-track-archive).
- `01_clean_eez.R` Select and clean economic exclusive zones (EEZ) from
  [marineregions](https://marineregions.org/downloads.php).
- `01_clean_land.R` Clean Pacific land data (high spatial resolution)
  from [Princeton University](https://maps.princeton.edu/).
- `01_clean-reef-distribution.R` Select Pacific coral reefs distribution
  from the [Tropical Coral Reefs of the
  World](https://datasets.wri.org/dataset/tropical-coral-reefs-of-the-world-500-m-resolution-grid)
  World Resources Institute (WRI).
- `01_download_coraltemp.R` Download
  [CoralTemp](https://coralreefwatch.noaa.gov/index.php) NetCDF4+ files
  for SST and DHW.
- `01_select_benthic-data.R` Select
  [gcrmndb_benthos](https://github.com/JWicquart/gcrmndb_benthos) data
  to use in the analyses.

### B. Extraction and models (`02_`)

#### B1. Indicators

- `02_extract_indicator_cyclones` Extract cyclones for each EEZ.
- `02_extract_dhw-percent.R` Extract percent of coral reefs under DHW
  for each EEZ.
- `02_extract_dhw-time-series.R` Extract maximum DHW within each EEZ.
- `02_extract_elevation.js` Extract mean land elevation for each
  territory using Google Earth Engine (GEE). Estimated values are used
  as geographic information’s.
- `02_extract_land-area.js` Extract total land area for each territory
  using GEE. Estimated values are used as geographic information’s.
- `02_extract_map-dhw.R` Create raster with the mean annual DHW for each
  cell.
- `02_extract_population.R` Extract human population for each territory.
  Estimated values are used as geographic information’s.
- `02_reef-buffer.js` Create coral reef distribution buffer of 100 km.
  Used to extract cyclones occurrence.
- `02_extract_sst-time-series.R` Extract SST and SST anomaly on coral
  reefs of each EEZ.

#### B2. Predictors

- `02_extract_predictor_chla.js` Extract chlorophyll *a* as a predictor,
  using GEE.
- `02_extract_predictor_population.js` Extract total human population
  within 10 km from each site as a predictor, using GEE.
- `02_extract_predictor_elevation.js` Extract mean land elevation within
  10 km from each site as a predictor, using GEE.
- `02_extract_predictor_reef-extent.js` Extract total coral reef extent
  within 10 km from each site as a predictor, using GEE.
- `02_extract_predictor_land.js` Extract total land area within 10 km
  from each site as a predictor, using GEE.
- `02_extract_predictor_gravity.R` Extract gravity as a predictor.
- `02_extract_predictor_sst.js` Extract SST mean from each site as a
  predictor, using GEE.

#### B3. Models

- `02_model_data-exploration.Rmd` Data exploration for benthic cover.
- `02_model_site-coordinates.R` Extract site coordinates for coral reefs
  sites to predict.
- `02_model_data-preparation.R` Combine predictors and prepare benthic
  data for the models.
- `02_model_tuning.R` Hyperparameters tuning for the models.
- `02_model_bootstrap.R` Bootstrap to calculate confidence interval from
  model outputs.

### C. Figures and tables (`03_`)

- `03_benthic-cover-trends.Rmd` Produce figures of hard coral and algae
  cover trends.
- `03_indicators.R` Combine and export indicators’ values.
- `03_materials-and-methods.R` Produce figures for the Materials and
  Methods section of the report.

#### C1. Pacific region

- `03_pacific_cyclones.R` Produce figure and map of cyclones that
  occurred over the Pacific region.
- `03_pacific_map.R` Produce map of the entire Pacific GCRMN region with
  description of EEZ.
- `03_pacific_map-dhw.R` Produce map of DHW for each year.
- `03_pacific_population.R` Produce figure of human population change
  between 2000 and 2020.
- `03_pacific_rel-reef-area.R` Produce figure of relative reef area of
  Pacific territories.
- `03_pacific_spatio-temporal.R` Produce figure and map of
  spatio-temporal distribution of benthic cover monitoring for the
  Pacific region.
- `03_pacific_sst.R` Produce figures of maximum DHW and DHW percent for
  the Pacific region.

#### C2. Countries and territories

- `03_territories_cyclones.R` Produce figures and maps of cyclones that
  occurred on each EEZ.
- `03_territories_map.R` Produce maps for each EEZ.
- `03_territories_map-sphere.R` Produce hemisphere maps for each EEZ.
- `03_territories_spatio-temporal.R` Produce figure and map of
  spatio-temporal distribution of benthic cover monitoring for each EEZ.
- `03_territories_sst.R` Produce figures of SST, SST anomaly and DHW for
  each EEZ.

#### C3. Case studies

- `03_box_fish-new-caledonia.R` Case study on MPA of Ouano, New
  Caledonia.

### D. Functions

- `data_descriptors.R` Get number of sites, surveys, datasets, first and
  last year of monitoring.
- `graphical_par.R` Graphical parameters, including colors and fonts.
- `theme_graph.R` Main ggplot theme for the plots of the reports.
- `theme_map.R` Main ggplot theme for the maps of the reports.

## 3. Reproducibility parameters

    ─ Session info ───────────────────────────────────────────────────────────────
     setting  value
     version  R version 4.3.2 (2023-10-31 ucrt)
     os       Windows 10 x64 (build 18363)
     system   x86_64, mingw32
     ui       RTerm
     language (EN)
     collate  French_France.utf8
     ctype    French_France.utf8
     tz       Europe/Paris
     date     2024-02-26
     pandoc   3.1.1 @ C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools/ (via rmarkdown)

    ─ Packages ───────────────────────────────────────────────────────────────────
     package       * version    date (UTC) lib source
     askpass         1.2.0      2023-09-03 [1] CRAN (R 4.3.2)
     backports       1.4.1      2021-12-13 [1] CRAN (R 4.3.1)
     base64enc       0.1-3      2015-07-28 [1] CRAN (R 4.3.1)
     bit             4.0.5      2022-11-15 [1] CRAN (R 4.3.2)
     bit64           4.0.5      2020-08-30 [1] CRAN (R 4.3.2)
     blob            1.2.4      2023-03-17 [1] CRAN (R 4.3.2)
     broom           1.0.5      2023-06-09 [1] CRAN (R 4.3.2)
     bslib           0.6.1      2023-11-28 [1] CRAN (R 4.3.2)
     cachem          1.0.8      2023-05-01 [1] CRAN (R 4.3.2)
     callr           3.7.3      2022-11-02 [1] CRAN (R 4.3.2)
     cellranger      1.1.0      2016-07-27 [1] CRAN (R 4.3.2)
     class           7.3-22     2023-05-03 [1] CRAN (R 4.3.2)
     classInt        0.4-10     2023-09-05 [1] CRAN (R 4.3.2)
     cli             3.6.2      2023-12-11 [1] CRAN (R 4.3.2)
     clipr           0.8.0      2022-02-22 [1] CRAN (R 4.3.2)
     clock           0.7.0      2023-05-15 [1] CRAN (R 4.3.2)
     codetools       0.2-19     2023-02-01 [1] CRAN (R 4.3.2)
     colorspace      2.1-0      2023-01-23 [1] CRAN (R 4.3.2)
     conflicted      1.2.0      2023-02-01 [1] CRAN (R 4.3.2)
     cpp11           0.4.7      2023-12-02 [1] CRAN (R 4.3.2)
     crayon          1.5.2      2022-09-29 [1] CRAN (R 4.3.2)
     curl            5.2.0      2023-12-08 [1] CRAN (R 4.3.2)
     data.table      1.15.0     2024-01-30 [1] CRAN (R 4.3.2)
     DBI             1.2.1      2024-01-12 [1] CRAN (R 4.3.2)
     dbplyr          2.4.0      2023-10-26 [1] CRAN (R 4.3.2)
     diagram         1.6.5      2020-09-30 [1] CRAN (R 4.3.1)
     dials           1.2.0      2023-04-03 [1] CRAN (R 4.3.2)
     DiceDesign      1.10       2023-12-07 [1] CRAN (R 4.3.2)
     digest          0.6.34     2024-01-11 [1] CRAN (R 4.3.2)
     dplyr           1.1.4      2023-11-17 [1] CRAN (R 4.3.2)
     dtplyr          1.3.1      2023-03-22 [1] CRAN (R 4.3.2)
     e1071           1.7-14     2023-12-06 [1] CRAN (R 4.3.2)
     ellipsis        0.3.2      2021-04-29 [1] CRAN (R 4.3.2)
     evaluate        0.23       2023-11-01 [1] CRAN (R 4.3.2)
     fansi           1.0.6      2023-12-08 [1] CRAN (R 4.3.2)
     farver          2.1.1      2022-07-06 [1] CRAN (R 4.3.2)
     fastmap         1.1.1      2023-02-24 [1] CRAN (R 4.3.2)
     fontawesome     0.5.2      2023-08-19 [1] CRAN (R 4.3.2)
     forcats         1.0.0      2023-01-29 [1] CRAN (R 4.3.2)
     foreach         1.5.2      2022-02-02 [1] CRAN (R 4.3.2)
     fs              1.6.3      2023-07-20 [1] CRAN (R 4.3.2)
     furrr           0.3.1      2022-08-15 [1] CRAN (R 4.3.2)
     future          1.33.1     2023-12-22 [1] CRAN (R 4.3.2)
     future.apply    1.11.1     2023-12-21 [1] CRAN (R 4.3.2)
     gargle          1.5.2      2023-07-20 [1] CRAN (R 4.3.2)
     generics        0.1.3      2022-07-05 [1] CRAN (R 4.3.2)
     ggplot2         3.4.4      2023-10-12 [1] CRAN (R 4.3.2)
     globals         0.16.2     2022-11-21 [1] CRAN (R 4.3.1)
     glue            1.7.0      2024-01-09 [1] CRAN (R 4.3.2)
     googledrive     2.1.1      2023-06-11 [1] CRAN (R 4.3.2)
     googlesheets4   1.1.1      2023-06-11 [1] CRAN (R 4.3.2)
     gower           1.0.1      2022-12-22 [1] CRAN (R 4.3.1)
     GPfit           1.0-8      2019-02-08 [1] CRAN (R 4.3.2)
     gtable          0.3.4      2023-08-21 [1] CRAN (R 4.3.2)
     hardhat         1.3.1      2024-02-02 [1] CRAN (R 4.3.2)
     haven           2.5.4      2023-11-30 [1] CRAN (R 4.3.2)
     highr           0.10       2022-12-22 [1] CRAN (R 4.3.2)
     hms             1.1.3      2023-03-21 [1] CRAN (R 4.3.2)
     htmltools       0.5.7      2023-11-03 [1] CRAN (R 4.3.2)
     httr            1.4.7      2023-08-15 [1] CRAN (R 4.3.2)
     ids             1.0.1      2017-05-31 [1] CRAN (R 4.3.2)
     infer           1.0.6      2024-01-31 [1] CRAN (R 4.3.2)
     ipred           0.9-14     2023-03-09 [1] CRAN (R 4.3.2)
     isoband         0.2.7      2022-12-20 [1] CRAN (R 4.3.2)
     iterators       1.0.14     2022-02-05 [1] CRAN (R 4.3.2)
     jquerylib       0.1.4      2021-04-26 [1] CRAN (R 4.3.2)
     jsonlite        1.8.8      2023-12-04 [1] CRAN (R 4.3.2)
     KernSmooth      2.23-22    2023-07-10 [1] CRAN (R 4.3.2)
     knitr           1.45       2023-10-30 [1] CRAN (R 4.3.2)
     labeling        0.4.3      2023-08-29 [1] CRAN (R 4.3.1)
     lattice         0.22-5     2023-10-24 [1] CRAN (R 4.3.2)
     lava            1.7.3      2023-11-04 [1] CRAN (R 4.3.2)
     lhs             1.1.6      2022-12-17 [1] CRAN (R 4.3.2)
     lifecycle       1.0.4      2023-11-07 [1] CRAN (R 4.3.2)
     listenv         0.9.1      2024-01-29 [1] CRAN (R 4.3.2)
     lubridate       1.9.3      2023-09-27 [1] CRAN (R 4.3.2)
     magrittr        2.0.3      2022-03-30 [1] CRAN (R 4.3.2)
     MASS            7.3-60.0.1 2024-01-13 [1] CRAN (R 4.3.2)
     Matrix          1.6-5      2024-01-11 [1] CRAN (R 4.3.2)
     memoise         2.0.1      2021-11-26 [1] CRAN (R 4.3.2)
     mgcv            1.9-1      2023-12-21 [1] CRAN (R 4.3.2)
     mime            0.12       2021-09-28 [1] CRAN (R 4.3.1)
     modeldata       1.3.0      2024-01-21 [1] CRAN (R 4.3.2)
     modelenv        0.1.1      2023-03-08 [1] CRAN (R 4.3.2)
     modelr          0.1.11     2023-03-22 [1] CRAN (R 4.3.2)
     munsell         0.5.0      2018-06-12 [1] CRAN (R 4.3.2)
     nlme            3.1-164    2023-11-27 [1] CRAN (R 4.3.2)
     nnet            7.3-19     2023-05-03 [1] CRAN (R 4.3.2)
     numDeriv        2016.8-1.1 2019-06-06 [1] CRAN (R 4.3.1)
     openssl         2.1.1      2023-09-25 [1] CRAN (R 4.3.2)
     parallelly      1.37.0     2024-02-14 [1] CRAN (R 4.3.2)
     parsnip         1.1.1      2023-08-17 [1] CRAN (R 4.3.2)
     patchwork       1.2.0      2024-01-08 [1] CRAN (R 4.3.2)
     pillar          1.9.0      2023-03-22 [1] CRAN (R 4.3.2)
     pkgconfig       2.0.3      2019-09-22 [1] CRAN (R 4.3.2)
     prettyunits     1.2.0      2023-09-24 [1] CRAN (R 4.3.2)
     processx        3.8.3      2023-12-10 [1] CRAN (R 4.3.2)
     prodlim         2023.08.28 2023-08-28 [1] CRAN (R 4.3.2)
     progress        1.2.3      2023-12-06 [1] CRAN (R 4.3.2)
     progressr       0.14.0     2023-08-10 [1] CRAN (R 4.3.2)
     proxy           0.4-27     2022-06-09 [1] CRAN (R 4.3.2)
     ps              1.7.6      2024-01-18 [1] CRAN (R 4.3.2)
     purrr           1.0.2      2023-08-10 [1] CRAN (R 4.3.2)
     R6              2.5.1      2021-08-19 [1] CRAN (R 4.3.2)
     ragg            1.2.7      2023-12-11 [1] CRAN (R 4.3.2)
     rappdirs        0.3.3      2021-01-31 [1] CRAN (R 4.3.2)
     RColorBrewer    1.1-3      2022-04-03 [1] CRAN (R 4.3.1)
     Rcpp            1.0.12     2024-01-09 [1] CRAN (R 4.3.2)
     readr           2.1.5      2024-01-10 [1] CRAN (R 4.3.2)
     readxl          1.4.3      2023-07-06 [1] CRAN (R 4.3.2)
     recipes         1.0.9      2023-12-13 [1] CRAN (R 4.3.2)
     rematch         2.0.0      2023-08-30 [1] CRAN (R 4.3.2)
     rematch2        2.1.2      2020-05-01 [1] CRAN (R 4.3.2)
     reprex          2.1.0      2024-01-11 [1] CRAN (R 4.3.2)
     rlang           1.1.3      2024-01-10 [1] CRAN (R 4.3.2)
     rmarkdown       2.25       2023-09-18 [1] CRAN (R 4.3.2)
     rpart           4.1.23     2023-12-05 [1] CRAN (R 4.3.2)
     rsample         1.2.0      2023-08-23 [1] CRAN (R 4.3.2)
     rstudioapi      0.15.0     2023-07-07 [1] CRAN (R 4.3.2)
     rvest           1.0.4      2024-02-12 [1] CRAN (R 4.3.2)
     s2              1.1.6      2023-12-19 [1] CRAN (R 4.3.2)
     sass            0.4.8      2023-12-06 [1] CRAN (R 4.3.2)
     scales          1.3.0      2023-11-28 [1] CRAN (R 4.3.2)
     selectr         0.4-2      2019-11-20 [1] CRAN (R 4.3.2)
     sf              1.0-15     2023-12-18 [1] CRAN (R 4.3.2)
     shape           1.4.6      2021-05-19 [1] CRAN (R 4.3.1)
     slider          0.3.1      2023-10-12 [1] CRAN (R 4.3.2)
     SQUAREM         2021.1     2021-01-13 [1] CRAN (R 4.3.1)
     stringi         1.8.3      2023-12-11 [1] CRAN (R 4.3.2)
     stringr         1.5.1      2023-11-14 [1] CRAN (R 4.3.2)
     survival        3.5-8      2024-02-14 [1] CRAN (R 4.3.2)
     sys             3.4.2      2023-05-23 [1] CRAN (R 4.3.2)
     systemfonts     1.0.5      2023-10-09 [1] CRAN (R 4.3.2)
     terra           1.7-71     2024-01-31 [1] CRAN (R 4.3.2)
     textshaping     0.3.7      2023-10-09 [1] CRAN (R 4.3.2)
     tibble          3.2.1      2023-03-20 [1] CRAN (R 4.3.2)
     tidymodels      1.1.1      2023-08-24 [1] CRAN (R 4.3.2)
     tidyr           1.3.1      2024-01-24 [1] CRAN (R 4.3.2)
     tidyselect      1.2.0      2022-10-10 [1] CRAN (R 4.3.2)
     tidyverse       2.0.0      2023-02-22 [1] CRAN (R 4.3.2)
     timechange      0.3.0      2024-01-18 [1] CRAN (R 4.3.2)
     timeDate        4032.109   2023-12-14 [1] CRAN (R 4.3.2)
     tinytex         0.49       2023-11-22 [1] CRAN (R 4.3.2)
     tune            1.1.2      2023-08-23 [1] CRAN (R 4.3.2)
     tzdb            0.4.0      2023-05-12 [1] CRAN (R 4.3.2)
     units           0.8-5      2023-11-28 [1] CRAN (R 4.3.2)
     utf8            1.2.4      2023-10-22 [1] CRAN (R 4.3.2)
     uuid            1.2-0      2024-01-14 [1] CRAN (R 4.3.2)
     vctrs           0.6.5      2023-12-01 [1] CRAN (R 4.3.2)
     viridisLite     0.4.2      2023-05-02 [1] CRAN (R 4.3.2)
     vroom           1.6.5      2023-12-05 [1] CRAN (R 4.3.2)
     warp            0.2.1      2023-11-02 [1] CRAN (R 4.3.2)
     withr           3.0.0      2024-01-16 [1] CRAN (R 4.3.2)
     wk              0.9.1      2023-11-29 [1] CRAN (R 4.3.2)
     workflows       1.1.3      2023-02-22 [1] CRAN (R 4.3.2)
     workflowsets    1.0.1      2023-04-06 [1] CRAN (R 4.3.2)
     xfun            0.42       2024-02-08 [1] CRAN (R 4.3.2)
     xml2            1.3.6      2023-12-04 [1] CRAN (R 4.3.2)
     yaml            2.3.8      2023-12-11 [1] CRAN (R 4.3.2)
     yardstick       1.3.0      2024-01-19 [1] CRAN (R 4.3.2)

     [1] C:/Users/jwicquart/AppData/Local/Programs/R/R-4.3.2/library

    ──────────────────────────────────────────────────────────────────────────────
