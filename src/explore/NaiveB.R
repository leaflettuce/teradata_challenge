#Packages
install.packages("tm")
install.packages("SnowballC")
install.packages("wordcloud")
install.packages("stringi")

contact<- read.csv("contact_Hire_CAC2.csv")
str(Contact)
#Subset dataset
df<- Contact[c("Hired_YN", "Summary_of_Qualifications__c")]
df <- df[-which(df$Summary_of_Qualifications__c == ""), ]
df<- 
View(df)

#Convert Hired_YN to factor and apply labels
df$Hired_YN <- factor(df$Hired_YN, levels = c(0,1), labels= c("Not Hired", "Hired"))


write.csv(df,file="nb2.csv")
str(df)
table(df$Hired_YN)

#Data Cleansing 
library(tm)

#Create corpus
df_corpus <- VCorpus(VectorSource(df$Summary_of_Qualifications__c))
print(df_corpus)

#All text in lower case
df_corpus_clean <-tm_map(df_corpus, content_transformer(tolower))

#Check cleanup
as.character(df_corpus[[1]])
as.character(df_corpus_clean[[1]])

#remove numbers
df_corpus_clean <- tm_map(df_corpus_clean, removeNumbers)
#remove stopwords
df_corpus_clean <- tm_map(df_corpus_clean, removeWords, stopwords("en"))
#remove management
df_corpus_clean <- tm_map(df_corpus_clean, removeWords, c("military", "management"))
#remove punctuation and special characters 
df_corpus_clean <- tm_map(df_corpus_clean,removePunctuation)

#Transform stemwords
library(SnowballC)
#df_corpus_clean <- tm_map(df_corpus_clean, stemDocument)

#Remove whitespaces
df_corpus_clean <- tm_map(df_corpus_clean, stripWhitespace)
str(df_corpus_clean)
#Data preparation 
df_dtm <- DocumentTermMatrix(df_corpus_clean)
df_dtm

#Create wordcloud
library(wordcloud)
wordcloud(df_corpus_clean, min.freq = 10, random.order = FALSE)

#FIX ME CLEAN WORDS EXAMINE STEMMING 
#Subset wordcloud
hired <- subset(df, Hired_YN == "Hired")
wordcloud(df$Summary_of_Qualifications__c, max.words = 5, scale = c(3, 0.1))

not_hired <- subset(df, Hired_YN == "Not Hired")
wordcloud(not_hired$Summary_of_Qualifications__c, max.words = 20, scale = c(3, 0.1), colors=brewer.pal(8, "Dark2"))


#Create train/test dataset
set.seed(123)
train_sample <- sample(55745,44596)
df_dtm_train <- df_dtm[train_sample, ]
df_dtm_test <- df_dtm[-train_sample, ]


#Create labels for train/test
df_train_labels <- df[train_sample, ]$Hired_YN
df_test_labels <- df[-train_sample, ]$Hired_YN

#Examine subsets train/test
prop.table(table(df_train_labels))
prop.table(table(df_test_labels))


#indicators features for frequent words

df_freq_words<- findFreqTerms(df_dtm_train, 5)

df_dtm_freq_train<- df_dtm_train[ ,df_freq_words]
df_dtm_freq_test<- df_dtm_test[ ,df_freq_words]

str(df_dtm)
#Function to convert counts in y/n
convert_counts <- function(x) {
  x <- ifelse(x > 0, "Yes", "No")
}

df_train <- apply(df_dtm_freq_train, MARGIN=2, convert_counts)
df_test <- apply(df_dtm_freq_test, MARGIN=2, convert_counts)

#Train model
library(e1071)

m<- naiveBayes(df_train, df_train_labels)
prediction <- predict(m, df_test)
library(gmodels)

CrossTable(prediction, df_test_labels, prop.chisq = FALSE, prop.t = FALSE, dnn= c("Predicted", "Actual"))

