# search for set of words in a text in column

paman::p_load(tidyr)

# Sample data frame
data <- data.frame(
  ID = 1:5,
  TextColumn = c("apple", "banana", "apple pie", "cherry", "banana bread")
)

# Add a tag column when "apple" is found in TextColumn
data$Tag <- ifelse(grepl("apple", data$TextColumn), "Apple Found", "No Apple")

print(data)

#dplyrway----
data1 <- data %>% mutate(Tag = ifelse(grepl("apple", TextColumn), "Apple Found", "No Apple"))
data1

#set of Strings----
data <- data.frame(
  ID = 1:5,
  TextColumn = c("apple pie", "banana bread", "cherry tart", "grape juice", "lemon cake")
)

data

# Define the set of strings and their corresponding tags
string_tags <- list(
  "apple pie" = "Dessert with Apple",
  "banana bread" = "Bread with Banana",
  "cherry tart" = "Tart with Cherry"
)
string_tags

# Add tags to the data
data <- data %>%   mutate (   Tag = ifelse(TextColumn %in% names(string_tags), string_tags[TextColumn], "No Match")   )

print(data)


#set of Strings----

# Sample data frame
data <- data.frame(
  ID = 1:6,
  TextColumn = c("apple pie", "banana bread", "cherry tart", 
                 "apple juice", "banana smoothie", "grape jelly")
)
data
# Define multiple patterns and their tags
patterns <- list(
  "apple" = "Apple Products",
  "banana" = "Banana Products",
  "cherry" = "Cherry Products",
  "pie|tart|bread" = "Baked Goods"
)

# Assign multiple tags
data <- data %>%
  mutate(
    Tag = sapply(TextColumn, function(text) {
      matched_tags <- unlist(lapply(names(patterns), function(pattern) {
        if (grepl(pattern, text)) patterns[[pattern]] else NULL
      }))
      if (length(matched_tags) > 0) paste(matched_tags, collapse = ", ") else "No Match"
    })
  )
data


library(dplyr)

# Sample data frame
data <- data.frame(
  ID = 1:6,
  TextColumn = c("apple pie Banana", "banana bread", "cherry tart", 
                 "apple juice", "banana smoothie", "grape jelly")
)
data
# Create a list of tags and associated strings
tag_list <- list(
  "Apple Products" = c("apple", "apple pie", "apple juice"),
  "Banana Products" = c("banana", "banana bread", "banana smoothie"),
  "Cherry Products" = c("cherry", "cherry tart"),
  "Grape Products" = c("grape", "grape jelly")
)
tag_list

# Function to assign tags based on tag_list
# Assign multiple tags if multiple matches exist
data <- data %>%
  mutate(
    Tag = sapply(TextColumn, function(text) {
      # Find all tags that match the current row's text
      matched_tags <- names(tag_list)[sapply(tag_list, function(strings) 
        any(sapply(strings, function(string) grepl(string, text)))
      )]
      # Combine all matched tags into a single string
      if (length(matched_tags) > 0) paste(matched_tags, collapse = ", ") else "No Match"
    })
  )

print(data)
