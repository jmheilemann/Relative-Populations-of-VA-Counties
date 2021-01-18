Using R, I created a map of Virginia, with the relative population sizes of each county marked with a differently sized dot. 

I first utilized the maps package to get a dataset of every county in every state in the USA. Then, I selected just the counties in Virginia.
Next, I got the population size of every VA county from this Wikipedia article: https://en.wikipedia.org/wiki/List_of_cities_and_counties_in_Virginia. 
Using data scraping techniques, I isolated every county and its population from the Wikipedia article that also appeared in the built in R dataset. 
After combining these two datasets, I created another dataset that included the average latitude and longitude for each county, which is the centroid.
In the centroid dataset, I also included the populations for each county.
Finally, I used all this data to create the map. There is one layer for the map, and one layer for the dots. 
