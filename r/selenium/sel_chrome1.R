# RSelenium + Chrome
#https://www.youtube.com/watch?v=BnY4PZyL9cg

pacman::p_load(RSelenium, wdman, tidyverse, netstat, binman)

#loc of chrome driver
binman::list_versions(appname='chromedriver')
wdman:::chrome_check(verbose=T)

#using wdman-------
#https://docs.ropensci.org/wdman/articles/basics.html
cDrv <- wdman::chrome(retcommand = T, version='129.0.6668.89', verbose=F, check=T)
class(cDrv)

wdman:::chrome_check(verbose=T)
binman::list_versions(appname='chromedriver')['mac64_m1']

#using RSelenium-------

remDr <- RSelenium::rsDriver(browser = 'chrome',  chromever = NULL, verbose=F, port= netstat::free_port())

remDr$client
#this worked
remDrCS <- remDr$client # clientside

url1 ='https://amity.edu'
remDrCS$navigate(url1)
remDrCS$navigate(url1)
rs_driver_object$client
