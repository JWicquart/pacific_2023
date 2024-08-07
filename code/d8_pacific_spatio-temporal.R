# 1. Load packages ----

library(tidyverse) # Core tidyverse packages
library(sf)
sf_use_s2(FALSE) # Switch from S2 to GEOS
library(patchwork)

# 2. Source functions ----

source("code/function/graphical_par.R")
source("code/function/theme_map.R")
source("code/function/theme_graph.R")
source("code/function/data_descriptors.R")

# 3. Map of spatio-temporal distribution ----

## 3.1 Change the CRS ----

### 3.1.1 Define the CRS ----

crs_selected <- "+proj=eqc +lat_ts=0 +lat_0=0 +lon_0=160 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"

### 3.1.2 Define the offset ----

correction_offset <- 180 - 160 # Here 160 is the same value than +lon_0 from crs_selected

### 3.1.3 Define a long and slim polygon that overlaps the meridian line ----

correction_polygon <- st_polygon(x = list(rbind(c(-0.0001 - correction_offset, 90),
                                                c(0 - correction_offset, 90),
                                                c(0 - correction_offset, -90),
                                                c(-0.0001 - correction_offset, -90),
                                                c(-0.0001 - correction_offset, 90)))) %>%
  st_sfc() %>%
  st_set_crs(4326)

## 3.2 Load background maps ----

data_map <- read_sf("data/01_background-shp/01_ne/ne_10m_land/ne_10m_land.shp") %>% 
  st_transform(crs = 4326) %>% 
  st_difference(correction_polygon) %>% 
  st_transform(crs_selected)

## 3.3 Economic Exclusive Zones ----

load("data/01_background-shp/03_eez/data_eez.RData")

data_eez <- data_eez %>% 
  st_transform(crs = crs_selected)

data_eez_disputed <- read_sf("data/01_background-shp/03_eez/World_EEZ_v12_20231025/eez_v12.shp") %>% 
  filter(GEONAME == "Overlapping claim Matthew and Hunter Islands: France / Vanuatu") %>% 
  st_transform(crs = 4326) %>% 
  st_difference(correction_polygon) %>% 
  st_transform(crs_selected)

data_eez <- bind_rows(data_eez, data_eez_disputed)

## 3.4 Country boundaries ----

data_countries <- read_sf("data/01_background-shp/01_ne/ne_10m_admin_0_countries/ne_10m_admin_0_countries.shp") %>% 
  st_transform(crs_selected)

## 3.5 Bathymetry ----

load("data/01_background-shp/01_ne/ne_10m_bathymetry_all.RData")

data_bathy <- data_bathy %>% 
  st_transform(crs = 4326) %>% 
  st_difference(correction_polygon) %>% 
  st_transform(crs_selected)

## 3.6 Create the tropics ----

data_tropics <- tibble(long = c(-180, 180, -180, 180, -180, 180), 
                       lat = c(0, 0, 23.43656, 23.43656, -23.43656, -23.43656), 
                       tropic = c("Equator", "Equator", "Tropic of Cancer", "Tropic of Cancer",
                                  "Tropic of Capricorne", "Tropic of Capricorne")) %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326) %>% 
  group_by(tropic) %>% 
  summarise() %>% 
  st_cast("LINESTRING") %>% 
  st_difference(correction_polygon) %>% 
  st_transform(crs_selected)

data_tropics_no_eez <- st_intersection(data_tropics, data_eez)

data_tropics_no_eez$var <- "true"

data_tropics_no_eez <- st_difference(data_tropics, st_union(st_geometry(data_tropics_no_eez)))

## 3.7 Create text annotation ----

### 3.7.1 Tropics ----

data_text_tropics <- tibble(long = c(-105, -104, -119, -128),
                            lat = c(-21.43, -25.43, 2, 25.43),
                            text = c("Tropic of", "Capricorn", "Equator", "Tropic of Cancer")) %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326) %>% 
  st_transform(crs_selected)

### 3.7.2 Pacific Ocean ----

data_text_pacific <- tibble(long = c(-130),
                            lat = c(13),
                            text = c("Pacific Ocean")) %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326) %>% 
  st_transform(crs_selected)

### 3.7.3 Australia ----

data_text_australia <- tibble(long = c(140),
                              lat = c(-25),
                              text = c("Australia")) %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326) %>% 
  st_transform(crs_selected)

## 3.8 Bbox for alpha on bathymetry ---

data_alpha <- tibble(lat = c(-4000000, 4000000),
                     lon = c(-3500000, 11000000)) %>% 
  st_as_sf(coords = c("lon", "lat"), crs = crs_selected) %>% 
  st_bbox() %>% 
  st_as_sfc()

