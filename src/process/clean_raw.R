#############################
# Library Imports and Setup #
#############################
library(plyr)
library(tidyverse)
library(lubridate)

# Working Dir
setwd('e:/projects/teradata/src/process')

#####################################################
######## BELOW IS CODE FROM M. BECKNER ##############   # slightly edited
##################################################### 

##########################################################################################
# load the required packages.  You'll have to make sure these are installed first ;)
##########################################################################################

# library(plyr)
# library(tidyverse)
# library(lubridate)

##########################################################################################
# import the raw data files.  I started by converting all thirteen files to csv  
# The new dataframes are named "t#" for now just because it's easier to try out code
# on different dfs when all you have to change is a single number  
# For each imported file the columns containing Date values are converted to the proper data type
# Then any numeric columns that should actually be strings are converted
# The finally, any columns containing all nulls or na's are removed
# There are still some columns that need to be changed to Factors.working on that now
##########################################################################################

##############################
# Clean and remove null cols #
##############################

# campaign
df_campaign <- read.csv("../../data/raw/Campaign.csv", stringsAsFactors=FALSE)
dates <- c(8:9,38,40,42:43,81,83,91)
df_campaign[,dates] <- lapply(df_campaign[,dates] , mdy_hm)
IDStoChar <- c(63,68,72,75,76,77,78,79)
df_campaign[,IDStoChar] <- lapply(df_campaign[,IDStoChar] , toString)
df_campaign <- df_campaign[,c(1,3:10,14:16,19:24,27:34,37:43,45:49,51:55,58:59,61:81,83:84,86,89:103)]

# EPO employer
df_epo_emp <- read.csv("../../data/raw/EPO_Teradata_Employer_Profile_Creation_Report.csv", stringsAsFactors=FALSE)
df_epo_emp[,3] <- ymd_hms(df_epo_emp[,3])

# EPO seeker
df_epo_seeker <- read.csv("../../data/raw/EPO_Teradata_Job Seeker_Profile_Creation_Report.csv", stringsAsFactors=FALSE)
dates <- c(4,5)
df_epo_seeker[,dates] <- lapply(df_epo_seeker[,dates] , ymd_hms)

# EPO board
df_epo_board <- read.csv("../../data/raw/EPO_Teradata_Job_Board_Sales_Report.csv", stringsAsFactors=FALSE)
df_epo_board[,2] <- ymd_hms(df_epo_board[,2])
IDStoChar <- c(1,4)
df_epo_board[,IDStoChar] <- lapply(df_epo_board[,IDStoChar] , toString)

# feedback
df_feedback <- read.csv("../../data/raw/Feedback__c.csv", stringsAsFactors=FALSE)
dates <- c(5,7,9,37)
df_feedback[,dates] <- lapply(df_feedback[,dates] , mdy_hm)
IDStoChar <- c(4,19)
df_feedback[,IDStoChar] <- lapply(df_feedback[,IDStoChar] , toString)
df_feedback <- df_feedback[,c(1:2,4:5,7:9,11,13:46,48:49,52:54,60,64:70)]

# Activities
df_activities <- read.csv("../../data/raw/SalesForce_2018Activities.csv", stringsAsFactors=FALSE)
df_activities[,5] <- mdy(df_activities[,5])
dates <- c(14,16,18,24)
df_activities[,dates] <- lapply(df_activities[,dates] , ymd_hms)
df_activities <- df_activities[,c(1:10,12:18,23:25,28:29,40:44,46:47,49:60,62:63,66:69)]

# accounts
df_accounts <- read.csv("../../data/raw/SalesForce_Account.csv", stringsAsFactors=FALSE)
dates <- c(11,13,15:16,18,38,41,45:46,51:52,58,60,72,75,84,88,94:95,141,145,167)
df_accounts[,dates] <- lapply(df_accounts[,dates] , mdy_hm)
IDStoChar <- c(57,118,130)
df_accounts[,IDStoChar] <- lapply(df_accounts[,IDStoChar] , toString)
df_accounts <- df_accounts[,c(1,4:20,22:23,25:27,29:39,41:60,65,68,70:88,90:102,104,117:118,122:128,130,132,141:143,145,150:157,159:160,162:168)]

# cases
df_cases <- read.csv("../../data/raw/SalesForce_Case.csv", stringsAsFactors=FALSE)
dates <- c(17,24,26,28,30,39,41,49,55)
df_cases[,dates] <- lapply(df_cases[,dates] , mdy_hm)
df_cases[,3] <- toString(df_cases[,3])
df_cases <- df_cases[,c(1,3:6,9:17,21:22,24:28,30:31,35:41,45:49,51:56)]

