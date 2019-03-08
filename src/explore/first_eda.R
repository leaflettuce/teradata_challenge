#############################
# Library Imports and Setup #
#############################
library(dplyr)
library(tidyr)

# Working Dir
setwd('e:/projects/teradata/src/explore')

# Data Import
df_accounts <- read.csv("../../data/raw/SalesForce_Account.csv")
df_hire <- read.csv("../../data/raw/SalesForce_Hire_Information__c.csv")
df_contact <- read.csv("../../data/raw/Salesforce_Contact.csv")

###############
# Exploration #
###############

str(df_accounts)
summary(df_accounts$Vet_Placement__c)
plot(df_accounts$Number_Of_Matches_Presented__c)

summary(df_hire$Client_Name__c)
summary(df_contact$Id)

# merge hire and contact df's
df_hire_contact_join <- left_join(df_contact, df_hire, by = c("Id" = "Client_Name__c"))

