#### Setup ####
# Packages
library(sf)
library(tidyverse)
library(mapview)
library(rnaturalearth)
library(stringr)


# data
manatee <- st_read("data/data_0.shp") %>%
  st_make_valid() %>%
  st_union() %>%
  st_as_sf() %>% 
  st_transform(32616)

land <- ne_countries(returnclass = "sf", scale = 110) %>%
  st_transform(32616) %>%
  st_make_valid() %>%
  st_crop(xmin= -1062160, ymin= -2488985, xmax= 7823095, ymax= 4938965) %>%
  filter(continent %in% c("South America", "North America"))

guyana <- ne_countries(returnclass = "sf", scale = 110, country = "France") %>%
  st_make_valid() %>%
  st_transform(32616) %>%
  st_crop(xmin= -1062160, ymin= -2488985, xmax= 7823095, ymax= 4938965)


lakes <- ne_download(type = "lakes", scale = 110, category = "physical", returnclass = "sf") %>%
  st_transform(32616) %>%
  st_crop(xmin= -1062160, ymin= -2488985, xmax= 7823095, ymax= 4938965) 

# draw water rectangle
water_rect <- st_as_sfc(st_bbox(c(xmin = -1062160, ymin = -2488985, xmax = 7823095, ymax = 4938965), crs = st_crs(32616)), crs = 32616)

ggplot() +
  geom_sf(data = water_rect, fill = "lightblue2", color = NA) +
  geom_sf(data = guyana, fill = "cornsilk1", color = "cornsilk2", size = 3) +
  geom_sf(data = land, fill = "cornsilk1", color = "cornsilk2", size = 3) +
  geom_sf(data = lakes, fill = "lightblue2", color = "lightblue2") +
  geom_sf(data = manatee, fill = "cyan4", color = NA) +
 # geom_sf_text(data = land %>% filter(name != "Canada"), aes(label = str_to_upper(name)), color = "cornsilk3", check_overlap = TRUE, size = 4) +
  theme_void()
