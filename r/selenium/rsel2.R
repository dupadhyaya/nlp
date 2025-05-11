
library(RSelenium)

remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4447L,
  browserName = "chrome"
)
remDr$open()
remDr$navigate("https://www.google.com/")
