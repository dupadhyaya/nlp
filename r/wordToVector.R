# Word to Vector 

#https://cran.r-project.org/web/packages/word2vec/index.html
#https://cran.r-project.org/web/packages/word2vec/word2vec.pdf

library(word2vec)


path <- system.file(package = "word2vec", "models", "example.bin")
model <- read.word2vec(path)
model

x <- data.frame(doc_id = c("doc1", "doc2", "testmissingdata"),  text = c("there is no toilet. on the bus", "no tokens from dictionary", NA),  stringsAsFactors = FALSE)
x

emb <- doc2vec(model, x, type = "embedding")
emb
newdoc <- doc2vec(model, "i like busses with a toilet")
newdoc

word2vec_similarity(emb, newdoc)

## similar way of extracting embeddings
x <- setNames(object = c("there is no toilet. on the bus", "no tokens from dictionary", NA),      nm = c("a", "b", "c"))
x
emb <- doc2vec(model, x, type = "embedding")
emb

## similar way of extracting embeddings
x <- setNames(object = c("there is no toilet. on the bus", "no tokens from dictionary", NA),  nm = c("a", "b", "c"))
x <- strsplit(x, "[ .]")
emb <- doc2vec(model, x, type = "embedding")
emb
## show behaviour in case of NA or character data of no length
x <- list(a = character(), b = c("bus", "toilet"), c = NA)
emb <- doc2vec(model, x, type = "embedding")
emb

emb


#----
#https://cran.r-project.org/web/packages/word2vec/readme/README.html
library(udpipe)
data(brussels_reviews, package = "udpipe")
x <- subset(brussels_reviews, language == "nl")
x
x <- tolower(x$feedback)
x
#Build a model

#library(word2vec)
set.seed(123456789)
model <- word2vec(x = x, type = "cbow", dim = 15, iter = 20)
embedding <- as.matrix(model)
embedding <- predict(model, c("bus", "toilet"), type = "embedding")
lookslike <- predict(model, c("bus", "toilet"), type = "nearest", top_n = 5)
lookslike

#Save the model and read it back in and do something with it
write.word2vec(model, "mymodel.bin")
model     <- read.word2vec("mymodel.bin")
terms     <- summary(model, "vocabulary")
embedding <- as.matrix(model)
embedding
plot(embedding)
