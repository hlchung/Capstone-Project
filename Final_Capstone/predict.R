# Predicting algorithm

predictText <- function (predictString, Ngram_Models) 
{
  
  total_Ngrams = length(Ngram_Models)
  phrase <- iconv(predictString, "latin1", "ASCII", sub = "")
  phrase <- phrase %>% replace_abbreviation %>% replace_contraction %>% 
    removeNumbers %>% removePunctuation %>% tolower %>% stripWhitespace
  words <- unlist(strsplit(phrase, split = " "))
  nwords <- length(words)
  
  if (nwords < total_Ngrams) {
    idx <- nwords + 1
    store_models <- Ngram_Models[(total_Ngrams - nwords):total_Ngrams]
  }
  else{
    idx <- total_Ngrams
    store_models <- Ngram_Models
  }
  
  if (idx == 4) 
  {n = 2}else if (idx == 3)
  {n = 1}else {n = 0}
  
  pattern_vector <- vector(length = 0)
  for (i in 0:n){
    pattern <- paste0("^", paste(words[(nwords - idx + 2 + i):nwords], collapse = " "))
    temp_vec <- c(pattern)
    pattern_vector <- c(pattern_vector, temp_vec)
  }
  
  pattern <- pattern_vector[length(pattern_vector)]
  lookup <- grep(pattern, store_models[[length(store_models)]]$word)
  
  if (length(lookup) == 0)
  {
    df.ngram <- store_models[[length(store_models)]][1:50,]
    df.ngram <- dplyr::rename(df.ngram, lastword = word, output = freq)
    
  } else
  {
    x <- length(store_models)-1
    
    for (i in 1:x){
      pattern <- pattern_vector[i]
      lookup <- grep(pattern, store_models[[i]]$word)
      df.1 <- store_models[[i]][lookup[1:50],]
      p_w <- strsplit(as.character(df.1$word), " ")
      p_w <- sapply(p_w, "[", length(p_w[[1]]))
      
      pattern2 <- paste(pattern, "$", sep = "")
      GramCount <- store_models[[i+1]][grep(pattern2, store_models[[i+1]]$word),2]
      if (length(GramCount$freq) < 1){
        GramCount <- sum(store_models[[i+1]]$freq)
      }
      GramCount <- GramCount[[1]]
      
      df.1 <- mutate(df.1, lastword = p_w, nmodel = i)
      df.1 <- dplyr::filter(df.1,!is.na(df.1$freq))
      df.1 <- df.1 %>% 
        mutate(wt = ifelse(nmodel == 2, .4,
                           ifelse(nmodel == 3, .16,
                                  1)))
      
      df.1 <- df.1 %>% 
        group_by(lastword, nmodel) %>% 
        mutate(output = (wt * freq) / GramCount) %>% 
        summarise(output = sum(output), freq = sum(freq)) %>% 
        arrange(desc(output))
      
      
      if (exists("df.ngram")){
        df.ngram <- bind_rows(df.ngram,df.1)     
      }
      if (!exists("df.ngram")){
        df.ngram <- df.1
      }
    }
    
    df.ngram <- df.ngram %>% 
      group_by(lastword) %>% 
      summarise(output = sum(output), freq = sum(freq)) %>% 
      arrange(desc(output))
  }
  
  return(list(pword=df.ngram$lastword[1:nrow(df.ngram)],
              prob=df.ngram$output[1:nrow(df.ngram)]))
  
}