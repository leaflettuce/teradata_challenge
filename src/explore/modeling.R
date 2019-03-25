# log reg for hire likelyhood
# reg for days in prog
library(tidyverse)

setwd('E:/projects/teradata/src/process/')
df <- read.csv('../../data/processed/team_CAC/contact_hire_CAC.csv')

# cut out unneeded cols
df <- filter(df, Client__c == 1)

keep <- c(1,10,11,16,17,18,40,42,43,65,74,81,106)
df <- df[ , keep]

# remove NAs
df <- df[complete.cases(df), ]

df <- df[!(df$Gender__c == '--None--' & df$Race__c == '--None--'), ]
df <- df[!(df$Gender__c == "" & df$Race__c == ""), ]
df <- df[!(df$Gender__c == ' ' & df$Race__c == ' '), ]

toBeRemoved <- which(df$Race__c=="")
df <- df[-toBeRemoved,]
toBeRemoved <- which(df$Gender__c=="")
df <- df[-toBeRemoved,]

#####################
# set feature types #
#####################

####################
# split test/train #
####################

#########
# model #
#########