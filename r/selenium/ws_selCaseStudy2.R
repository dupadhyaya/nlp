# selenium 2 case study

pacman::p_load(RSelenium, tidyverse, wdman, netstat)

binman::list_versions('chromedriver')

#rsDriver <- rsDriver(browser='chrome', chromever = '123.0.6312.105', verbose=F, port =free_port())


eCaps <- list(chromeOptions = list( args = c('--headless', '--disable-gpu', '--window-size=1280,800')
))

eCaps2 <- list(chromeOptions = list( args = c('--window-size=1280,800')
))
#rD <- rsDriver(browser=c("chrome"), verbose = F, chromever="123.0.6312.105", port=4447L, extraCapabilities = eCaps2) 

free_port()
rD <- rsDriver(browser="chrome", verbose = F, chromever="123.0.6312.105", port=14415L)
