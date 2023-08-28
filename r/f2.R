#libraries

library(rvest)

?rvest

#rvest helps you scrape (or harvest) data from web pages. It is designed to work with magrittr to make it easy to express common web scraping tasks, inspired by libraries like beautiful soup and RoboBrowser.

# Start by reading a HTML page with read_html():
w1 = "https://rvest.tidyverse.org/articles/starwars.html"
starwars <- read_html(w1)


films = starwars  %>% html_elements('section')
films


#one element
title <- films %>%  html_element("h2") %>%  html_text2()