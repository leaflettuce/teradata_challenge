#Crated by Christine Rizzo, April 2019
#Packages
install.packages("tm")
#install.packages("SnowballC")
install.packages("wordcloud")
install.packages("stringi")

contact<- read.csv("contact_Hire_CAC2.csv")
str(Contact)

#Subset dataset
df<- Contact[c("Hired_YN", "Summary_of_Qualifications__c")]
df <- df[-which(df$Summary_of_Qualifications__c == ""), ]
 
View(df)

#Convert Hired_YN to factor and apply labels
df$Hired_YN <- factor(df$Hired_YN, levels = c(0,1), labels= c("Not Hired", "Hired"))
str(df)


str(df_Hired)

write.csv(df,file="nb2.csv")
str(df)
table(df$Hired_YN)

#Data Cleansing 
library(tm)
#############################################################################################################
#HIRED ONLY VIEW 

#create corpus hired:
hired <- subset(df, Hired_YN == "Hired")
hired_corpus <- VCorpus(VectorSource(hired$Summary_of_Qualifications__c))

#All text in lower case
hired_corpus_clean <-tm_map(hired_corpus, content_transformer(tolower))
#remove numbers
#hired_corpus_clean <- tm_map(hired_corpus_clean, removeNumbers)
#remove stopwords
hired_corpus_clean <- tm_map(hired_corpus_clean, removeWords, stopwords("en"))

#remove punctuation and special characters 
hired_corpus_clean <- tm_map(hired_corpus_clean,removePunctuation)
#Remove whitespace
hired_corpus_clean <- tm_map(hired_corpus_clean, stripWhitespace)

#Check cleanup
as.character(hired_corpus_clean[[1]])
as.character(hired_corpus_clean[[1]])

#term Doc Matrix
dtm <- TermDocumentMatrix(hired_corpus_clean)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)

#Word cloud Hired
set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words=100, random.order=FALSE, scale = c(3, 0.1),rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))


#Word Frequency for words occuring at least 4 times
findFreqTerms(dtm, lowfreq = 4)
#Find correlations between words
findAssocs(dtm, terms = "freedom", corlimit = 0.3)

#Freq table 
head(d,10)

#Freq bar plot
barplot(d[1:10,]$freq, las = 2, names.arg = d[1:10,]$word,
        col ="lightblue", main ="Most frequent words",
        ylab = "Word frequencies")
#############################################################################################################

#NOT HIRED ONLY VIEW 

#create corpus Not hired:
Nhired <- subset(df, Hired_YN == "Not Hired")
Nhired_corpus <- VCorpus(VectorSource(Nhired$Summary_of_Qualifications__c))

#All text in lower case
Nhired_corpus_clean <-tm_map(Nhired_corpus, content_transformer(tolower))
#remove numbers
Nhired_corpus_clean <- tm_map(Nhired_corpus_clean, removeNumbers)
#remove stopwords
Nhired_corpus_clean <- tm_map(Nhired_corpus_clean, removeWords, stopwords())
#remove management
#Nhired_corpus_clean <- tm_map(Nhired_corpus_clean, removeWords, c("military", "management","and", "the", "while"))
#remove punctuation and special characters 
Nhired_corpus_clean <- tm_map(Nhired_corpus_clean,removePunctuation)
#Remove whitespace
Nhired_corpus_clean <- tm_map(Nhired_corpus_clean, stripWhitespace)
str(Nhired_corpus_clean)

#Check cleanup
as.character(Nhired_corpus_clean[[1]])
as.character(Nhired_corpus_clean[[1]])

#term Doc Matrix
dtm_nh <- TermDocumentMatrix(Nhired_corpus_clean)
m_nh <- as.matrix(dtm_nh)
vn_h <- sort(rowSums(m_nh),decreasing=TRUE)
d_nh <- data.frame(word = names(vn_h),freq=vn_h)
head(d_nh, 10)

#Word cloud Not Hired
set.seed(1234)
wordcloud(words = d$word, freq = Nd$freq, min.freq = 10,
          max.words=100, random.order=FALSE, scale = c(3, 0.1),rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))


#Word Frequency for words occuring at least 4 times
findFreqTerms(Ndtm, lowfreq = 4)
#Find correlations between words
findAssocs(Ndtm, terms = "freedom", corlimit = 0.3)

#Freq table 
head(d_nh,10)

#Freq bar plot
barplot(Nd[1:10,]$freq, las = 2, names.arg = d[1:10,]$word,
        col ="lightblue", main ="Most frequent words",
        ylab = "Word frequencies")
#############################################################################################################
#Create corpus (ALL) 
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
#library(SnowballC)
#df_corpus_clean <- tm_map(df_corpus_clean, stemDocument)

#Remove whitespaces
df_corpus_clean <- tm_map(df_corpus_clean, stripWhitespace)
str(df_corpus_clean)

#Data preparation 
df_dtm <- DocumentTermMatrix(df_corpus_clean)

#Create Term doc matrix
tdm<- TermDocumentMatrix(df_corpus_clean)
m <- as.matrix(tdm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)

#Create wordcloud
library(wordcloud)
wordcloud(df_corpus_clean, min.freq = 10, random.order = FALSE)

#FIX ME CLEAN WORDS EXAMINE STEMMING 
#Subset wordcloud
hired <- subset(df, Hired_YN == "Hired")
wordcloud(df$Summary_of_Qualifications__c, max.words = 5, scale = c(3, 0.1))

not_hired <- subset(df, Hired_YN == "Not Hired")
wordcloud(not_hired$Summary_of_Qualifications__c, max.words = 20, scale = c(3, 0.1), colors=brewer.pal(8, "Dark2"))

#######################################################################################################################3
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

