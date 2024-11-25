# RSelenium + Chrome : working

library(RSelenium)
pacman::p_load(tidyverse, RSelenium, wdman, xml2, magrittr, dplyr, purrr, stringr, rvest, httr, jsonlite)


rD <- rsDriver(browser = "firefox", chromever = NULL)
remDr <- rD$client

remDr$navigate("https://www.worldometers.info/coronavirus/")
remDr$navigate("https://amity.edu")
remDr$getTitle()

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

#part2--------
remDr$navigate("https://www.worldometers.info/coronavirus/")

# Extract the total number of cases
total_cases <- remDr$findElement(using = "xpath",  value = '//*[@id="maincounter-wrap"]/div/span')
total_cases
total_cases <- total_cases$getElementText()[[1]]
total_cases

# Extract the total number of deaths
total_deaths <- remDr$findElement(using = "xpath", value = '/html/body/div[3]/div[2]/div[1]/div/div[6]/div/span')
total_deaths <- total_deaths$getElementText()[[1]]

# Extract the total number of recoveries
total_recoveries <- remDr$findElement(using = "xpath",  value = '/html/body/div[3]/div[2]/div[1]/div/div[7]/div/span')
total_recoveries <- total_recoveries$getElementText()[[1]]
total_recoveries

# Print the extracted data
cat("Total Cases: ", total_cases, "\n")
cat("Total Deaths: ", total_deaths, "\n")
cat("Total Recoveries: ", total_recoveries, "\n")

# Close the server
remDr$close()
selServ$stop()


#part3------
library(RSelenium)
library(rvest); library(selenium)
?selenium
# Start RSelenium server
dir(path = "/Applications/Google\ Chrome.app/Contents/MacOS/", full.names = TRUE)
selServ <- selenium(jvmargs = c("-Dwebdriver.chrome.driver=/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"))
selServ
remDr <- remoteDriver(port = 4445L, browserName = "chrome")
remDr$open()

# Navigate to BBC News website
remDr$navigate("https://www.bbc.com/news")

# Wait for the page to load
Sys.sleep(5)

# Find the top 5 articles
article_links <- remDr$findElements(using = "css", "#top-story a")

# Extract the titles and URLs of the top 5 articles
article_titles <- sapply(article_links[1:5], function(x) x$getElementText())
article_urls <- sapply(article_links[1:5], function(x) x$getElementAttribute("href"))

# Print the titles and URLs
for (i in 1:5) {
  cat(paste0(i, ". ", article_titles[i], "\n"))
  cat(article_urls[i], "\n\n")
}

# Close the browser and stop the server
remDr$close()
selServ$stop()