# RSelenium + Chrome : working

library(RSelenium)
pacman::p_load(RSelenium, wdman, xml2, magrittr, dplyr, purrr, stringr, rvest, httr, jsonlite)


binman::list_versions('firefox')
cver = '129.0.6668.89'
rsDriverFF <- rsDriver(browser='firefox', chromever = NULL, verbose=F, port =free_port())

remDrFF <- rsDriverFF[['client']]
remDrFF$open()

url1 = 'https://documents.un.org/'
remDrFF$navigate(url1)

#title-----
remDrFF$getTitle()

#stop------
rsDriverFF$server$stop() # stopped


#notworking from here-------
#search------
searchbutton_Element <- remDrFF$findElement(using="css", value="input#search")
# Click it
searchbutton_Element$clickElement()
