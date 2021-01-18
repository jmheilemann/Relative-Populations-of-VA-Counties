Using R, I created a map of Virginia, with the relative population sizes of each county visualized with differently sized dots (larger counties have larger dots, etc).

Attached is my code and a PNG of the resulting graph. I decided to work on this to solidify my understanding of R, as well as get more comfortable with ggplot.

This graph shows which counties in VA have the largest and smallest populations relative to each other. Fairfax County, in the top right of the state, has
the largest population, while many western counties are quite small. 

I used data harvesting and wrangling techniques to get the population sizes for each county from this wikipedia article: https://en.wikipedia.org/wiki/List_of_cities_and_counties_in_Virginia
The original dataset with the longitudes and latitudes of each county in VA is from the built-in maps package in R. 
