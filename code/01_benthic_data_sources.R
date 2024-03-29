# 1. Load packages ----

library(tidyverse)

# 2. Load data ----

load("data/09_misc/data-benthic.RData")

# 3. DatasetID per territory ----

data_benthic %>% 
  select(territory, datasetID) %>% 
  distinct() %>% 
  arrange(territory, datasetID) %>% 
  group_by(territory) %>% 
  summarise(datasetID = paste0(datasetID, collapse = ", ")) %>% 
  write.csv2(., file = "figs/03_methods/table-1.csv",
             row.names = FALSE)

# 4. Extract data sources for datasets used in the analyses ----

read.csv2("../../2022-02-10_gcrmndb_benthos/gcrmndb_benthos/data/05_data-sources.csv") %>% 
  mutate(datasetID = str_pad(datasetID, width = 4, pad = 0)) %>% 
  filter(datasetID %in% unique(data_benthic$datasetID)) %>% 
  write.csv2(., file = "figs/05_additional/01_data-sources.csv",
             row.names = FALSE)

# 5. Data contributors per territory ----

data_benthic %>% 
  select(datasetID, country, territory) %>% 
  distinct() %>% 
  full_join(., read.csv2("../../2022-02-10_gcrmndb_benthos/gcrmndb_benthos/data/05_data-sources.csv") %>% 
              mutate(datasetID = str_pad(datasetID, width = 4, pad = 0)) %>% 
              filter(datasetID %in% unique(data_benthic$datasetID)) %>% 
              select(datasetID, last_name, first_name, email)) %>% 
  select(-datasetID) %>% 
  distinct() %>% 
  write.csv2(., file = "figs/05_additional/01_contributors-territory.csv",
             row.names = FALSE)
  