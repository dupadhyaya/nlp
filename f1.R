#libraries

library(rvest)

# Start by reading a HTML page with read_html():
w1 = "https://www.topuniversities.com/university-rankings/university-subject-rankings/2023/arts-humanities?&tab=indicators"

qssubject <- read_html(w1)

qssubject %>% html_element('section')
qssubject %>% html_element('h2')



#one element
title <- films %>%  html_element("h2") %>%  html_text2()

library(RSelenium)

remDr <- remoteDriver()
remDr$open()

rsDriver()

rD <- RSelenium::rsDriver(...)


remDR <- remoteDriver(remoteServerAddr = 'localhost', port = 4445L, browserName = 'chrome')
remDr$open()


RSelenium::checkForServer()

wdman::selenium()
sel$log()

binman::list_versions("seleniumserver")
binman::list_versions("chromedriver")
binman::list_versions("geckodriver")
binman::list_versions("phantomjs")



