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

html1 %>% html_nodes('.dup1')

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
html2 %>% html_nodes('link')  %>% html_attr(name='href')
html2 %>% html_nodes('link')  %>% html_attr(name='rel')
html2 %>% html_nodes('div') %>% html_attr('class')
html2 %>% html_nodes('div') %>% html_attr(class='c18')
html2 %>% html_nodes(xpath ="//div[@class='c18 doc-content']")
html2 %>% html_nodes(xpath ="//*[@id='contents']/div/p[3]")%>% html_text()

xp2 ='//*[@id="contents"]/div/table/tbody/tr[2]/td[4]/p/span'
xp2 = '//div/table/tbody/tr[2]/td[4]'

html2 %>% html_nodes(xpath=xp2) %>% html_text()

html_elements(html2, css='title')
html2 %>% html_elements(css='title')
html2 %>% html_elements('td.c20')
html2 %>% html_elements(xpath='//div[2]/div/table')
html2 %>% html_elements(xpath='//html')  %>% html_text() %>% writeLines()
html2 %>% html_elements(xpath='//html/body')  %>% html_text() %>% writeLines()
html2 %>% html_elements(xpath='//html/body/div')  %>% html_text(trim=T) %>% writeLines()
html2 %>% html_elements(xpath='//html/body/div')  %>% html_text() %>% writeLines()
html2 %>% html_elements(css='span.c1')  %>% html_text() 
html2 %>% html_elements(css='tr.c13')  %>% html_text() 
html2 %>% html_elements('.c25')  %>% html_text()

html2 %>% html_nodes('table.tablesorter')
html2 %>% html_elements(css='p')
html2 %>% html_elements(css='.title')
html2 %>% html_elements(css='p.special')
html2 %>% html_nodes()
html2 %>% html_

#------------
html3 <- rvest::read_html("https://www.amity.edu")
html3
html3 %>% html_elements('.landing_page')
html3 %>% html_elements('#page-top') %>% html_text()
html3 %>% html_elements('p')
html3 %>% html_elements('p a')
html3 %>% html_elements('a')  %>% html_attrs()
html3 %>% html_elements('a')  %>% html_attr('href')
html3 %>% html_elements('a')  %>% html_attr('class')  %>% head()
html3 %>% html_nodes(css='a') %>% html_text()
html3 %>% html_nodes(css='[href]') %>% html_text()
html3 %>% html_nodes(css='[class="closesearch"]') %>% html_text()
html3 %>% html_nodes('.closesearch')
html3 %>% html_nodes('[class]')
html3 %>% html_nodes('[class=row]')
html3 %>% html_nodes('div a')
html3 %>% html_nodes('div p')
html3 %>% html_nodes('div > p')
html3 %>% html_nodes('.row') %>% length()
html3 %>% html_nodes('.container .admission_menu')
html3 %>% html_nodes('.row .mega_menu_left')
html3 %>% html_nodes('.mega_menu_left.col-lg-3')
html3 %>% html_nodes(css='[target="_blank"]')


?html_nodes
#https://www.w3schools.com/cssref/css_selectors.php

