#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| output: FALSE

library(sf)
library(dplyr)
#
#
#
#
#
#| output: FALSE

prov <- bcmaps::bc_bound()

cus <- st_read("C:/Users/finnr/Documents/Data Library/Salmon CUs/Chum_Salmon_CU_Boundary/Chum_Salmon_CU_Boundary_3005.shp") %>%
  filter(CU_name %in% c("Rivers Inlet", "Hecate Lowlands", "Bella Coola-Dean Rivers", "Wannock")) %>%
  st_transform(., st_crs(prov)) 

rivers <- bcdata::bcdc_query_geodata("https://catalogue.data.gov.bc.ca/dataset/a1b9c58f-c32e-498e-94c1-a6e46ef287b2") %>%
  filter(INTERSECTS(cus)) %>%
  bcdata::collect()

#
#
#
#
#
#| output: FALSE

library(ggplot2)
library(tmap)
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
ggplot(cus) + geom_sf(aes(fill = CU_name))
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
tm_shape(cus) +
  tm_polygons(fill = "CU_name")
#
#
#
#
#
tm_shape(prov) +
  tm_polygons(fill = "lightgrey") +
  tm_shape(cus) +
  tm_polygons(fill = "CU_name")
#
#
#
#
#
#
#
#| warning: false

st_crop(prov, st_bbox(cus)) %>%
  tm_shape(.) + 
  tm_polygons(fill = "lightgrey") +
  tm_shape(cus) + 
  tm_polygons(fill = "CU_name")
#
#
#
#
#
#
#
#
#
#| warning: false

st_crop(prov, st_bbox(cus)) %>%
  tm_shape(.) + 
  tm_polygons(fill = "lightgrey") +
  
  tm_shape(cus) + 
  tm_polygons(fill = "CU_name",
              fill.legend = 
                tm_legend(
                  position = tm_pos_on_top(0.02, 0.28),
                  title = "Chum Conservations Units")) 


#
#
#
#
#
#| warning: false

st_crop(prov, st_bbox(cus)) %>%
  tm_shape(.) + 
  tm_polygons(fill = "lightgrey") +
  
  tm_shape(cus) + 
  tm_polygons(fill = "CU_name",
              fill.legend = 
                tm_legend(
                  position = tm_pos_on_top(0.02, 0.28),
                  title = "Chum Conservations Units")) +
  tm_compass() +
  tm_scalebar()


#
#
#
#
#
#
#
#
#
#| warning: false
# st_crop(prov, st_bbox(cus)) %>%
#   tm_shape(.) + 
#   tm_polygons(fill = "grey",
#               fill_alpha = 0.5) +
  
tm_shape(cus) + 
  tm_polygons(fill = "CU_name",
              fill.legend = 
                tm_legend(
                  position = tm_pos_on_top(0.65, 0.97),
                  title = "Chum Conservations Units",
                  frame = FALSE,
                  bg = FALSE),
              fill_alpha = 0.7) +
  tm_compass() +
  tm_scalebar() +
  
  tm_shape(st_crop(rivers, st_bbox(st_buffer(cus, 300)))) +
  
  tm_lines(lwd = 0.5,
           col = "lightblue") +
  
  tm_shape(st_crop(prov, st_bbox(cus))) + 
  tm_borders() +
  
  tm_basemap("Esri.OceanBasemap")
#
#
#
#
#
#
#
#
#
#
