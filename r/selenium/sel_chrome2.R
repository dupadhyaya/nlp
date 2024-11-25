# Selenium - Introduction / Setup

# Selenium is a web automation tool. It is a web browser automation tool that can be used to automate web browsers across many browsers and operating systems. Selenium is a suite of tools that supports rapid development of test automation scripts for web-based applications. Selenium is a free (open source) automated testing suite for web applications across different browsers and platforms. It is quite similar to HP Quick Test Pro (QTP now UFT) only that Selenium focuses on automating web-based applications. Selenium is not just a single tool but a suite of software, each catering to different testing needs of an organization. It has four components.

library(RSelenium)
pacman::p_load(RSelenium, wdman, xml2, magrittr, dplyr, purrr, stringr, rvest, httr, jsonlite, netstat)

selenium()
selenium_object <- selenium(retcommand =T, check=F)
selenium_object

chromeCommand <- chrome(retcommand=T, verbose=T, check=F)
chromeCommand
?chrome
binman::list_versions('chromedriver')
cver = '129.0.6668.89'
?free_port()
rsDriverCH <- rsDriver(browser='chrome', chromever = cver, verbose=T, check=F, port = free_port())
class(rsDriverCH)

remDrCH <- rsDriverCH[['client']]
remDrCH$open()

url1 ='https://statisticsglobe.com'

remDrCH$navigate(url1)

