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


#############
# Set Types #
#############


#### FROM M. BECKNER
fctrs <- c(4,6,11,40,41,43,47,51,65,68:70,77,81,82)
df_campaign[,fctrs] <- lapply(df_campaign[,fctrs] , factor)
df_campaign[,54] <- toString(df_campaign[,54])

df_epo_seeker[,3] <- as.factor(df_epo_seeker[,3])

fctrs <- c(5,8)
df_epo_board[,fctrs] <- lapply(df_epo_board[,fctrs] , factor)


fctrs <- c(8,10:12,14:32,37:39,42:55)
df_feedback[,fctrs] <- lapply(df_feedback[,fctrs] , factor)

fctrs <- c(6,7,10,23:26,30:32,34,37,38)
df_activities[,fctrs] <- lapply(df_activities[,fctrs] , factor)

fctrs <- c(2,5,7,15,19:22,29:32,36:39,41,43,44,61,63,64,66,67,69,70,73,74,76:78,92,96,97,100,106:109,111,113,114,116:118,121)
df_accounts[,fctrs] <- lapply(df_accounts[,fctrs] , factor)

fctrs <- c(6,8:13,16,23:25,27,32:34,36,38,39)
df_cases[,fctrs] <- lapply(df_cases[,fctrs] , factor)

fctrs <- c(4,6,9,10,17:24,27,28,30,32,35,36,38,40:42,45:49,52:56,60,61,65,67,68,74:76,78,82,84,89:92,95:104,106,108,109,113:115,118,120,121,126,129,132,133,136,140,141,143,144,148,149,151,152,156:158,160,164,166:170,173,175,180,182,183,185,186,
           188:190,193:195,202,203,205,206,209,210,212,217,220,224,225,227,228,231,233,234,243,245,246,250,251,253,254,257:263,265,269,271,273:275,277:281,284,285,289,291:295,297:300,305:309,312,315,316,318,320,321,323,325:327,330,336:341,348,351,353,357,360,361)
df_contact[,fctrs] <- lapply(df_contact[,fctrs] , factor) 

fctrs <- c(14,15,18:23,25,26,29,30,32)
df_hire[,fctrs] <- lapply(df_hire[,fctrs] , factor)

fctrs <- c(4,7,11:16,18,29,30,32:38,40,42,47,55,56,58,62:67,79,81:83,85:87,93,94,96,100,105:108,110:112)
df_opportunity[,fctrs] <- lapply(df_opportunity[,fctrs] , factor)

fctrs <- c(5,6)
df_type[,fctrs] <- lapply(df_type[,fctrs] , factor)

fctrs <- c(3,9,11,13,14,19:21)
df_email[,fctrs] <- lapply(df_email[,fctrs] , factor)

# END M BECKNER

#################
# more cleaning #
#################

# Accounts

# activities
fctrs <- c(8, 12, 20, 22, 33, 35, 36, 42:44)
df_activities[,fctrs] <- lapply(df_activities[,fctrs] , factor)
 # <------------------------THOUGHTS? SHould these be T/F values be logical or factor types?

# campaign

# cases

# contact
df_contact$MailingPostalCode <- as.factor(df_contact$MailingPostalCode)

df_contact$Mileage_Willing_To_Commute__c <- as.factor(gsub( "< ", "", df_contact$Mileage_Willing_To_Commute__c))
df_contact$Mileage_Willing_To_Commute__c <- factor(df_contact$Mileage_Willing_To_Commute__c, 
                                              levels = c("10 Miles", "20 Miles", "30 Miles",
                                                         "40 Miles", "50 Miles", "100 Miles"))

df_contact$Military_Occupation__c <- as.factor(df_contact$Military_Occupation__c)

df_contact$Disability_Rating__c <- factor(df_contact$Disability_Rating__c, 
                                                   levels = c("Not Disabled", "Pending", "10%", 
                                                              "20%", "30%", "40%", "50%", "60%",
                                                              "70%", "80%", "90%", "100%"))
df_contact$Program_Enrollments__c <- as.integer(df_contact$Program_Enrollments__c)

df_contact$Desired_Industry_for_Employment__c <- as.factor(df_contact$Desired_Industry_for_Employment__c)

# email

# epo board
df_epo_board$transaction_price <- as.numeric(gsub( "\\$", "", df_epo_board$transaction_price))

# epo emp

# epo seeker

# feedback
df_feedback$Survey_Name__c <- as.factor(df_feedback$Survey_Name__c)

df_feedback$Salary_Change__c <- as.factor(df_feedback$Salary_Change__c)

df_feedback$Unemployment_length_after_registration__c <- factor(df_feedback$Unemployment_length_after_registration__c, 
                                          levels = c("< 1", "1", "2", "3", "4", "5", "6", "7", 
                                                     "8", "9", "10", "11", "12", "13", "14", "15", "16",
                                                     "17", "18", "20", "21", "22", "23", "24", "> 24"))

# hire

# opportunity
df_opportunity$FiscalYear <- as.factor(df_opportunity$FiscalYear)

df_opportunity$stayclassy__Raw_Donation_Net_Amount__c <-NULL
# ^^ missed in nulls due to logical type

# type

##########################
# ADD MORE CLEANING HERE #  <------------------------------ !!!!
##########################


#######################
# Print out new files #
#######################

# account
print("writing accounts csv...")
write.csv(df_accounts, "../../data/interim/accounts.csv")

# activites
print("writing activities csv...")
write.csv(df_activities, "../../data/interim/activities.csv")

# campaign
print("writing campaign csv...")
write.csv(df_campaign, "../../data/interim/campaign.csv")

# cases
print("writing cases csv...")
write.csv(df_cases, "../../data/interim/case.csv")

# contact
print("writing contacts csv...")
write.csv(df_contact, "../../data/interim/contacts.csv")

# email
print("writing email csv...")
write.csv(df_email, "../../data/interim/emails.csv")

# epo board
print("writing EPO csvs...")
write.csv(df_epo_board, "../../data/interim/epo_job_board.csv")

# epo emp
write.csv(df_epo_emp, "../../data/interim/epo_employers.csv")

# epo seeker
write.csv(df_epo_seeker, "../../data/interim/epo_seekers.csv")

# feedback
print("writing feedback csv...")
write.csv(df_feedback, "../../data/interim/feedback.csv")

# hire
print("writing hiring csv...")
write.csv(df_hire, "../../data/interim/hiring.csv")

# oppo
print("writing opportunities csv...")
write.csv(df_opportunity, "../../data/interim/opportunities.csv")

# type
print("writing record types csv...")
write.csv(df_type, "../../data/interim/record_types.csv")

