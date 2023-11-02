library(raster)
library(ncdf4)
library(hackWRF)
library(eixport)
library(sp)

stack <- nc_open("E:/Eeshan/EQUATES/stack_groups_ptegu_AQF5X_2019ge_cb6_19k.ncf")

# Choose the variable you want to access
latitude <- "LATITUDE"
longitude <- "LONGITUDE"

# List available variable names
lat <- ncvar_get(stack, latitude)
lon <- ncvar_get(stack, longitude)

stack_locations <- data.frame(Latitude = lat,
                              Longitude = lon)

projection <- CRS("+proj=longlat +datum=WGS84")

# Use the coordinates function to create a spatial dataframe
spatial_df <- SpatialPointsDataFrame(coords = stack_locations[, c("Longitude", "Latitude")], 
                                     data = stack_locations, 
                                     proj4string = projection)

target_crs <- CRS("+proj=lcc +lat_1=33 +lat_2=45 +lat_0=39.30345 +lon_0=-97.64413 +x_0=0 +y_0=0 +datum=WGS84 +a=6370000 +b=6370000 +units=m +no_defs")

spatial_df <- spTransform(spatial_df, target_crs)

usa_lcc <- readRDS("C:/Users/basu.e/Downloads/important_R/data/usa_lcc.rds")
world_lcc <- readRDS("C:/Users/basu.e/Downloads/important_R/data/world_lcc.rds")
grid_lcc <- readRDS("C:/Users/basu.e/Downloads/important_R/data/grid_lcc.rds")

plot(spatial_df)
raster::plot(usa_lcc, 
             add = TRUE, 
             lwd = 2)
raster::plot(world_lcc,
             add = TRUE,
             lwd = 0.5)
raster::plot(grid_lcc,
             add = TRUE,
             lwd = 1)

#add the axis information
#axis(2, at = c(-655128,512172,1692472), labels = paste0(c("30", "40", "50"), "\U00B0", "N"))
#axis(1, at = c(1892488,807488,-229112,-1311412,-2393712), labels = paste0(c("80", "90", "100", "110", "120"), "\U00B0", "W"))

