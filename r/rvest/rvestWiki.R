# Rvest - dynamic web scraping

pacman::p_load(rvest, dplyr, stringr, purrr, tidyr, RCurl)

#link-----
link = "https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes"
browseURL(link)
RCurl::url.exists(link)

#read html-----
webpage = read_html(link)

elem = webpage %>%  html_element("table.sortable")
elem

#extract table-----
df <- html_table(elem, header=F)
head(df)
cnames = c('country','offName', 'sovereignity', 'A2','A3','A4','codeLink','TLD')

names(df) = cnames
head(df)
tail(df)

df = df[-1:-2,] # remove first two rows
head(df)

