library(climateR)
library(terra)
library(tidyterra)
library(ggplot2)
library(sf)
library(shapefiles)
TZA <- st_read("data/DodomaRegion.gpkg") %>% st_make_valid()

test_data <- getTerraClim(
  AOI = TZA,
  varname = "tmax",
  startDate = "2023-01-01",
  endDate = "2023-12-31"
)

data <- tapp(test_data[[1]],
             rep(1:12, (nlyr(test_data[[1]]) / 12)),
             mean) |>
  mask(project(vect(TZA), crs(test_data[[1]])))

names(data) <- c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")


# Plot the data
ggplot() +
  geom_spatraster(data = data) +
  geom_spatvector(data = TZA, fill = NA, lwd = 1) +
  facet_wrap( ~ lyr) +
  scale_fill_whitebox_c(
    palette = "muted",
    n.breaks = 12,
    guide = guide_legend(reverse = TRUE)
  ) +
  labs(title = "Monthly Temperature of Dodoma Region:January 1- December 31 2023", fill = "Temperature (°C)") +
  theme_minimal()

# Save the plot as PDF
ggsave("data/Dodoma Monthly Mean Temperature.pdf", width = 16.5, height = 11.7)

# Save the plot as JPG
ggsave("data/Dodoma Monthly Mean Temperature.jpg", width = 19.8, height = 10.2, units = "in", dpi = 300)