data_alpha <- data_eez %>% 
  summarise(geometry = st_union(geometry)) %>% 
  st_difference(data_alpha, .)

## 3.9 Select benthic data ----

load("data/09_misc/data-benthic.RData")

data_benthic <- data_benthic %>% 
  select(decimalLatitude, decimalLongitude, year) %>% 
  distinct() %>% 
  group_by(decimalLatitude, decimalLongitude) %>% 
  summarise(interval_years = max(year, na.rm = TRUE) - min(year, na.rm = TRUE)) %>%
  ungroup() %>% 
  mutate(interval_class = cut(interval_years, 
                              breaks = c(-Inf, 1, 5, 10, 15, Inf),
                              labels = c("1 year", "2-5 years", "6-10 years", "11-15 years", ">15 years")),
         interval_class = as.factor(interval_class)) %>% 
  st_as_sf(coords = c("decimalLongitude", "decimalLatitude"), crs = 4326) %>% 
  st_transform(crs = crs_selected)

## 3.10 Make the map ----

ggplot() +
  geom_sf(data = data_bathy %>% filter(depth == 0), aes(fill = fill_color), color = NA, alpha = 0.2) +
  geom_sf(data = data_bathy %>% filter(depth == 200), aes(fill = fill_color), color = NA, alpha = 0.2) +
  geom_sf(data = data_bathy %>% filter(depth == 1000), aes(fill = fill_color), color = NA, alpha = 0.2) +
  geom_sf(data = data_bathy %>% filter(depth == 2000), aes(fill = fill_color), color = NA, alpha = 0.2) +
  geom_sf(data = data_bathy %>% filter(depth == 3000), aes(fill = fill_color), color = NA, alpha = 0.2) +
  geom_sf(data = data_bathy %>% filter(depth == 4000), aes(fill = fill_color), color = NA, alpha = 0.2) +
  geom_sf(data = data_bathy %>% filter(depth == 5000), aes(fill = fill_color), color = NA, alpha = 0.2) +
  geom_sf(data = data_bathy %>% filter(depth == 6000), aes(fill = fill_color), color = NA, alpha = 0.2) +
  geom_sf(data = data_bathy %>% filter(depth == 7000), aes(fill = fill_color), color = NA, alpha = 0.2) +
  geom_sf(data = data_bathy %>% filter(depth == 8000), aes(fill = fill_color), color = NA, alpha = 0.2) +
  geom_sf(data = data_bathy %>% filter(depth == 9000), aes(fill = fill_color), color = NA, alpha = 0.2) +
  geom_sf(data = data_bathy %>% filter(depth == 10000), aes(fill = fill_color), color = NA, alpha = 0.2) +
  scale_fill_identity() +
  geom_sf(data = data_alpha, fill = "white", alpha = 0.5) +
  # Tropics
  geom_sf(data = data_tropics_no_eez, linetype = "dashed", color = "#363737", linewidth = 0.25) +
  # EEZ
  geom_sf(data = data_eez, color = "#363737", fill = "#e4e9ed", alpha = 0.2) +
  # Background map
  geom_sf(data = data_map, fill = "grey", col = "darkgrey") +
  # Country boundaries
  geom_sf(data = data_countries, fill = "grey", col = "darkgrey") +
  # Benthic data
  geom_sf(data = data_benthic %>% arrange(interval_class), aes(color = interval_class)) +
  scale_color_manual(values = palette_second,
                     labels = c("1 year", "2-5 years", "6-10 years", "11-15 years", ">15 years"), 
                     drop = FALSE, name = "Number of years with data") +
  # Annotation (legend)
  geom_sf_text(data = data_text_australia, aes(label = text), 
               color = "#363737", size = 3, family = font_choose_map) +
  geom_sf_text(data = data_text_tropics, aes(label = text), hjust = 1,
               color = "#363737", size = 3.5, family = font_choose_map, fontface = "italic") +
  geom_sf_text(data = data_text_pacific, aes(label = text), 
               color = "#1e517b", fontface = "italic", size = 3.5, family = font_choose_map) +
  # Graphical aspects
  coord_sf(ylim = c(-4000000, 4000000), xlim = c(-3500000, 11000000), expand = FALSE) +
  scale_x_continuous(breaks = c(180, 160, 140, -160, -140, -120)) +
  theme_map() +
  guides(colour = guide_legend(title.position = "top", title.hjust = 0.5, override.aes = list(size = 4)))

## 3.11 Save the plot ----

