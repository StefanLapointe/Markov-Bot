library(tidyverse)
library(jsonlite)

messages <- 
    "channels" %>% 
    lapply(\(x) list.files(x, full.names = TRUE)) %>% 
    unlist %>% 
    lapply(\(x) read_json(x)$messages) %>% 
    unlist(recursive = FALSE) %>% 
    .[which(map_lgl(., ~ .$author$id == readline(Please enter author ID:)))] %>% 
    map_chr(~ .$content)

tokens <- function(message) {
    strsplit(message, "[[:space:]]+")[[1]] %>% 
        if (identical(.[1], "")) .[-1] else .
}

repeated <- function(X) {
    unique(X[duplicated(X)])
}

predict_word <- function(word, tokenized_messages) {
    predictions <- 
        tokenized_messages %>% 
        map(~ c("", ., "\n")) %>% 
        .[map_lgl(., ~ word %in% .)] %>% 
        unlist %>% 
        .[which(. == word) + 1] %>% 
        repeated
    if (is_empty(predictions)) return("\n")
    else return(predictions)
}

word_predictions <- function(tokenized_messages) {
    words <- c("", repeated(unlist(tokenized_messages)))
    i <- 0
    l <- length(words)
    words %>% 
        tibble(words = ., 
               predictions = map(words, \(x) {
                   i <<- i + 1; 
                   message(i, "/", l); 
                   return(predict_word(x, tokenized_messages))})) %>% 
        return
}

generate <- function(word_prediction_table) {
    word <- ""
    output <- ""
    for (i in 1:100) {
        predictions <- word_prediction_table$predictions[[which(word_prediction_table$words == word)]]
        word <- sample(predictions, 1)
        if (word == "\n") break
        output <- paste(output, word)
    }
    return(output)
}

word_prediction_table <- word_predictions(map(messages, tokens))

write_json(word_prediction_table$words, "bot/words.json")

write_json(word_prediction_table$predictions, "bot/predictions.json")

write_json(readline("Please enter bot token: "), "bot/token.json")