setwd("/Users/jean-sebastienprovost/Desktop/app/")
unigrams = read.csv("unigrams.csv", as.is = TRUE)
bigrams = read.csv("bigrams.csv", as.is = TRUE)
trigrams = read.csv("trigrams.csv", as.is = TRUE)
fourgrams = read.csv("fourgrams.csv", as.is = TRUE)

probability_words = function(input, alpha=0.5){   
  
  # Split the input into its components
  input_split = strsplit(input, " ")
  input_trig = paste(input_split[[1]][1], input_split[[1]][2], input_split[[1]][3])
  input_big = paste(input_split[[1]][2], input_split[[1]][3])
  input_uni = input_split[[1]][1]
  input_last_word = input_split[[1]][4]
  input_big_w1 = paste(input_split[[1]][2], input_split[[1]][3])
  input_big_w = paste(input_split[[1]][3], input_split[[1]][4])
  input_uni_w = input_split[[1]][3]
  input_trig_unobs = paste(input_split[[1]][2], input_split[[1]][3], input_split[[1]][4]) 
  input_big_unobs = paste(input_split[[1]][3], input_split[[1]][4])
  input_uni_unobs = input_split[[1]][4]
  
  # For OBSERVED fourgrams
  # Creating a sample of the possible choices for this trigram
  if (input %in% fourgrams$fourgrams){ 
    sample_data = fourgrams[fourgrams$trigrams == input_trig,]
    
    # Creating a new  column for the discounted counts
    sample_data$trig_disc = sample_data$Freq - alpha    
    
    # Summing up the frequency
    sumW_1W_2 = sum(sample_data$Freq)
    
    # Extracting the new discounted probability for observed words
    sample_data$disc_prob = sample_data$trig_disc/sumW_1W_2
    
    #print(sample_data$last_word[1])
    probability = sample_data[sample_data$fourgrams == input,]$disc_prob
    prediction = data.frame(input, probability)
    return(prediction)
  } 
  
  # For UNOBSERVED fourgrams
  # Don't have the fourgram, but have the preceding trigram AND have the actual trigram -> so we can get the discounted prob 
  # from the preceding trigram and get the prob of the the actual trigram
  else if (!(input %in% fourgrams$fourgrams) && (input_trig %in% fourgrams$trigrams) && (input_trig_unobs %in% trigrams$trigrams)) {
    # First, calculate the discounted probability
    sample_data = fourgrams[fourgrams$trigrams == input_trig,]
    # Creating a new  column for the discounted counts
    sample_data$trig_disc = sample_data$Freq - alpha    
    # Summing up the frequency
    sumW_1W_2 = sum(sample_data$Freq)
    # Extracting the new discounted probability for observed words
    sample_data$disc_prob = sample_data$trig_disc/sumW_1W_2
    # subtracting the sum of the overall discounted probability to get the residual -> gamma
    gamma = 1 - sum(sample_data$disc_prob)
    # Extracting my sample dataset
    sample_data_unobs = trigrams[trigrams$bigrams == input_big_w1,]
    # Creating a new  column for the discounted counts
    sample_data_unobs$trig_disc = sample_data_unobs$Freq - alpha    
    # Summing up the frequency
    sumW_1W_2 = sum(sample_data_unobs$Freq)
    # Extracting the new discounted probability for observed words
    sample_data_unobs$disc_prob = sample_data_unobs$trig_disc/sumW_1W_2
    probability = gamma * sample_data_unobs[sample_data_unobs$trigrams == input_trig_unobs,]$disc_prob
    prediction = data.frame(input, probability)
    return(prediction)   
  }
  
  # Don't have the fourgram nor the associated trigram, then a trigram analysis is being performed
  else if (!(input %in% fourgrams$fourgrams) && !(input_trig %in% fourgrams$trigrams) && (input_trig_unobs %in% trigrams$trigrams) && (input_big_w1 %in% trigrams$bigrams)){
    sample_data = trigrams[trigrams$bigrams == input_big_w1,]
    sample_data$trig_disc = sample_data$Freq - alpha 
    sumW_1W_2 = sum(sample_data$Freq)
    sample_data$disc_prob = sample_data$trig_disc/sumW_1W_2
    probability = sample_data[sample_data$trigrams == input_trig_unobs,]$disc_prob
    prediction = data.frame(input, probability)
    return(prediction)
  }
  
  # Don't have the fourgram, but have the associated trigram. However the actual trigram is missing as well, so therefore we need to look at the bigram level
  # Here, we can get the discounted probability from the fourgram, trigram and bigram.
  else if (!(input %in% fourgrams$fourgrams) &&  (input_trig %in% fourgrams$trigrams) && !(input_trig_unobs %in% trigrams$trigrams) && !(input_big_w %in% bigrams$bigrams) && (input_big_w1 %in% trigrams$bigrams) && (input_uni_w %in% bigrams$unigrams)){
    sample_data = trigrams[trigrams$bigrams == input_big_w1,]
    sample_data$trig_disc = sample_data$Freq - alpha 
    sumW_1W_2 = sum(sample_data$Freq)
    sample_data$disc_prob = sample_data$trig_disc / sumW_1W_2 
    gamma = 1 - sum(sample_data$disc_prob)
    
    # Extracting my sample dataset
    sample_data_unobs = bigrams[bigrams$unigrams == input_uni_w,]
    sample_data_unobs$trig_prob = sample_data_unobs$Freq - alpha
    sumAll = sum(sample_data_unobs$Freq)
    sample_data_unobs$disc_prob = sample_data_unobs$trig_prob / sumAll
    gamma2 = 1 - sum(sample_data_unobs$disc_prob)
    
    sample_data2 = unigrams
    sample_data2$trig_disc = sample_data2$Freq - alpha
    sumAll2 = sum(sample_data2$Freq)
    sample_data2$disc_prob = sample_data2$trig_disc / sumAll2
    gamma3 = 1 - sum(sample_data2$disc_prob)
    probability = gamma * gamma2 * gamma3
    prediction = data.frame(input, probability)
    return(prediction)   
  }
  
  # Don't haven the fourgram, and trigram. Therefore we extract the discounted probability at the bigram level, and multiply it with our unigram probability
  else if (!(input %in% fourgrams$fourgrams) && !(input_trig %in% fourgrams$trigrams) && !(input_trig_unobs %in% bigrams$bigrams) && !(input_big_w1 %in% trigrams$bigrams) && !(input_uni_w %in% bigrams$unigrams)){
    sample_data = bigrams[bigrams$unigrams == input_uni_w,]
    sample_data$trig_disc = sample_data$Freq - alpha 
    sumW_1W_2 = sum(sample_data$Freq)
    sample_data$disc_prob = sample_data$trig_disc / sumW_1W_2 
    gamma = 1 - sum(sample_data$disc_prob)
    
    # Extracting my sample dataset
    sample_data_unobs = unigrams[unigrams$unigrams == input_uni_unobs,]
    sumAll = sum(unigrams$Freq)
    prob_uni = sample_data_unobs$Freq/sumAll
    probability = gamma * prob_uni
    prediction = data.frame(input, probability)
    return(prediction)   
  }
  
  # Don't have the fourgram, trigram, associated trigram, and associated bigram, but have the actual bigram
  else if (!(input %in% fourgrams$fourgrams) && !(input_trig %in% fourgrams$trigrams) && !(input_trig_unobs %in% trigrams$trigrams) && !(input_big_w1 %in% trigrams$bigrams) && (input_big_w %in% bigrams$bigrams)){
    sample_data = bigrams[bigrams$unigrams == input_uni_w,]
    sample_data$trig_disc = sample_data$Freq - alpha
    sumAll = sum(sample_data$Freq)
    sample_data$disc_prob = sample_data$trig_disc / sumAll
    gamma = 1 - sum(sample_data$disc_prob)
    probability = sample_data[sample_data$bigrams == input_big_w,]$disc_prob
    prediction = data.frame(input, probability)
    return(prediction)   
  }
  
  # Don't have the fourgram, associated trigram, trigram, but have the associated bigram. Here we can get the discounted probability from the fourgram, and trigram level
  else if (!(input %in% fourgrams$fourgrams) && !(input_trig %in% fourgrams$trigrams) && !(input_trig_unobs %in% trigrams$trigrams) && (input_big_w1 %in% trigrams$bigrams)){
    sample_data = trigrams[trigrams$bigrams == input_big_w1,]
    sample_data$trig_disc = sample_data$Freq - alpha
    sumAll = sum(sample_data$Freq)
    sample_data$disc_prob = sample_data$trig_disc / sumAll
    gamma = 1 - sum(sample_data$disc_prob)
    
    sample_data2 = bigrams[bigrams$unigrams == input_uni_w,]
    sample_data2$trig_disc = sample_data2$Freq - alpha
    sumAll2 = sum(sample_data2$Freq)
    sample_data2$disc_prob = sample_data2$trig_disc / sumAll2
    gamma2 = 1 - sum(sample_data2$disc_prob)
    
    sample_data3 = unigrams
    sample_data3$trig_disc = sample_data3$Freq - alpha
    sumAll3 = sum(sample_data3$Freq)
    sample_data3$disc_prob = sample_data3$trig_disc / sumAll3
    prob_uni = sample_data3[sample_data3$unigrams == input_uni_unobs,]$disc_prob
    probability = prob_uni * gamma * gamma2 
    prediction = data.frame(input, probability)
    return(prediction)
  }
  
  # Don't have the fourgram, associated trigram, trigram, associated bigram, but thave the actual bigram. 
  else if (!(input %in% fourgrams$fourgrams) && !(input_trig %in% fourgrams$trigrams) && !(input_trig_unobs %in% trigrams$trigrams) && !(input_big_w1 %in% trigrams$bigrams) && !(input_big_w %in% bigrams$bigrams) && (input_uni_w %in% bigrams$unigrams)){
    sample_data = bigrams[bigrams$unigrams == input_uni_w,]
    sample_data$trig_disc = sample_data$Freq - alpha
    sumAll = sum(sample_data$Freq)
    sample_data$disc_prob = sample_data$trig_disc / sumAll
    gamma = 1 - sum(sample_data$disc_prob)
    
    sample_data2 = unigrams
    sample_data2$trig_disc = sample_data2$Freq - alpha
    sumAll2 = sum(sample_data2$Freq)
    sample_data2$disc_prob = sample_data2$trig_disc / sumAll2
    gamma2 = 1 - sum(sample_data2$disc_prob)
    prob_uni = sample_data2[sample_data2$unigrams == input_uni_unobs,]$disc_prob
    probability = gamma * gamma2 * prob_uni
    prediction = data.frame(input, probability)
    return(prediction)
  }
  
  # Don't have the fourgram, but have the associated trigram. However, we don't have the actual trigram, but we have the actual bigram 
  else if (!(input %in% fourgrams$fourgrams) && (input_trig %in% fourgrams$trigrams) && !(input_trig_unobs %in% trigrams$trigrams) && (input_big_w1 %in% trigrams$bigrams) && (input_big_w %in% bigrams$bigrams) && (input_uni_w %in% bigrams$unigrams)){
    sample_data = fourgrams[fourgrams$trigrams == input_trig,]
    sample_data$trig_disc = sample_data$Freq - alpha
    sumAll = sum(sample_data$Freq)
    sample_data$disc_prob = sample_data$trig_disc / sumAll
    gamma = 1 - sum(sample_data$disc_prob)
    
    sample_data2 = trigrams[trigrams$bigrams == input_big,]
    sample_data2$trig_disc = sample_data2$Freq - alpha
    sumAll2 = sum(sample_data2$Freq)
    sample_data2$disc_prob = sample_data2$trig_disc / sumAll2
    gamma2 = 1 - sum(sample_data2$disc_prob)
    
    sample_data3 = bigrams[bigrams$unigrams == input_uni_w,]
    sample_data3$trig_disc = sample_data3$Freq - alpha
    sumAll3 = sum(sample_data3$Freq)
    sample_data3$disc_prob = sample_data3$trig_disc / sumAll3
    prob_uni = sample_data3[sample_data3$bigrams == input_big_unobs,]$disc_prob
    probability = prob_uni * gamma * gamma2
    prediction = data.frame(input, probability)
    return(prediction)
    
  }
}

#### END OF FUNCTION ####