# RSelenium + Chrome
#https://www.youtube.com/watch?v=BnY4PZyL9cg

pacman::p_load(RSelenium, tidyverse, netstat, binman)

#loc of chrome driver
binman::list_versions('chromedriver')
chromeCommand <- chrome(retcommand = T, version='123.0.6312.105', verbose=T, check=T)
chromeCommand
?chrome
binman::list_versions('chromedriver')

rs_driver_object <- rsDriver(browser = 'chrome',  chromever = '123.0.6312.105', verbose=F)

#this worked

rs_driver_object$client
