# log reg for hire likelyhood
# reg for days in prog
library(tidyverse)
library(lubridate)
library(ggplot2)
library(gmodels)

setwd('E:/projects/teradata/src/process/')
df <- read.csv('../../data/processed/team_CAC/contact_hire_CAC.csv')

# cut out unneeded cols
df <- filter(df, Client__c == 1)

dates <- c(55,62)
df[,dates] <- lapply(df[,dates] , ymd)

#df$actively_searching <- NA
#df$actively_searching <- difftime(df$Date_Turned_Blue__c , df$Date_turned_green__c, units="days")

  
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
str(df)

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
  for(level in levels(df[ , name])){
    df[paste("dummy", level, sep = "_")] <- lapply(df[name], function(x) {ifelse(x == level, 1, 0)})
  }
}


df[c(1:4)] <- NULL
df$Used_Volunteer <- 0
df$Used_Volunteer <- used_vol_temp

df$workshop <- hh_workshop_temp

#########
# model #
#########

df$days_in_program <- NULL
df$hired <- y_hired

# log reg
train <- df[1:12500, ]
test <- df[12501:17068, ]
test_actual <- df$hired[12501:17068]
test$hired <- NULL

log_model <- glm(formula = hired ~ ., family = binomial(link = "logit"), data = train)
summary(log_model)
#anova(log_model, test = 'Chisq')

test_pred <- predict(log_model, test, type = 'response')
test_pred_clip <- ifelse(test_pred > 0.5,1,0)

class_error <- mean(test_pred_clip != test_actual)
print(paste('Accuracy',1-class_error))



# regression
#df$hired <- NULL
#df$Days_in_Program <- y_time
#df$Days_in_Program <- as.numeric(df$Days_in_Program)
#df$Days_in_Program <- lapply(df$Days_in_Program, function(x){ifelse(x >= 0 & x < 500, x, 0)})
#df$Days_in_Program <- as.numeric(unlist(df$Days_in_Program))

#reg <- lm(Days_in_Program ~ ., data = df)
#summary(reg)


# visualize log reg
test$test_pred <- test_pred

ggplot(test, aes(y=Used_Volunteer, x=test_pred)) + geom_point() + 
  stat_smooth(method="glm", method.args = list(family = "binomial"), 
              se = FALSE) 

CrossTable(test_pred_clip, test_actual,
           prop.chisq = FALSE,
           prop.t = FALSE,
           dnn = c("predicted", "actual"))

# ROC
library(ROCR)

roc_pred <- prediction(predictions = test_pred_clip, labels = test_actual)
refit_perf <- performance(roc_pred, measure = 'tpr', x.measure = 'fpr')

# plot
plot(refit_perf, main = "ROC curve of log reg",
     col = "blue", lwd = 3)
abline(a = 0, b = 1, lwd = 2, lty = 2)

# AUC
refit_perf.auc <- performance(refit_pred, measure = "auc")
unlist(refit_perf@y.values)