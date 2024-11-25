#selenider 
#install.packages("selenium", "selenider")
#https://medium.com/technology-nineleaps/how-to-use-selenium-in-r-b4c92cc3be70
#https://github.com/rstudio/chromote
#https://rstudio.github.io/chromote/

pacman::p_load(selenium, selenider, dplyr, chromote)

# Start a Selenium session with Chrome
session <- selenider_session("selenium", browser = "chrome")

b <- ChromoteSession$new()
b$view()
b$Browser$getVersion()
b$Page$navigate("https://www.r-project.org/")
nirfL = 'https://www.nirfindia.org/'
b$Page$navigate(nirfL)
?Chrome
Chrome$new()
Chrome$new(path = find_chrome(), args = get_chrome_args())
Chrome$get_path()

b1 <- ChromoteSession$new(width = 1500,   height = 1000,  targetId = NULL, wait_ = TRUE)
b1$Page$navigate(paste0(nirfL,'/Rankings/2024/Ranking.html'))
b1$view()
class(b1)
b1$get_host()
b1$Browser$getVersion()
#b1$url('https://amity.edu')

find_chrome()
default_chromote_object()
default_chrome_args()
b1$is_active()
b1$Browser$getVersion()
str(b1$Browser$getVersion())
#---------
x <- b1$DOM$getDocument()
x

b1$Page$navigate("https://www.r-project.org/")

b1$close()
b1$parent$close()

#P2--------
b1$Page$loadEventFired()
b1$Page$timestamp
m <- b1$parent
m$get_sessions()
m$view()
m$connect$navigate(nirfL)

pacman::p_load(XML, rvest)
b1$Page$navigate(paste0(nirfL,'/Rankings/2024/Ranking.html'))

data <- b1$Runtime$evaluate("document.querySelector('css_selector').innerText")$result$value
print(data)

b1$Runtime$evaluate("document.querySelector('button#submit').click()")

b1$Pa
s(".row") |>
  find_element("div") |>
  find_elements("a") |>
  elem_find(has_text("CRAN")) |>
  elem_expect(attr_contains("href", "cran.r-project.org")) |>
  elem_click()

s("dl") |>
  find_elements("dt") |>
  elem_find(has_text("UK")) |>
  find_element(xpath = "./following-sibling::dd") |>
  find_elements("tr") |>
  find_each_element("a") |>
  elem_expect(has_at_least(1)) |>
  as.list() |>
  lapply(
    \(x) x |>
      elem_attr("href")
    