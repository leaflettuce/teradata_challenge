# log reg for hire likelyhood
# reg for days in prog
library(tidyverse)

setwd('E:/projects/teradata/src/process/')
df <- read.csv('../../data/processed/team_CAC/contact_hire_CAC.csv')

# cut out unneeded cols
df <- filter(df, Client__c == 1)

keep <- c(10,11,18,40,65,74,81,106)
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

y_time <- df$Days_in_Program
y_hired <- df$Hire_Heroes_USA_Confirmed_Hire__c

df$Days_in_Program <- NULL
df$Hire_Heroes_USA_Confirmed_Hire__c <- NULL

hh_workshop_temp <- df$HHUSA_Workshop_Participant__c
df$HHUSA_Workshop_Participant__c <- NULL

used_vol_temp <- df$Used_Volunteer_Services__c
df$Used_Volunteer_Services__c <- NULL

for(name in names(df)){
  df[name] <- droplevels(df[name])
}

for(name in names(df)){
  for(level in unique(df[name])){
    df[paste("dummy", level, sep = "_")] <- ifelse(as.character(df[name]) == level, 1, 0)
  }
}


df[c(1:5)] <- NULL
df$Used_Volunteer <- 0
df$Used_Volunteer <- used_vol_temp

df$workshop <- hh_workshop_temp

#########
# model #
#########

df$days_in_program <- NULL
df$hired <- y_hired

# log reg
log_model <- glm(formula = hired ~ ., family = binomial(link = "logit"), data = df)
summary(log_model)


# regression
df$hired <- NULL
df$Days_in_Program <- y_time

reg <- lm(Days_in_Program ~ ., data = df)
summary(reg)
