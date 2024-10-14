#selenium case study

pacman::p_load(RSelenium, tidyverse, wdman, netstat)

binman::list_versions('chromedriver')
rsDriver <- rsDriver(browser='chrome', chromever = '129.0.6668.89', verbose=F, port =free_port())
remDr <- rsDriver$client()

remDrCH <- rsDriverCH[['client']]
remDrCH$open()

remDr <- rsDriver$client
remDr$open()
url1 ='https://statisticsglobe.com'
rsDriver()$open(url1)
remDr$navigate(url1)
remDr$getTitle()
remDr$getCurrentUrl()
#remDr$maxWindowSize()
remDr$findElement(using='link text', 'R programming')
?remDr$findElement
#remDr$findElements(using='link text', 'R programming')$clickElement()
remDr$goBack()
remDr$goForward()
remDr$refresh()
r_dropdown <- remDr$findElement(using='link text', 'R programming')
remDr$findElement(using='')

#search------
(e1 <- remDr$findElement(using='name','__uspapiLocator'))
e1$getElementAttribute('name')
e1$getElementAttribute('id')
e1$getElementAttribute('class')


(e2 <- remDr$findElement(using ='id', value='page-content'))
e2
e2$highlightElement()


(e2b <- remDr$findElement(using ='id', value='mc_embed_signup'))
e2b
e2b$highlightElement()
e2b$getElementAttribute('type')
#class-----

e3 <- remDr$findElement(using='class', value='rt-container-fluid')
e3
e3$highlightElement()


#css selector----
e4 <- remDr$findElement(using ='css', "[name='mc-embedded-subscribe-form']")
e4
e4$highlightElement()

e4b <- remDr$findElement(using ='css', "form[name='mc-embedded-subscribe-form']")
e4b
e4b$highlightElement()

#e4b$compareElements(e4)

#e4c = remDr$findElement(using='css', 'id#rt-tpg-container-207714206')


#https://cran.r-project.org/web/packages/RSelenium/vignettes/basics.html