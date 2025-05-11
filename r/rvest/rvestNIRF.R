# Rvest 0 NIRF

pacman::p_load(rvest, tidyverse, purrr, RCurl)

url1 = 'https://www.nirfindia.org/Rankings/2024/OverallRanking.html'
url.exists(url1)
# Read the HTML page
page <- read_html(url1)
page
#list all elements
# Get all nodes (tags)
all_nodes <- page %>% html_elements(xpath = "//*")  # select all tags
all_nodes
# View tag names
tag_names <- all_nodes %>% html_name()

# Frequency table of tag types
table(tag_names)

tag_info <- data.frame(
  tag = all_nodes %>% html_name(),
  class = all_nodes %>% html_attr("class"),
  id = all_nodes %>% html_attr("id")
)

head(tag_info)
tag_info

# Pretty print the HTML tree for first few elements
all_nodes[1:10] %>% purrr::walk(~ cat(as.character(.x), "\n\n"))

library(xml2)

xml_structure(page)

#--------------------

url24 = 'https://www.nirfindia.org/Rankings/2024/OverallRanking.html'
# Read the HTML page
page24 <- read_html(url24)
# Find all tables
tables24 <- page24 %>% html_elements("table")
# Check how many tables found
length(tables24)
# Extract the table (usually first one)
nirfT24 <- tables24[[1]] %>% html_table(fill = TRUE)
# View the result
head(nirfT24)
dim(nirfT24)
nirfT24b <- nirfT24 %>% janitor::clean_names() 
head(nirfT24b)
nirfT24b %>% select(1,2, 8, 9, 10, 11, 12, 13,14,15, 16) %>% slice(1,4)
nirfT24c <- nirfT24b %>% select(1,2, 8, 9, 10, 11, 12, 13,14,15, 16) %>% slice(seq(1,300,3)) %>%  set_names(c("instituteID", "name", "TLR", "RPC", "GO", "OI", "PR", "city", "state", "score",'rank')) %>% mutate(name = str_remove(name, "More.*$")) %>% mutate(domain='OVL', nyear=2024)
head(nirfT24c[,1:4])
head(nirfT24c)
#------
#N23-Overall
url23 = 'https://www.nirfindia.org/Rankings/2023/OverallRanking.html'
# Read the HTML page
page23 <- read_html(url23)
tables23 <- page23 %>% html_elements("table")
# Check how many tables found
length(tables23)
nirfT23 <- tables23[[1]] %>% html_table(fill = TRUE)
head(nirfT23)
dim(nirfT23)
nirfT23b <- nirfT23 %>% janitor::clean_names() 
head(nirfT23b)
nirfT23b %>% select(1,2, 8, 9, 10, 11, 12, 13,14,15, 16) %>% slice(1,4)
nirfT23c <- nirfT23b %>% select(1,2, 8, 9, 10, 11, 12, 13,14,15, 16) %>% slice(seq(1,300,3)) %>%  set_names(c("instituteID", "name", "TLR", "RPC", "GO", "OI", "PR", "city", "state", "score",'rank')) %>% mutate(name = str_remove(name, "More.*$")) %>% mutate(domain='OVL', nyear=2023)
head(nirfT23c[,1:4])
head(nirfT23c)
#------

#N22-Overall
url22 = 'https://www.nirfindia.org/Rankings/2022/OverallRanking.html'
# Read the HTML page
page22 <- read_html(url22)
tables22 <- page22 %>% html_elements("table")
# Check how many tables found
length(tables22)
nirfT22 <- tables22[[1]] %>% html_table(fill = TRUE)
head(nirfT22)
dim(nirfT22)
nirfT22b <- nirfT22 %>% janitor::clean_names()
head(nirfT22b)
nirfT22b %>% select(1,2, 8, 9, 10, 11, 12, 13,14,15, 16) %>% slice(1,4)
nirfT22c <- nirfT22b %>% select(1,2, 8, 9, 10, 11, 12, 13,14,15, 16) %>% slice(seq(1,300,3)) %>%  set_names(c("instituteID", "name", "TLR", "RPC", "GO", "OI", "PR", "city", "state", "score",'rank')) %>% mutate(name = str_remove(name, "More.*$")) %>% mutate(domain='OVL', nyear=2022)
head(nirfT22c[,1:4])
head(nirfT22c)
#------

#summarise/group/plot-------
library(treemapify)
nirfO = do.call(list(nirfT24c, nirfT23c, nirfT22c), what = 'rbind')
dim(nirfO)

nirfO %>% group_by(name) %>% summarise(n=n())
nirfO %>% group_by(state, nyear) %>% summarise(n=n())

T1='Count of Institutions by State in NIRF Overall Years - 22 to 24'
nirfO %>% group_by(state) %>% summarise(n=n()) %>% ggplot(., aes(area=n, fill=state, label=paste(state, n))) + geom_treemap() + guides(fill='none') + geom_treemap_text() + labs(title=T1)
nirfO %>% group_by(state, nyear) %>% summarise(n=n()) %>% ggplot(., aes(area=n, fill=state, label=paste(state, n))) + geom_treemap() + guides(fill='none') + treemapify::geom_treemap_text(color='white', place='center', size=6, grow=T) + labs(title=T1) + facet_wrap(nyear ~ . ,scales='free')


#%>% treemapify(., area='n', fill='state')


74/2830
