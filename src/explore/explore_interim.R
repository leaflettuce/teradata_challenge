setwd('e:/projects/teradata/src/explore')

# check campaign types
i_campaign <- read.csv('../../data/interim/campaign.csv', stringsAsFactors = FALSE)
i_campaign$X <- NULL
str(i_campaign)
summary(i_campaign$CampaignImageId)

i_contacts <-read.csv('../../data/interim/contacts.csv', stringsAsFactors = FALSE)
summary(as.factor(i_contacts$Military_Branch__c))
summary(as.factor(i_contacts$Highest_Level_of_Education_Completed__c))
