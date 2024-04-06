# Selenium
#https://youtu.be/PNz6ZZhUvAw

pacman::p_load(RSelenium, tidyverse, netstat, wdman, binman)

#----
selenium()  #download all webdrivers

selenium_object <- selenium(retcommand =T, check=T)
selenium_object
#path-C:\Users\dupad_el7s75\AppData\Local\binman\binman_chromedriver\win32\113.0.5672.63
#delete license.chromedriver
#ver 114.0.3735.90 123.0.6312.106

binman::list_versions('chromedriver')
binman::list_versions('firefox')

#latest-
remote_driver <- rsDriver(browser='chrome', version = '123.0.6312.106', port = free_port())
rd <- rsDriver(browser = 'chrome', port=free_port(), verbose=T)
rd <- rsDriver(browser='firefox',port=free_port())

remdr <- remoteDriver(remoteServerAdd='localhost', browser='firefox', port=free_port())
remdr$open()

cprof <- getChromeProfile('C:\\Users\\dupad_el7s75\\AppData\\Local\\Google\\Chrome\\User\ Data','Profile 1')
cprof
remDr <- remoteDriver(browserName='chrome', extraCapabilities=cprof)
remDr

mydriver <- rsDriver(browser = c('firefox'))



rD <- rsDriver()

remDr <- remoteDriver(remoteServerAddr = 'localhost')
remDr$open()