ggsave(filename = "figs/01_part-1/fig-10.png", width = 8, height = 5.5, dpi = fig_resolution)

# 4. Plot of percentage of sites per interval_class ----

## 4.1 Make the plot ----

data_benthic %>% 
  st_drop_geometry() %>% 
  group_by(interval_class) %>% 
  count() %>% 
  ungroup() %>% 
  mutate(percent = n*100/sum(n)) %>% 
  ggplot(data = ., aes(x = reorder(interval_class, desc(interval_class)),
                       y = percent, fill = interval_class)) +
    geom_bar(stat = "identity", color = NA, show.legend = FALSE, width = 0.65) +
    scale_fill_manual(values = palette_second,
                      labels = c("1 year", "2-5 years", "6-10 years", "11-15 years", ">15 years"), 
                      drop = FALSE, name = "Number of years with data") +
    labs(x = NULL, y = "Sites (%)") +
    coord_flip(clip = "off") +
    theme_graph() +
    scale_y_continuous(expand = c(0, 0), limits = c(0, 100))

## 4.2 Save the plot ----

ggsave(filename = "figs/04_supp/01_data-explo/04_surveys_duration_all.png",
       width = 5, height = 4, dpi = fig_resolution)

# 5. Plot of number of surveys per year ----

## 5.1 Make the plot ----

load("data/09_misc/data-benthic.RData")

data_benthic %>% 
  select(territory, decimalLatitude, decimalLongitude, eventDate, year) %>% 
  st_drop_geometry() %>% 
  distinct() %>% 
  group_by(year) %>% 
  count() %>% 
  ungroup() %>% 
  complete(year, fill = list(n = 0)) %>% 
  mutate(percent = n*100/sum(n)) %>% 
  ggplot(data = ., aes(x = year, y = percent)) +
    geom_bar(stat = "identity", show.legend = FALSE, width = 1,
             color = palette_first[4], fill = palette_first[3]) +
    labs(x = "Year", y = "Surveys (%)") +
    coord_cartesian(clip = "off") +
    theme_graph() +
    scale_x_continuous(expand = c(0, 0), limits = c(1980, NA))

## 5.2 Save the plot ----

ggsave(filename = "figs/01_part-1/fig-11.png", width = 5, height = 4, dpi = fig_resolution)

# 6. Plot of number of surveys per depth ----

## 6.1 Make the plot ----

data_benthic %>% 
  select(territory, decimalLatitude, decimalLongitude, eventDate, year, verbatimDepth) %>% 
  st_drop_geometry() %>% 
  drop_na(verbatimDepth) %>% 
  distinct() %>% 
  ggplot(data = ., aes(x = verbatimDepth)) +
  geom_histogram(binwidth = 1, aes(y = after_stat(width * density * 100)),
                 color = palette_first[4], fill = palette_first[3]) +
  labs(x = "Depth (m)", y = "Surveys (%)") +
  coord_cartesian(clip = "off") +
  theme_graph()

## 6.2 Save the plot ----

ggsave(filename = "figs/01_part-1/fig-12.png", width = 5, height = 4, dpi = fig_resolution)

# 7. Extract monitoring descriptors ----

load("data/09_misc/data-benthic.RData")

## 7.1 Add subterritories ----

monitoring_descriptors <- data_benthic %>% 
  group_by(territory) %>% 
  data_descriptors() %>% 
  ungroup() %>% 
  # Add missing territories (those with no data)
  left_join(st_read("data/01_background-shp/03_eez/data_eez.shp") %>%
              select(TERRITORY1) %>% 
              st_drop_geometry() %>% 
              rename(territory = TERRITORY1),
            .) %>% 
  mutate(across(c("nb_sites", "nb_surveys", "nb_datasets"), .fns = ~replace_na(.,0))) %>% 
  # Add subterritory
  mutate(subterritory = territory,
         territory = case_when(subterritory %in% c("Line Group", "Phoenix Group", "Gilbert Islands") ~ "Kiribati",
                               subterritory %in% c("Jarvis Island", "Johnston Atoll", 
                                                   "Wake Island", "Howland and Baker Islands",
                                                   "Palmyra Atoll") ~ "Pacific Remote Island Area",
                               TRUE ~ subterritory),
         subterritory = if_else(subterritory == territory, NA, subterritory)) %>% 
  arrange(territory, subterritory) %>% 
  relocate(subterritory, .after = territory)

## 7.2 Add total ----

monitoring_descriptors <- data_benthic %>% 
  data_descriptors() %>% 
  ungroup() %>% 
  mutate(territory = "Entire Pacific region") %>% 
  bind_rows(monitoring_descriptors, .)

