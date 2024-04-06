#web scraping in R

#https://www.youtube.com/watch?v=l37n_HDD1qs

pacman::p_load(robotstxt, rvest, selectr, xml2, dplyr, stringr, forcats, tidyr, ggplot2, lubridate, tibble, purrr)
#robots - can we scrape data

url1 ='https://amity.edu'
paths_allowed(url1)

url2='https://www.amazon.in/best-new-mobile-phones/s?k=best+new+mobile+phones'
paths_allowed(url2)

bestPhones <- read_html(url2)
bestPhones 
bestPhones %>% html_nodes('span')  %>% html_attr('class')
bestPhones %>% html_elements('a')
bestPhones %>% html_nodes('.target span')

