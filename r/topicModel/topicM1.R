#Topic Modeling
#Topic modeling is a type of statistical modeling for discovering the abstract “topics” that occur in a collection of documents. Latent Dirichlet Allocation (LDA) is an example of topic model and is used to classify text in a document to a particular topic. It builds a topic per document model and words per topic model, modeled as Dirichlet distributions.


#https://www.kaggle.com/code/rtatman/nlp-in-r-topic-modelling

pacman::p_load(tidyverse, tidytext, topicmodels, textdata, SnowballC, ggplot2, RColorBrewer, tm, SnowballC, wordcloud, wordcloud2, googlesheets4)


gsid = "1_G3btXkIAilH-tdvWcFUiLlUZJpm0Xw1enlts1qw4Y0"
sheet_names(gsid)

d1 = read_sheet(gsid, sheet = "deceptiveOpinion")
dim(d1)

# function to get & plot the most informative terms by a specificed number
# of topics, using LDA
top_terms_by_topic_LDA <- function(input_text, # should be a columm from a dataframe
                                   plot = T, # return a plot? TRUE by defult
                                   number_of_topics = 4) # number of topics (4 by default)
{    
  # create a corpus (type of object expected by tm) and document term matrix
  Corpus <- Corpus(VectorSource(input_text)) # make a corpus object
  DTM <- DocumentTermMatrix(Corpus) # get the count of words/document
  
  # remove any empty rows in our document term matrix (if there are any 
  # we'll get an error when we try to run our LDA)
  unique_indexes <- unique(DTM$i) # get the index of each unique value
  DTM <- DTM[unique_indexes,] # get a subset of only those indexes
  
  # preform LDA & get the words/topic in a tidy text format
  lda <- LDA(DTM, k = number_of_topics, control = list(seed = 1234))
  topics <- tidy(lda, matrix = "beta")
  
  # get the top ten terms for each topic
  top_terms <- topics  %>% # take the topics data frame and..
    group_by(topic) %>% # treat each topic as a different group
    top_n(10, beta) %>% # get the top 10 most informative words
    ungroup() %>% # ungroup
    arrange(topic, -beta) # arrange words in descending informativeness
  
  # if the user asks for a plot (TRUE by default)
  if(plot == T){
    # plot the top ten terms for each topic in order
    top_terms %>% # take the top terms
      mutate(term = reorder(term, beta)) %>% # sort terms by beta value 
      ggplot(aes(term, beta, fill = factor(topic))) + # plot beta by theme
      geom_col(show.legend = FALSE) + # as a bar plot
      facet_wrap(~ topic, scales = "free") + # which each topic in a seperate plot
      labs(x = NULL, y = "Beta") + # no x label, change y label 
      coord_flip() # turn bars sideways
  }else{ 
    # if the user does not request a plot
    # return a list of sorted terms instead
    return(top_terms)
  }
}

# plot top ten terms in the hotel reviews by topic
top_terms_by_topic_LDA(d1$text, number_of_topics = 2)


#stepByStep------
head(d1)
Corpus = Corpus(VectorSource(d1$text)) # make a corpus object
Corpus

DTM <- DocumentTermMatrix(Corpus) # get the count of words/document
DTM
# remove any empty rows in our document term matrix (if there are any 
# we'll get an error when we try to run our LDA)
unique(DTM$i)
DTM$i
unique_indexes <- unique(DTM$i) # get the index of each unique value
DTM <- DTM[unique_indexes,] # get a subset of only those indexes
number_of_topics = 4
# preform LDA & get the words/topic in a tidy text format
lda <- LDA(DTM, k = number_of_topics, control = list(seed = 1234))
lda

summary(lda)
topics <- tidy(lda, matrix = "beta")
topics

# get the top ten terms for each topic
top_terms <- topics  %>% # take the topics data frame and..
  group_by(topic) %>% # treat each topic as a different group
  top_n(10, beta) %>% # get the top 10 most informative words
  ungroup() %>% # ungroup
  arrange(topic, -beta) # arrange words in descending informativeness
top_terms

top_terms %>% # take the top terms
  mutate(term = reorder(term, beta)) %>% # sort terms by beta value 
  ggplot(aes(term, beta, fill = factor(topic))) + # plot beta by theme
  geom_col(show.legend = FALSE) + # as a bar plot
  facet_wrap(~ topic, scales = "free") + # which each topic in a seperate plot
  labs(x = NULL, y = "Beta") + # no x label, change y label 
  coord_flip() # turn bars sideways


#But how do we know how many topics we should have? You can't be sure ahead of time unless you're very familiar with the dataset and know how many topics you expect to see. Probably the most common way to figure out how many topics there are automatically is to train a lot of different models with different numbers of topics and then see which has the least uncertainty (generally measured by perplexity). 
#https://info5940.infosci.cornell.edu/#perplexity


#moreModels------
# create a document term matrix to clean
reviewsCorpus <- Corpus(VectorSource(d1$text)) 
reviewsDTM <- DocumentTermMatrix(reviewsCorpus)
# convert the document term matrix to a tidytext corpus
reviewsDTM_tidy <- tidy(reviewsDTM)
reviewsDTM_tidy

# I'm going to add my own custom stop words that I don't think will be
# very informative in hotel reviews
custom_stop_words <- tibble(word = c("hotel", "room"))

