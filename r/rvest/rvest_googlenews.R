# rvest

pacman::p_load(rvest, tidyverse)

url ='https://news.google.com/home?hl=en-IN&gl=IN&ceid=IN:en'

html <- rvest::read_html(url)
html

html %>% html_nodes('.WwrzSb')  %>% html_text2()
html %>% html_nodes('a')  %>% html_text2() %>% writeLines()
html %>% html_nodes('a')  %>% html_attr(x) html_text2() %>% writeLines()
html %>% html_nodes('aWwrzSb')  %>% html_text2() %>% writeLines()
html %>% html_nodes('a') %>% html_attr(class, 'WwrzSb')

html %>% html_element('h3') %>% html_text()
html %>% html_element('h3') %>% html_text2()
html %>% html_node('h3') %>% html_text()
html %>% html_node('h3') %>% html_node('a') %>% html_text()
html %>% html_nodes('.Ly25Ed') %>% html_text2() %>% writeLines()
html %>% html_nodes('.W8yrY') %>% html_text2() %>% writeLines()
html %>% html_nodes('.W8yrY') %>% html_nodes('.WwrzSb') %>% html_text2() %>% writeLines()

html %>% html_nodes('.iNL53') %>% html_text2() 
