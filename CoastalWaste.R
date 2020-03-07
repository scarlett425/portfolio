install.packages("tidyverse")
install.packages("janitor")

library(tidyverse)
library(janitor)
library(purrr)
library(readr)

coast_vs_waste <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-05-21/coastal-population-vs-mismanaged-plastic.csv")

mismanaged_vs_gdp <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-05-21/per-capita-mismanaged-plastic-waste-vs-gdp-per-capita.csv")

waste_vs_gdp <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-05-21/per-capita-plastic-waste-vs-gdp-per-capita.csv")

#clean up column headers

coast_vs_waste <- coast_vs_waste %>% 
  set_names(c("country", "country_code", "year", "mismanaged_plastic_tons", "coastal_pop", "total_pop"))

colnames(mismanaged_vs_gdp)

mismanaged_vs_gdp <- mismanaged_vs_gdp %>% 
  set_names(c("country", "country_code", "year", "per_cap_mismanaged", "gdp_per_cap", "population"))

colnames(waste_vs_gdp)

waste_vs_gdp <- waste_vs_gdp %>% 
  set_names(c("country", "country_code", "year", "per_cap_waste", "gdp_per_cap", "population"))

#merge dataframes

plastic_waste <- merge(mismanaged_vs_gdp, waste_vs_gdp, by = c("country_code", "year"))
plastic_waste <- merge(plastic_waste, coast_vs_waste, by = c("country_code", "year"))


# filter rows with no data on waste
plastic_waste <- plastic_waste %>% 
  filter(!is.na(per_cap_mismanaged) & !is.na(per_cap_waste) & !is.na(gdp_per_cap.x) & !is.na(gdp_per_cap.y))

#eliminate one GDP per capita column in the merged dataset since it is duplicated

colnames(plastic_waste)

# plastic_waste <- subset(plastic_waste, select = -c(gdp_per_cap.x, country.x, population.x))

# plastic_waste <- subset(plastic_waste, select = -c(country.y))

#rename merged dataframe columns

plastic_waste <- plastic_waste %>% 
  rename(gdp_per_cap = gdp_per_cap.y, population = population.y)

#plastic_waste <- plastic_waste %>% 
 # rename(country = country.x)


# visualize data

qplot(x = year, y = population, color = "#CC0000", data = plastic_waste,geom = "point")
