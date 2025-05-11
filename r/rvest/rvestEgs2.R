# Rvest - Country, Population
#https://rvest.tidyverse.org/articles/selectorgadget.html

pacman::p_load(rvest, tidyverse)

#url
url = "https://scrapethissite.com/pages/simple/"
website <- read_html(url)

# Extracting the country names
element_country <- html_elements(website, css = "h3")
element_country
text_country <- html_text(element_country, trim = TRUE)
text_country
#other sub-parts 
website %>%  html_elements(css = "span") %>% html_text() %>%  head(n = 10)
#So we have to tell html_elements() more precisely which <span> we are interested in. This is where the CSS classes we mentioned earlier come into play. These differ between the three countries’ information. For example, the <span> that includes the name of the capital city is assigned the class "country-capital"
(capital <- website %>%  html_elements(css = "span.country-capital") %>%  html_text())
(population <- website %>% html_elements(css = "span.country-population") %>%  html_text() %>% as.numeric())
(area <- website %>%  html_elements(css = "span.country-area") %>%  html_text() %>%  as.numeric())

#Extracting Table Data
countries <- tibble(
  Country = country,
  Capital = capital,
  Population = population,
  Area_sqkm = area
)
head(countries)


#Example2---------
#https://jakobtures.github.io/web-scraping/css-selectors-developer-tools.html
website2 <- "https://jakobtures.github.io/web-scraping/turnout.html" %>% read_html()

website2 %>% html_elements(css = "title") %>% html_text2()
website2 %>% html_elements(css = ".state-name") %>% head(n = 2) #elect all elements of the class "state-name"
website2 %>% html_elements(css = "span.state-name") %>% head(n = 2) #select all <span> elements of the class "state-name"
#both variations are equivalent in result, since all elements assigned the class "state-name" are also <span> tags. However, this does not always have to be the case. Different tags with different content may very well have the same class in practice.

website2 %>% html_elements(css = "body > div#data > div[class^=state-] > span.state-name") %>% head(n = 2)
website2 %>% html_elements(css = "#bw")
website2 %>% html_elements(css = "span#bw") #better, more specific tags
website2 %>% html_elements(css = "span.state-name#bw")


#hierarchical Levels--------
#Descendant
#select all <span> tags that descend from the <div id="data"> tag – that is, a grandchild-grandparent relationship
website2 %>%  html_elements(css = "div#data span") %>% head(n = 6)
# we can only select younger generations with CSS Selectors.
website2 %>%  html_elements(css = "body div#data div span") %>% head(n = 6)

#child/parent "B > A"------
website2 %>% html_elements(css = "div[class^='state'] > span") %>% head(n = 6)
#The ">" operator selects only the direct children of the parent element. In this case, it selects all <span> tags that are direct children of a <div> tag with a class that starts with "state-". The result is the same as before, but the CSS Selector is more specific.
#If we do not want to select all children, but only certain ones, there are a number of options.
website2 %>%  html_elements(css = "div[class^='state'] > :first-child") %>%  head(n = 2)
website2 %>% html_elements(css = "div[class^='state'] > span:nth-child(2)") %>% head(n = 2)
#select all <span> tags that are the second child of the <div> tags whose classes start with "state"
website2 %>% html_elements(css = "div[class^='state'] > span:last-child") %>% head(n = 5)

#Siblings--------
#The "+" operator selects the next sibling of the selected element. The "~" operator selects all siblings that follow the selected element.
website2 %>%  html_elements(css = "div[class^='state'] img ~ span") %>% head(n = 6)

website2 %>% html_elements(css = "img ~ span") %>% head(n = 6)

website2 %>% html_elements(css = "img + span") %>% head(n = 2)

website2 %>% html_elements(css = "div[class^='state'] > span:first-of-type") %>%  head(n = 2)
website2 %>% html_elements(css = "div[class^='state'] > span:nth-of-type(2)") %>% head(n = 2)
website2 %>% html_elements(css = "div[class^='state'] > span:last-of-type") %>%  head(n = 2)

#otherSelectors-----
#"*" selects all elements
website2 %>%  html_elements(css = "div[class^='state'] > *") %>% head(n = 8)

#excludes certain elements
website2 %>% html_elements(css = "div[class^='state'] > :not(img)") %>% head(n = 6)
#"selector-A, selector-B", several selectors can be linked with “and/or”
website2 %>% html_elements(css = "div[class^='state'] > span.election-year, div[class^='state'] > span.election-turnout") %>% head(n = 4)


#tables------
#https://jakobtures.github.io/web-scraping/rvest2.html#scraping-of-tables


