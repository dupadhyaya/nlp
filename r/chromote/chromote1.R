#chromote
#https://youtu.be/30AOpjLeOyI

pacman::p_load(rvest, lubridate, dplyr, chromote)

chrome_session <- ChromoteSession$new()
chromote::find_chrome()
View(chrome_session)

chrome_session$Page$navigate("https://www.r-project.org")

chrome_session$Page$navigate("https://www.google.com")

#-------
b <- ChromoteSession$new()
b$Page$navigate("https://example.com")
b$wait_for_load()

title <- b$Runtime$evaluate("document.title")$result$value
title

h1_text <- b$Runtime$evaluate("
  document.querySelector('h1')?.innerText
")$result$value
h1_text

#paras
paragraphs <- b$Runtime$evaluate("
  Array.from(document.querySelectorAll('p')).map(p => p.innerText)
")$result$value
#If this returns NULL, it means the result is too complex for direct extraction. Use Runtime$evaluate with serialize = TRUE:
paragraphs

para_eval <- b$Runtime$evaluate("
  Array.from(document.querySelectorAll('p')).map(p => p.innerText)
", returnByValue = TRUE)

para_eval$result$value


#news
b <- ChromoteSession$new()

# Navigate to Reuters homepage
b$Page$navigate("https://www.reuters.com")
b$wait_for_load()

#h2.story-title, h3.story-title, h2, h3
headlines <- b$Runtime$evaluate("
  Array.from(document.querySelectorAll('p')).map(el => el.innerText)
", returnByValue = TRUE)$result$value

headlines <- unlist(headlines)
headlines[1:10]  # print first 10

