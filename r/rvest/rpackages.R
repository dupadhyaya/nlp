# google packages

pacman::p_load(rvest, tidyverse, googlesheets4)
gslib = '16MI3-H5bS2gHKHzEN80XezADaDrTmI3_L5eXCqZaeQo'

rlink1 = 'https://cran.r-project.org/web/packages/available_packages_by_date.html'

dfr <- rlink1 %>% read_html() %>% html_table() %>% as.data.frame()
head(dfr)
dfr %>% mutate(Title = stringr::str_trim(Title))  %>%  write_sheet(. , ss=gslib, sheet='rname')

?write_sheet()
?read_this

nirf1 ='https://www.nirfindia.org/Rankings/2024/OverallRanking.html'
nirfDF <- nirf1 %>% read_html() %>% html_table() %>% as.data.frame()
head(nirfDF)
