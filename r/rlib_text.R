# text library in R

#https://cran.r-project.org/web/packages/text/
#https://cran.r-project.org/web/packages/text/text.pdf
#https://www.r-text.org/articles/text.html

#R-package for analyzing natural language with transformers from HuggingFace using Natural Language Processing and Machine Learning.

devtools::install_github("oscarkjell/text")

library(text)

textrpp_install()
#textrpp_condaenv
textrpp_initialize()

#Example text
texts <- c("I feel great!")
embeddings <- textEmbed(texts)
embeddings

# Generate text from the prompt "I am happy to"
generated_text <- textGeneration("I am happy to",   model = "gpt2")
generated_text

tokens = textTokenize('hello how are you')
tokens

plot_projection <- textProjectionPlot(
  word_data = DP_projections_HILS_SWLS_100,
  y_axes = TRUE,
  title_top = " Supervised Bicentroid Projection of Harmony in life words",
  x_axes_label = "Low vs. High HILS score",
  y_axes_label = "Low vs. High SWLS score",
  position_jitter_hight = 0.5,
  position_jitter_width = 0.8
)
plot_projection$final_plot

#-----------
Language_based_assessment_data_8
#Transform the text data to BERT word embeddings
word_embeddings <- textEmbed(
  texts = Language_based_assessment_data_8[3],
  model = "bert-base-uncased",
  layers = -2,
  aggregation_from_tokens_to_texts = "mean",
  aggregation_from_tokens_to_word_types = "mean",
  keep_token_embeddings = FALSE)
word_embeddings
# Examine the relationship between harmonytext word embeddings and the harmony in life rating scale
model_htext_hils <- textTrain(word_embeddings$texts$harmonywords,       Language_based_assessment_data_8$hilstotal)

# Examine the correlation between predicted and observed Harmony in life scale scores
model_htext_hils$results
