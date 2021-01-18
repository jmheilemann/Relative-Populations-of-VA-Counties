library(ggplot2)
library(dplyr)
library(rvest)
require(maps)
require(viridis)

# dataset of virginia counties with longs/lats
county = map_data("county")
VAcounties = county %>% filter(region == "virginia")
VAcounties1 = VAcounties %>% group_by(subregion) %>% summarise(count = n())

# map of virginia with counties colored differently
#ggplot(VAcounties, aes(x = long, y = lat)) +
#  geom_polygon(aes(group = group, fill = subregion)) +
#  scale_fill_viridis_d() + 
#  theme_void() +
#  theme(legend.position = "none")

########## Scraping

# scraping data from wikipedia - link
populationWiki = "https://en.wikipedia.org/wiki/List_of_cities_and_counties_in_Virginia"
pop = read_html(populationWiki)

# county name from wikepedia link
countyName = pop %>% html_nodes("tbody th a") %>% html_text()
View(countyName)
countyName = countyName[c(7:101, 107:144)] #all the counties and all the cities

# population from wikipedia link
populations = pop %>% html_nodes("td:nth-child(7) span") %>% html_text()
View(populations)

########## Data Wrangling, Creating population dataset based on virginia counties

# merge population and counties from wikipedia
countyPop = data.frame(countyName, populations)

# Since Wikipedia had different counties than the R dataset, this gets all the 
# necessary counties and gets rid of the uncessary ones from wikipedia
countyPopsFinal = countyPop[c(1:95, 110, 118, 119, 129, 130),]
countyPopsFinal = countyPopsFinal %>%
  mutate(county = gsub(" County", "", countyName))
countyPopsFinal$county = tolower(countyPopsFinal$county)
countyPopsFinal = countyPopsFinal %>% select(county, populations)

# join wikipedia population with the R dataset based on county
countiesWPops = VAcounties %>% inner_join(countyPopsFinal, by = c("subregion" = "county"))
#make population a numeric vector
countiesWPops = countiesWPops %>%
  mutate(population = gsub(",", "", populations)) %>%
  mutate(pop = as.numeric(population)) %>%
  select(long, lat, group, order, region, subregion, pop)

########## Centroid dataset for graph

#getting centroids of each county for dots for graph later
centroid = countiesWPops %>%
  group_by(subregion) %>%
  summarise(longAVG = mean(long), latAVG = mean(lat))

# join centroid dataset with the final dataset from above to get populations into centroid dataset
centroidPops = centroid %>%
  inner_join(countyPopsFinal, by = c("subregion" = "county"))

#make population a numeric vector
centroidPops = centroidPops %>%
  mutate(population = gsub(",", "", populations)) %>%
  mutate(pop = as.numeric(population)) %>%
  select(longAVG, latAVG, subregion, pop)

########## Map Graph

#map with populations colored differently 
options(scipen=10000) # make numbers non scientific notation

ggplot(centroidPops, aes(longAVG, latAVG)) + 
  # makes the map with counties colored by subregion, ensures no legend for colors of counties
  geom_polygon(data = countiesWPops, aes(long, lat, fill = subregion), show.legend = FALSE) +
  scale_fill_viridis_d() +
  # makes sure VA is properly sized (ie not squished)
  coord_quickmap() +
  # makes dots in center and colors them/sizes them based on county pop, makes them semi translucent to show the counties
  geom_point(data = centroidPops, aes(longAVG, latAVG, size = pop), alpha = .7) +
  # makes the legend titel "Population"
  labs(size = "Population") +
  #determines max size of dots
  scale_size_area(max_size = 10) +
  #changes axis labels and title
  xlab("Longitude") + ylab("Latitude") + ggtitle("Relative Populations of VA Counties") +
  #center aligns title
  theme(plot.title = element_text(hjust = .5))
