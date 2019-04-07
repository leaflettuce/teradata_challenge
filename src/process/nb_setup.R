library(dplyr)
library(tidyr)
library(reshape2)
library(tm)

setwd('E:/projects/teradata/src/process/')
df <- read.csv('../../data/processed/team_CAC/demo2.csv')

# remove na
df <- df[rowSums(is.na(df)) == 0,]

# format
df <- df[, 3:10]
df$Number_of_dependents__c <- as.factor(df$Number_of_dependents__c)
df$Hire_Heroes_USA_Confirmed_Hire__c <- as.factor(df$Hire_Heroes_USA_Confirmed_Hire__c)
df$Military_Spouse_Caregiver__c <- as.factor(df$Military_Spouse_Caregiver__c)

# more cleaning
df <- df[!(df$Gender__c == '--None--' & df$Race__c == '--None--'), ]
df <- df[!(df$Gender__c == "" & df$Race__c == ""), ]
df <- df[!(df$Gender__c == ' ' & df$Race__c == ' '), ]

toBeRemoved <- which(df$Race__c=="")
df <- df[-toBeRemoved,]


# dummy out everything!
for(name in names(df)){
  df[name] <- droplevels(df[name])
}

for(name in names(df)){
  for(level in levels(df[ , name])){
    df[paste("dummy", level, sep = "_")] <- lapply(df[name], function(x) {ifelse(x == level, 1, 0)})
  }
}

df <- df[ ,c(7,9:65)]

write.csv(df, "../../data/processed/demo2_nb_format.csv", row.names=FALSE)

