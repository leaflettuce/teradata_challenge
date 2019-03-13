setwd('e:/projects/teradata/src/explore')

# check campaign types
i_campaign <- read.csv('../../data/interim/campaign.csv', stringsAsFactors = FALSE)
i_campaign$X <- NULL
str(i_campaign)
summary(i_campaign$CampaignImageId)
