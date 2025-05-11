#tokenisation
#https://www.comet.com/site/blog/natural-language-processing-with-r/

#Use of this library
library(tm)
tdata <- "I travelled yesterday to the great Benin city. The journey was a bit tiring has my flight got delayed for about 4 hours,and I had to stay in traffic for an hour plus to get to my hotel.The hotel I am stay at is quite nice, the ambiance of the place is nice."

#Tokenization
tokens1 <- wordpunct_tokenizer(tdata)
tokens1

#DocumentTermMatrix
dtm <- DocumentTermMatrix(Corpus(VectorSource(tokens)))
inspect(dtm)

#The tm package's DocumentTermMatrix() function generates a Document-Term Matrix (DTM) that represents the frequency of terms in the documents.

#This gives you a matrix with the rows as documents and columns as terms and the frequency of that term in that document.
#bash -> #/usr/libexec/java_home
Sys.setenv(JAVA_HOME='/Library/Java/JavaVirtualMachines/jdk-23.jdk/Contents/Home')
version
library(rJava)
library(openNLP)

download.file("http://opennlp.sourceforge.net/models-1.5/en-token.bin", destfile = "en-token.bin")

# Define the text string to be tokenized
data <- "I travelled yesterday to the great Benin city. The journey was a bit tiring has my flight got delayed for about 4 hours, and I had to stay in traffic for an hour plus to get to my hotel. The hotel I am stay at is quite nice, the ambiance of the place is nice."
data

s = as.String(data)
s
sent_token_annotator <- Maxent_Sent_Token_Annotator()
word_token_annotator <- Maxent_Word_Token_Annotator()
a2 <- annotate(s, list(sent_token_annotator, word_token_annotator))
a2
# Tokenize the text string using the opennlp command-line tool
tokens2 <- system(paste("echo", shQuote(data), "| opennlp TokenizerME en-token.bin"), intern = TRUE)
tokens2
#notworking


#SentimentR000000
library(sentimentr)

# Define the text string to be analyzed
text_data <- "The ambiance of the hotel is nice. I love staying at the hotel"
# Perform sentiment analysis on the text string
sentiment_result <- sentiment(text_data)
sentiment_result
#The element’s emotion is represented by a numeric value between -1 and 1. Positive values represent positive emotions, negative values represent negative emotions, and values close to zero represent neutral emotions.

#wordcloud------
library(wordcloud)

# Define the text string to be used for the word cloud
text_data <- "This is a very nice hotel, I love it so much! The hotel is so good, I highly recommend it to everyone."

# Create the word cloud
wordcloud(text_data)



#quanteda-----
library(quanteda)
# Define the text data to be used for the corpus
text_data <- c("This is a very nice hotel, I love it so much!",  "The hotel is so good, I highly recommend it to everyone.")

# Create the corpus
corpus <- corpus(text_data)
corpus
# Perform some basic text analysis
tokens <- tokens(corpus)
tokens
dfm <- dfm(tokens)
dfm

# Print the tokens
print(tokens)

# Print the Document-Feature Matrix
print(dfm)

