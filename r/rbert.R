# BERT in R
#https://blogs.rstudio.com/ai/posts/2019-09-30-bert-r/
#https://github.com/jonathanbratt/RBERT  
#library(reticulate)

# install.packages("devtools")
devtools::install_github(  "jonathanbratt/RBERT", build_vignettes = TRUE)
tensorflow::install_tensorflow(version = "1.13.1")