# contact
df_contact <- read.csv("../../data/raw/SalesForce_Contact.csv", stringsAsFactors=FALSE)
dates <- c(13,15,17:18,31,35,42,47,61,69,75,88:91,115:117,125,128,130:131,135,137:138,141,147,154,163,165,171,173,191,195,201,205,209,223,228,234,240,249,262:267,275:276,279,294:296,300,312,331:332,339,342,346,348,357:358,360,373,378,388)
df_contact[,dates] <- lapply(df_contact[,dates] , mdy_hm)
IDStoChar <- c(146,192:193)
df_contact[,IDStoChar] <- lapply(df_contact[,IDStoChar] , toString)
df_contact <- df_contact[,c(1:9,11,13:39,41:91,93:113,115:119,121:132,134:142,144:147,149:156,158:165,168:181,184:185,187:193,195:198,200:201,203:209,213,216:217,221,223:289,291:303,305:389,391)]

# hire
df_hire <- read.csv("../../data/raw/SalesForce_Hire_Information__c.csv", stringsAsFactors=FALSE)
dates <- c(4,6,8,10:11,29,33)
df_hire[,dates] <- lapply(df_hire[,dates] , mdy_hm)
df_hire[,3] <- toString(df_hire[,3])
df_hire <- df_hire[,c(1,3:8,10:34)]

# opportunity
df_opportunity <- read.csv("../../data/raw/SalesForce_Opportunity.csv", stringsAsFactors=FALSE)
dates <- c(12,24,26,28:30,34,46,53:55,64,83:84,97,126)
df_opportunity[,dates] <- lapply(df_opportunity[,dates] , mdy_hm)
IDStoChar <- c(31,85,105:109)
df_opportunity[,IDStoChar] <- lapply(df_opportunity[,IDStoChar] , toString)
df_opportunity <- df_opportunity[,c(1,3:4,6:13,15:38,40,44:47,51:71,75:98,103:130)]

# type
df_type <- read.csv("../../data/raw/SalesForce_RecordType.csv", stringsAsFactors=FALSE)
dates <- c(9,11:12)
df_type[,dates] <- lapply(df_type[,dates] , ymd_hms)
df_type <- df_type[,c(1:2,4:12)]

# email
df_email <- read.csv("../../data/raw/vr__VR_Email_History_Contact__c.csv", stringsAsFactors=FALSE)
dates <- c(5,7,9,16)
df_email[,dates] <- lapply(df_email[,dates] , ymd_hms)
IDStoChar <- c(13)
df_email[,13] <- toString(df_email[,13])
df_email <- df_email[,c(1:2,4:22)]



## Function to count the number of missing values
nmissing <- function(x) sum(is.na(x))
## Apply to every column in a data frame 
colwise(nmissing)(df_email) ## change df_campaign to the desired df name

## Code to see if values from column1 show up in column2.  Substitute columns as desired
## this is an attempt to determine which columns act as keys to columns in other tables
## not sure about this approach yet.  

df_campaign[[1]] %in% df_activities[[4]]

##########################################################################################
# Print the details of each dataframe
##########################################################################################
str(df_campaign, list.len=ncol(df_campaign))
summary(df_campaign)

str(df_epo_emp)
summary(df_epo_emp)

str(df_epo_seeker)
summary(df_epo_seeker)

str(df_epo_board)
summary(df_epo_board)

str(df_feedback)
summary(df_feedback)

str(df_activities)
summary(df_activities)

str(df_accounts, list.len=ncol(df_accounts))
summary(df_accounts)

str(df_cases)
summary(df_cases)

str(df_contact, list.len=ncol(df_contact))
summary(df_contact)

str(df_hire)
summary(df_hire)

str(df_opportunity, list.len=ncol(df_opportunity))
summary(df_opportunity)

str(df_type)
summary(df_type)

str(df_email)
summary(df_email)

#####################################################
########## END CODE FROM M. Beckner #################
#####################################################

################
# Join Merging #
################

# Proven Connections
df_hire$Client_Name__c %in% df_contact$Id

df_cases$AccountId %in% df_accounts$Id
df_cases$ContactId %in% df_contact$Id

df_contact$AccountId %in% df_accounts$Id

df_activities$WHOID %in% df_contact$Id
df_activities$RECORDTYPEID %in% df_type$Id

df_opportunity$AccountId %in% df_accounts$Id
df_opportunity$CampaignId %in% df_campaign$Id

df_email$vr__Contact__c %in% df_contact$Id

df_feedback$ContactID__c %in% df_contact$Id

df_epo_board$company %in% df_epo_emp$name

# test merge
# df_hire_contact_join <- left_join(df_contact, df_hire, by = c("Id" = "Client_Name__c"))