## 7.3 Add total for two territories ----

monitoring_descriptors <- data_benthic %>% 
  mutate(territory = case_when(territory %in% c("Line Group", "Phoenix Group", 
                                                "Gilbert Islands") ~ "Kiribati",
                               territory %in% c("Jarvis Island", "Johnston Atoll", 
                                                "Wake Island", "Howland and Baker Islands",
                                                "Palmyra Atoll") ~ "Pacific Remote Island Area",
                               TRUE ~ territory)) %>% 
  filter(territory %in% c("Kiribati", "Pacific Remote Island Area")) %>% 
  group_by(territory) %>% 
  data_descriptors() %>% 
  ungroup() %>% 
  mutate(subterritory = "All") %>% 
  bind_rows(monitoring_descriptors, .) %>% 
  arrange(territory, subterritory) %>% 
  arrange(., territory == "Entire Pacific region")

## 7.4 Reformat the data and export the table ----

monitoring_descriptors <- monitoring_descriptors %>% 
  mutate(nb_sites = as.character(format(nb_sites, big.mark = ",", scientific = FALSE)),
         nb_surveys = as.character(format(nb_surveys, big.mark = ",", scientific = FALSE)),
         first_year = as.character(first_year),
         first_year = replace_na(first_year, ""),
         last_year = as.character(last_year),
         last_year = replace_na(last_year, ""))

## 7.5 Export the table ----

### 7.5.1 In .xlsx format ---- 

openxlsx::write.xlsx(monitoring_descriptors, file = "figs/01_part-1/table-4.xlsx")

### 7.5.2 In .tex format ---- 

latex_table_line <- function(i, subterritory){
  
  color <- ifelse(i %% 2 == 0, "white", "secondcolor")
  
  if(subterritory == FALSE){
    
    line <- c(paste0("\\rowcolor{", color, "}"),
              paste0("\\multicolumn{2}{|l|}{", monitoring_descriptors[i, "territory"], "} &", monitoring_descriptors[i, "nb_sites"], "&",
                     monitoring_descriptors[i, "nb_surveys"], "&", monitoring_descriptors[i, "nb_datasets"],
                     "&", monitoring_descriptors[i, "first_year"], "&", monitoring_descriptors[i, "last_year"]," \\\\ \\hline"))
    
  }else{
    
    line <- c(paste0("\\rowcolor{", color, "}"),
              paste0("\\multicolumn{1}{|l}{} & ", monitoring_descriptors[i, "subterritory"], " &", monitoring_descriptors[i, "nb_sites"], "&",
                     monitoring_descriptors[i, "nb_surveys"], "&", monitoring_descriptors[i, "nb_datasets"],
                     "&", monitoring_descriptors[i, "first_year"], "&", monitoring_descriptors[i, "last_year"]," \\\\ \\hline"))
    
  }
  
  return(line)
  
}

writeLines(c("\\begin{center}",
             "\\begin{tabular}{|ll|R{1.5cm}|R{1.5cm}|R{1.5cm}|R{1.5cm}|R{1.5cm}|}",
             "\\hline",
             "\\rowcolor{firstcolor}",
             "\\multicolumn{2}{|l|}{\\textcolor{white}{Countries and territories}} & \\textcolor{white}{Sites} & \\textcolor{white}{Surveys}  & \\textcolor{white}{Datasets} & \\textcolor{white}{First year} & \\textcolor{white}{Last year}\\\\ \\hline",
             map(1:8, ~ latex_table_line(i = ., subterritory = FALSE)) %>% unlist(),
             map(9:11, ~ latex_table_line(i = ., subterritory = TRUE)) %>% unlist(),
             map(12:17, ~ latex_table_line(i = ., subterritory = FALSE)) %>% unlist(),
             map(18:22, ~ latex_table_line(i = ., subterritory = TRUE)) %>% unlist(),
             map(23:32, ~ latex_table_line(i = ., subterritory = FALSE)) %>% unlist(),
             paste0("\\rowcolor{secondcolor}"),
             paste0("\\multicolumn{2}{|l|}{\\textbf{", monitoring_descriptors[33, "territory"], "}} &", monitoring_descriptors[33, "nb_sites"], "&",
                    monitoring_descriptors[33, "nb_surveys"], "&", monitoring_descriptors[33, "nb_datasets"],"&", monitoring_descriptors[33, "first_year"],
                    "&", monitoring_descriptors[33, "last_year"]," \\\\ \\hline"),
             "\\end{tabular}",
             "\\end{center}"),
           paste0("figs/01_part-1/table-4.tex"))
