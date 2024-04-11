#rvest + bookstore

pacman::p_load(rvest, tidyverse)
url1 ='https://docs.google.com/document/d/e/2PACX-1vQqYbrHu5BNarYNZlH75WRpjcYoUlq8RDc68p3YOF6GL0IDqjF7kR7wp0m2Sx7aGL2Z4DaAVt5gUoUr/pub'

page <- read_html(url1)
page

page %>% html_elements(xpath ='bookstore')
