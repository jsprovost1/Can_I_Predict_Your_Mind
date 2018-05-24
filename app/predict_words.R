#setwd("/Users/jean-sebastienprovost/Desktop/WordPrediction_app/")
unigrams = read.csv("unigrams.csv", as.is = TRUE)
bigrams = read.csv("bigrams.csv", as.is = TRUE)
trigrams = read.csv("trigrams.csv", as.is = TRUE)
fourgrams = read.csv("fourgrams.csv", as.is = TRUE)

predict_words = function(input, alpha, num_alternatives){   
  
  input_split = strsplit(input, " ")
  input_trig = paste(input_split[[1]][1], input_split[[1]][2], input_split[[1]][3])
  input_big = paste(input_split[[1]][2], input_split[[1]][3])
  input_uni = input_split[[1]][3]
  input_last_word = input_split[[1]][3]
  
  # Creating a sample of the possible choices for this trigram
  if (input %in% fourgrams$trigrams){ 
    sample_data = fourgrams[fourgrams$trigrams == input_trig,]
    
    # Creating a new  column for the discounted counts
    sample_data$trig_disc = sample_data$Freq - alpha    
    
    # Summing up the frequency
    sumW_1W_2 = sum(sample_data$Freq)
    
    # Extracting the new discounted probability for observed words
    sample_data$disc_prob = sample_data$trig_disc/sumW_1W_2
    
    #print(sample_data$last_word[1])
    if (nrow(sample_data) >= num_alternatives){
      pred_prob = sample_data$disc_prob[1:num_alternatives]
      pred_word = sample_data$last_word[1:num_alternatives]
      prediction = data.frame(pred_word, pred_prob)
      return(prediction)  
    } else {
      pred_prob = sample_data$disc_prob
      pred_word = sample_data$last_word
      prediction = data.frame(pred_word, pred_prob)
      return(prediction)
    }
  } 
  else if (!(input %in% fourgrams$trigrams) && (input_big %in% trigrams$bigrams)) {
    sample_data = trigrams[trigrams$bigrams == input_big,]
    
    # Creating a new  column for the discounted counts
    sample_data$big_disc = sample_data$Freq - alpha    
    
    # Summing up the frequency
    sumW_1W_2 = sum(sample_data$Freq)
    
    # Extracting the new discounted probability for observed words
    sample_data$disc_prob = sample_data$big_disc/sumW_1W_2
    
    #print(sample_data$last_word[1])
    if (nrow(sample_data) >= num_alternatives){
      pred_prob = sample_data$disc_prob[1:num_alternatives]
      pred_word = sample_data$last_word[1:num_alternatives]
      prediction = data.frame(pred_word, pred_prob)
      return(prediction)  
    } else {
      pred_prob = sample_data$disc_prob
      pred_word = sample_data$last_word
      prediction = data.frame(pred_word, pred_prob)
      return(prediction)
    }
  }
  else if (!(input %in% fourgrams$trigrams) && !(input_big %in% trigrams$bigrams) && (input_uni %in% bigrams$unigrams)){
    sample_data = bigrams[bigrams$unigrams == input_uni,]
    
    # Creating a new  column for the discounted counts
    sample_data$uni_disc = sample_data$Freq - alpha    
    
    # Summing up the frequency
    sumW_1W_2 = sum(sample_data$Freq)
    
    # Extracting the new discounted probability for observed words
    sample_data$disc_prob = sample_data$uni_disc/sumW_1W_2
    
    #print(sample_data$last_word[1])
    if (nrow(sample_data) >= num_alternatives){
      pred_prob = sample_data$disc_prob[1:num_alternatives]
      pred_word = sample_data$last_word[1:num_alternatives]
      prediction = data.frame(pred_word, pred_prob)
      return(prediction)  
    } else {
      pred_prob = sample_data$disc_prob
      pred_word = sample_data$last_word
      prediction = data.frame(pred_word, pred_prob)
      return(prediction)
    }
  }
}