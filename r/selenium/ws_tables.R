#scrape table using rvest & Selenium
#https://www.youtube.com/watch?v=Dkm1d4uMp34
#https://github.com/ggSamoora/TutorialsBySamoora/blob/main/Salary_Scraper.R
pacman::p_load(rvest, RSelenium, binman, netstat, tidyverse, data.table)

binman::list_versions('chromedriver')
#chrome://version

rs_driver_object <- rsDriver(browser = 'chrome',  chromever = '123.0.6312.105', verbose=F, port = free_port())

remDr <- rs_driver_object$client
remDr$open()

(url1 = "https://salaries.texastribune.org/search/?q=%22Department+of+Public+Safety%22")

remDr$navigate(url1)
#xpath1 to table //*[@id="pagination-table"]

data_table <- remDr$findElement(using ='id', 'pagination-table')
data_table
#next page
#xpath : //*[@id="pagination-table-wrapper"]/ul/li[2]/a
next_button <- remDr$findElement(using='xpath', '//a[@aria-label="Next Page"]')

next_button <- remDr$findElement(using='xpath', '//a[@aria-label="Next Page"]')
next_button$clickElement()

#now put in table and move page wise------
remDr$navigate(url1)
#select the area of table
data_table_html <- data_table$getPageSource()
data_table <- remDr$findElement(using ='id', 'pagination-table')
page <- read_html(data_table_html %>% unlist())  #understand this
page
df <- html_table(page)
df
df[[1]]
# we need 2nd table----
df[[2]]
head(df[[2]])
tail(df[[2]])
#------
df <- html_table(page)  %>% .[[2]]
head(df)
dim(df)  #25 x4


#for complete data------

all_data <- list()
cond <- TRUE
while (cond == TRUE) {
  data_table_html <- data_table$getPageSource()
  page <- read_html(data_table_html %>% unlist())
  df <- html_table(page) %>% .[[2]]
  all_data <- rbindlist(list(all_data, df))
  Sys.sleep(0.2)
  tryCatch(
    {
      next_button <- remDr$findElement(using = 'xpath', '//a[@aria-label="Next Page"]')
      next_button$clickElement()
    },
    error=function(e) {
      print("Script Complete!")
      cond <<- FALSE
    }
  )
  
  if (cond == FALSE){
    break
  }
}
head(all_data)
names(all_data)
colnames(all_data)[3] <- "Agency"
names(all_data)
names(all_data) <- c('name','title','agency','salary')
head(all_data)
#remove $ & , from salary and make the col numeric
all_data$salary <- str_remove_all(all_data$salary, "[$,]") %>% 
  as.numeric()
head(all_data)
str(all_data)
#write_csv(all_data, "Texas_Dept_of_Safety_Salaries.csv", na = "")