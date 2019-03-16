setwd('e:/projects/teradata/src/explore')

# check campaign types
i_campaign <- read.csv('../../data/interim/campaign.csv', stringsAsFactors = FALSE)
i_campaign$X <- NULL
str(i_campaign)
summary(i_campaign$CampaignImageId)

# contacts
i_contacts <-read.csv('../../data/interim/contacts.csv', stringsAsFactors = FALSE)
summary(as.factor(i_contacts$Military_Branch__c))
summary(as.factor(i_contacts$Highest_Level_of_Education_Completed__c))

# check hiring
i_hire <- read.csv('../../data/interim/hiring.csv')
str(i_hire)
summary(i_hire$Position_Hired_For__c)
summary(i_hire$Job_Function_Hired_In__c)
summary(i_hire$Salary_Range__c)
summary(i_hire$Hired_Location__c)
summary(i_hire$Employment_Type__c)
summary(i_hire$Months_Unemployed__c)

# accounts
i_account <- read.csv('../../data/interim/accounts.csv')
str(i_account, list.len=ncol(i_account))
summary(i_account$BillingCountry)
summary(i_account$Active_Color__c)

#rec type
i_record <- read.csv('../../data/interim/record_types.csv')
str(i_record)

# activities, case, oppor, 
