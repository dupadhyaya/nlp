# RSelenium + Chrome
#https://www.youtube.com/watch?v=BnY4PZyL9cg

pacman::p_load(RSelenium, tidyverse, netstat, binman)

#loc of chrome driver
chromeCommand <- chrome(retcommand = T, verbose=T, check=T)
chromeCommand

binman::list_versions('chromedriver')

rs_driver_object <- rsDriver(browser = 'chrome',  chromever = '123.0.6312.105', verbose=F)

#this worked
