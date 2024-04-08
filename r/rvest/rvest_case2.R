# rvest + purrr

pacman::p_load(rvest, tidyverse)


# rvest::read_html()
# purrr::map()
# rvest::html_nodes()
# rvest::html_text()
# rvest::html_attr()

wpage1 = './webpages/wpage1.html'

html1 <- read_html(wpage1)
html1
html1 %>% html_node('h1') %>% html_text2()

html1 %>% html_nodes('p')
html1 %>% html_nodes('p') %>% html_attr('id', 'dup1')

html %>% html_nodes('.dup1')

urlGD = 'https://docs.google.com/document/d/1N7w-FG7if82ivdlG7oSxq2Sxag6zAgUvnWO8kpcpPuI/edit#heading=h.gy8wuo2rw6h'
url3 ='https://docs.google.com/document/d/e/2PACX-1vSUcWrXB3Dwy7WZ29_LIL5JbRTPRyvBHMfmb6oMYdKx5OebaHVu7aM7ESEJR6KVUT7D4Z-V3la30Z-r/pub'
read_html(url3)

html2 <- read_html(url3)
html2 %>% html_element('table')  %>% html_text()
html2 %>% html_nodes(xpath='//table//a')
tables <- html2 %>% html_table() 
tables
length(tables)
html2 %>% html_nodes('table')