# remove stopwords
reviewsDTM_tidy_cleaned <- reviewsDTM_tidy %>% # take our tidy dtm and...
  anti_join(stop_words, by = c("term" = "word")) %>% # remove English stopwords and...
  anti_join(custom_stop_words, by = c("term" = "word")) # remove my custom stopwords

# reconstruct cleaned documents (so that each word shows up the correct number of times)
cleaned_documents <- reviewsDTM_tidy_cleaned %>%
  group_by(document) %>% 
  mutate(terms = toString(rep(term, count))) %>%
  select(document, terms) %>%
  unique()

# check out what the cleaned documents look like (should just be a bunch of content words) # in alphabetic order
head(cleaned_documents)

# now let's look at the new most informative terms
top_terms_by_topic_LDA(cleaned_documents$terms, number_of_topics = 2)

#these are much more helpful! We can now tell the difference between these topics.

# stem the words (e.g. convert each word to its stem, where applicable)
reviewsDTM_tidy_cleaned <- reviewsDTM_tidy_cleaned %>% mutate(stem = wordStem(term))

# reconstruct our documents
cleaned_documents <- reviewsDTM_tidy_cleaned %>%
  group_by(document) %>% 
  mutate(terms = toString(rep(stem, count))) %>%
  select(document, terms) %>%
  unique()

# now let's look at the new most informative terms
top_terms_by_topic_LDA(cleaned_documents$terms, number_of_topics = 2)
#What's up with the weird looking words look weird, like "locat" and "stai"? These

#Fortunately, we actually do have the labels for whether each review is truthful or deceptive, which means that we can use a supervised method of topic modeling instead. In general, unsupervised methods (like LDA) are helpful for data exploration but supervised methods (like TF-IDF, which we're going to learn next) are usually a better choice if you have access to labeled data. We've started with ab unsupervised method here in order to give you the chance to directly compare LDA and TF-IDF on the same dataset.

#Supervised topic modeling with TF-IDF
#general idea behind how TF-IDF works is this:
#Words that are very common in a specific document are probably important to the topic of that document
#Words that are very common in all documents probably aren't important to the topics of any of them

#TF-IDF stands for "term frequency-inverse document frequency". It's a way of weighting words based on how often they appear in a document and how often they appear in all documents. Words that are very common in a specific document are probably important to the topic of that document. Words that are very common in all documents probably aren't important to the topics of any of them.

# function that takes in a dataframe and the name of the columns
# with the document texts and the topic labels. If plot is set to
# false it will return the tf-idf output rather than a plot.
top_terms_by_topic_tfidf <- function(text_df, text_column, group_column, plot = T){
  # name for the column we're going to unnest_tokens_ to
  # (you only need to worry about enquo stuff if you're
  # writing a function using using tidyverse packages)
  group_column <- enquo(group_column)
  text_column <- enquo(text_column)
  
  # get the count of each word in each review
  words <- text_df %>%
    unnest_tokens(word, !!text_column) %>%
    count(!!group_column, word) %>% 
    ungroup()
  
  # get the number of words per text
  total_words <- words %>% 
    group_by(!!group_column) %>% 
    summarize(total = sum(n))
  
  # combine the two dataframes we just made
  words <- left_join(words, total_words)
  
  # get the tf_idf & order the words by degree of relevence
  tf_idf <- words %>%
    bind_tf_idf(word, !!group_column, n) %>%
    select(-total) %>%
    arrange(desc(tf_idf)) %>%
    mutate(word = factor(word, levels = rev(unique(word))))
  
  if(plot == T){
    # convert "group" into a quote of a name
    # (this is due to funkiness with calling ggplot2
    # in functions)
    group_name <- quo_name(group_column)
    
    # plot the 10 most informative terms per topic
    tf_idf %>% 
      group_by(!!group_column) %>% 
      top_n(10) %>% 
      ungroup %>%
      ggplot(aes(word, tf_idf, fill = as.factor(group_name))) +
      geom_col(show.legend = FALSE) +
      labs(x = NULL, y = "tf-idf") +
      facet_wrap(reformulate(group_name), scales = "free") +
      coord_flip()
  }else{
    # return the entire tf_idf dataframe
    return(tf_idf)
  }
}

# let's see what our most informative deceptive words are
top_terms_by_topic_tfidf(text_df = d1, # dataframe
                         text_column = text, # column with text
                         group_column = deceptive, # column with topic label
                         plot = T) # return a plot

# look for the most informative words for postive and negative reveiws
top_terms_by_topic_tfidf(text_df = d1, 
                         text_column = text, 
                         group = polarity, 
                         plot = T)

# get just the tf-idf output for the hotel topics
reviews_tfidf_byHotel <- top_terms_by_topic_tfidf(text_df = d1, 
                                                  text_column = text, 
                                                  group = hotel, 
                                                  plot = F)
reviews_tfidf_byHotel

# do our own plotting
reviews_tfidf_byHotel  %>% 
  group_by(hotel) %>% 
  top_n(5) %>% 
  ungroup %>%
  ggplot(aes(word, tf_idf, fill = hotel)) +
  geom_col(show.legend = FALSE) +
  labs(x = NULL, y = "tf-idf") +
  facet_wrap(~hotel, ncol = 4, scales = "free", ) +
  coord_flip()


#https://www.kaggle.com/code/rtatman/nlp-in-r-topic-modelling/notebook

