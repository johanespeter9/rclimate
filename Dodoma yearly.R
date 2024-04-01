library(climateR)
library(terra)
library(tidyterra)
library(ggplot2)
library(sf)
library(shapefiles)

TZA <- st_read("data/DodomaRegion.gpkg") %>% st_make_valid()
test_data = getTerraClim(
  AOI = TZA,
  varname = "tmax",
  startDate = "2022-01-01",
  endDate   = "2023-12-01"
)

data = mask(mean(test_data[[1]]), project(vect(TZA), crs(test_data[[1]])))

ggplot() +
  geom_spatraster(data = data) +
  geom_spatvector(data = TZA, fill = NA, lwd = 1) +
  scale_fill_whitebox_c(
    palette  = "muted",
    n.breaks = 12,
    guide    = guide_legend(reverse = TRUE)
  ) +
  labs(title = "Mean Daily Max Temperature of TZAdi Arabia for the years 2011 and 2012 ",fill = "Temperature (°C)") + 
  theme_minimal()
#Save the plot as PDF
ggsave("data/dodomayearly.pdf", width = 16.5, height = 11.7)

# Save the plot as JPG
ggsave("data/dodomayearly.jpg", width = 19.8, height = 10.2, units = "in", dpi = 300)
