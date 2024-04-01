library(climateR)
library(terra)
library(tidyterra)
library(ggplot2)
library(sf)
library(shapefiles)

TZA = AOI::aoi_get(country = "TZA")

test_data = getTerraClim(
  AOI = TZA,
  varname = "tmax",
  startDate = "2022-01-01",
  endDate   = "2023-12-01"
)

data = tapp(test_data[[1]],
            rep(1:12, (nlyr(test_data[[1]]) / 12)),
            mean) |>
  mask(project(vect(TZA), crs(test_data[[1]])))

names(data) = c("January", "February","March","April","May","June","July","August","September","October","November","December")

ggplot() +
  geom_spatraster(data = data) +
  geom_spatvector(data = TZA, fill = NA, lwd = 1) +
  facet_wrap( ~ lyr) +
  scale_fill_whitebox_c(
    palette  = "muted",
    n.breaks = 12,
    guide    = guide_legend(reverse = TRUE)
  ) +
  labs(title = "MONTHLY MEAN TEMPERATURE FROM January 2022-December 2023",fill = "Temperature (°C)") +
  theme_minimal()