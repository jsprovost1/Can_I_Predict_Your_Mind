# Can I Predict Your Next Word? Maybe I can!

##  Introduction 
A question that has puzzled mankind is whether we will ever be able to read someone else's mind. Even though this question has a lot of ethical considerations that needs to be addressed, it is still an interesting question on a scientific point of view. Indeed, this ability could be very benificial for patients in coma, for whom it has been shown that they are still reactive to their environment. But on a more simplistic way, can we have a conversation with a friend and predict what is the next thing that will be said? 

Our personality contributes to how we are going the exchange with someone. Furthermore, we may have a specific style of communication that is proper to us favoring some words as opposed to others. With this mind, we can sometimes anticipate what a loved one is thinking, and therefore, is about to say. Our predictions rely on our past exposure of someone's speech content, and reflect the most likely scenario to occur. 


## Goal Of This Project
In this project, we have built an **[application](https://jsprovost.shinyapps.io/WordPrediction_app/)** with the main goal to predict the next word in a sentence. In order to perform this task, we have built a linguisitic model based on three sources of sentences: newspapers, twitter, and blogs. This project had 3 folds. Firstly, we explored these datasets and performed exploratory data analysis in order to have a better grasp on our data. Secondly, we created and tested our language model in order to assess its reliability, and therefore its predicitve power. Finally, a web application was built in which the user is asked to enter an incomplete sentence of three words, and the application predicts the word most likely to follow in this particular sentence. Then you'll know for sure: can we predict what you are thinking of?  

This document contains the R code for building the algorithm in order to predict the next word. As our corpus of interest, we used text from: 
  - **Twitter**
  - **Newspapers**
  - **Blogs**

In this first stage, we have looked at the three datasets individually in order to better understand the word distribution. Because our datasets is composed of thousands of lines and that we are limited in our computing power, we only took a subset of the entire dataset. In our case, we aimed for 10% of the entire dataset. This value was chosen after trial and error, and that is the maximum amount of data that I can process with our computing power. Our different subsets were created using a random selection of lines with our datasets. 

Our code has two majors goals: calculate the probability and predict the last word of an N-gram. In order to perform these steps, we built a language model using discounted probabilities based on a Katz Back-Off Model. All the explanations can be found in the R-Markdown. 

Please try out my app by clicking **[here](https://jsprovost.shinyapps.io/WordPrediction_app/)**

