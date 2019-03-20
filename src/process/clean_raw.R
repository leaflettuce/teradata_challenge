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
df_campaign[,IDStoChar] <- lapply(df_campaign[,IDStoChar] , as.character)
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
df_epo_board[,IDStoChar] <- lapply(df_epo_board[,IDStoChar] , as.character)

# feedback
df_feedback <- read.csv("../../data/raw/Feedback__c.csv", stringsAsFactors=FALSE)
dates <- c(5,7,9,37)
df_feedback[,dates] <- lapply(df_feedback[,dates] , mdy_hm)
df_feedback$Name <- as.character(df_feedback$Name)
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
df_accounts[,IDStoChar] <- lapply(df_accounts[,IDStoChar] , as.character)
df_accounts <- df_accounts[,c(1,4:20,22:23,25:27,29:39,41:60,65,68,70:88,90:102,104,117:118,122:128,130,132,141:143,145,150:157,159:160,162:168)]

# cases
df_cases <- read.csv("../../data/raw/SalesForce_Case.csv", stringsAsFactors=FALSE)
dates <- c(17,24,26,28,30,39,41,49,55)
df_cases[,dates] <- lapply(df_cases[,dates] , mdy_hm)
df_cases$CaseNumber <- as.character(df_cases$CaseNumber)
df_cases <- df_cases[,c(1,3:6,9:17,21:22,24:28,30:31,35:41,45:49,51:56)]

# contact
df_contact <- read.csv("../../data/raw/SalesForce_Contact.csv", stringsAsFactors=FALSE)
dates <- c(13,15,17:18,31,35,42,47,61,69,75,88:91,115:117,125,128,130:131,135,137:138,141,147,154,163,165,171,173,191,195,201,205,209,223,228,234,240,249,262:267,275:276,279,294:296,300,312,331:332,339,342,346,348,357:358,360,373,378,388)
df_contact[,dates] <- lapply(df_contact[,dates] , mdy_hm)
IDStoChar <- c(146,192:193)
df_contact[,IDStoChar] <- lapply(df_contact[,IDStoChar] , as.character)
df_contact <- df_contact[,c(1:9,11,13:39,41:91,93:113,115:119,121:132,134:142,144:147,149:156,158:165,168:181,184:185,187:193,195:198,200:201,203:209,213,216:217,221,223:289,291:303,305:389,391)]

# hire
df_hire <- read.csv("../../data/raw/SalesForce_Hire_Information__c.csv", stringsAsFactors=FALSE)
dates <- c(4,6,8,10:11,29,33)
df_hire[,dates] <- lapply(df_hire[,dates] , mdy_hm)
df_hire$Name <- as.character(df_hire$Name)
df_hire <- df_hire[,c(1,3:8,10:34)]

# opportunity
df_opportunity <- read.csv("../../data/raw/SalesForce_Opportunity.csv", stringsAsFactors=FALSE)
dates <- c(12,24,26,28:30,34,46,53:55,64,83:84,97,126)
df_opportunity[,dates] <- lapply(df_opportunity[,dates] , mdy_hm)
IDStoChar <- c(31,85,105:109)
df_opportunity[,IDStoChar] <- lapply(df_opportunity[,IDStoChar] , as.character)
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
df_email$vr__Email_ID__c <- as.character(df_email$vr__Email_ID__c)
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

#str(df_campaign, list.len=ncol(df_campaign))
#summary(df_campaign)

#str(df_epo_emp)
#summary(df_epo_emp)

#str(df_epo_seeker)
#summary(df_epo_seeker)

#str(df_epo_board)
#summary(df_epo_board)

#str(df_feedback)
#summary(df_feedback)

#str(df_activities)
#summary(df_activities)

#str(df_accounts, list.len=ncol(df_accounts))
#summary(df_accounts)

#str(df_cases)
#summary(df_cases)

#str(df_contact, list.len=ncol(df_contact))
#summary(df_contact)

#str(df_hire)
#summary(df_hire)

#str(df_opportunity, list.len=ncol(df_opportunity))
#summary(df_opportunity)

#str(df_type)
#summary(df_type)

#str(df_email)
#summary(df_email)
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

#accounts
for (i in 1:nrow(df_accounts)){
  if(df_accounts[i,34]!=""){
    df_accounts[i,34] <- paste("01-", df_accounts[i,34], sep = "")
  }
}

for (i in 1:nrow(df_accounts)){
  if(df_accounts[i,95]!=""){
    df_accounts[i,95] <- paste("01-", df_accounts[i,95], sep = "")
  }
}

dates <- c(34,95)
df_accounts[,dates] <- lapply(df_accounts[,dates] , dmy)

#campaign
df_campaign <- separate(df_campaign, 42, c("Program_Location_City", "Program_Location_State"), sep = ",", remove = TRUE) 
df_campaign$Program_Location_State <- as.factor(df_campaign$Program_Location_State)
df_campaign$IsActive <- as.factor(df_campaign$IsActive)
#contact
dates <- c(34,171)
df_contact[,dates] <- lapply(df_contact[,dates] , mdy)

#feedback
df_feedback$Length_with_current_employer__c <- as.factor(df_feedback$Length_with_current_employer__c)


###############################
#######33 DO THIS #############
###############################
summary(df_contact$Security_Clearance_Description__c) # cut dates out and replace with yet

clean_clearance <- function(x) {
  if (grepl('no', tolower(x))) {
    'None'
  }
  else if (grepl('yes', tolower(x))){
    'Yes - not specified'
  }
  else if (grepl('inactive', tolower(x))){
    'Inactive'
  }
  else if (grepl('top secret', tolower(x))){
    'Top Secret'
  }
  else if (grepl('sbi/sci', tolower(x))){
    'Top Secret'
  }
  else if (grepl('secret', tolower(x))){
    'secret'
  }
  else if (grepl('confidential', tolower(x))){
    'Confidential'
  }
  else if (grepl('yes', tolower(x))){
    'Yes - not specified'
  }
  else if ((nchar(x) > 1) & (!is.na(x))) { 
    'Yes - not specified'
  }
  else {
    'None'
  }
}

df_contact$Security_Clearance_Description__c <- lapply(as.character(df_contact$Security_Clearance_Description__c), 
                                                       clean_clearance)
df_contact$Security_Clearance_Description__c <- as.factor(unlist(df_contact$Security_Clearance_Description__c))


# clean languages
summary(df_contact$Languages_Spoken__c) # clean

clean_language <- function(x) {
  if (grepl('english', tolower(x)) & grepl('spanish', tolower(x)))
 {
    'English and Spanish'
  }
  else if (grepl('german', tolower(x))) {
    'German'
  }
  else if (grepl('spanish', tolower(x))) {
    'Spanish'
  }
  else if (grepl('arabic', tolower(x))) {
    'Arabic'
  }
  else if (grepl('tagalog', tolower(x))) {
    'Tagalog'
  }
  else if (grepl('korean', tolower(x))) {
    'Korean'
  }
  else if (grepl('french', tolower(x))) {
    'French'
  }
  else if (grepl('russian', tolower(x))) {
    'Russian'
  }
  else if (grepl('vietnamese', tolower(x))) {
    'Vietnamese'
  }
  else if (grepl('chinese', tolower(x))) {
    'Chinese'
  }
  else if (grepl('italian', tolower(x))) {
    'Italian'
  }
  else if (grepl('japanese', tolower(x))) {
    'Japanese'
  }
  else if (grepl('english', tolower(x))) {
    'English'
  }
  else if (grepl('none', tolower(x)) | (grepl('na', tolower(x)))) {
    'na'
  }
  else if ((nchar(x) > 1) & (!is.na(x))) {
    'Other'
  }
  else {
    'na'
  }
}

df_contact$Languages_Spoken__c <- lapply(as.character(df_contact$Languages_Spoken__c), clean_language)
df_contact$Languages_Spoken__c <- as.factor(unlist(df_contact$Languages_Spoken__c))

# job type
summary(df_contact$Job_Type__c) # split/clean

df_contact$Job_Type_Full_Time <- lapply(df_contact$Job_Type__c, 
                                        function(x) {ifelse(grepl('Full-Time', x), 1, 0)})
df_contact$Job_Type_Full_Time <- as.factor(unlist(df_contact$Job_Type_Full_Time))

df_contact$Job_Type_Part_Time <- lapply(df_contact$Job_Type__c, 
                                        function(x) {ifelse(grepl('Part-Time', x), 1, 0)})
df_contact$Job_Type_Part_Time <- as.factor(unlist(df_contact$Job_Type_Part_Time))

df_contact$Job_Type_Contract <- lapply(df_contact$Job_Type__c, 
                                        function(x) {ifelse(grepl('Contract', x), 1, 0)})
df_contact$Job_Type_Contract <- as.factor(unlist(df_contact$Job_Type_Contract))

df_contact$Job_Type_Temp <- lapply(df_contact$Job_Type__c, 
                                        function(x) {ifelse(grepl('Temporary', x), 1, 0)})
df_contact$Job_Type_Temp <- as.factor(unlist(df_contact$Job_Type_Temp))

df_contact$Job_Type_Fed <- lapply(df_contact$Job_Type__c, 
                                   function(x) {ifelse(grepl('Federal', x), 1, 0)})
df_contact$Job_Type_Fed <- as.factor(unlist(df_contact$Job_Type_Fed))

# State of emp
summary(df_contact$Desired_State_of_Employment__c) # Clean

clean_states <- function(x) {
  if (grepl('BA', toupper(x))) {
    'na'
  }
  else if (grepl('HA', toupper(x))) {
    'HI'
  }
  else if (grepl('LV', toupper(x))) {
    'LA'
  }
  else if (grepl('NB', toupper(x))) {
    'NC'
  }
  else if (grepl('HA', toupper(x))) {
    'HI'
  }
  else if (grepl('PI', toupper(x))) {
    'RI'
  }
  else if (grepl('PR', toupper(x))) {
    'PA'
  }
  else if (grepl('GU', toupper(x))) {
    'GA'
  }
  else if (grepl('NA', toupper(x))) {
    'na'
  }
  else if ((nchar(x) == 2) & (!is.na(x))) {
    toupper(x)
  }
  else if (grepl('california', tolower(x))) {
    'CA'
  }
  else if (grepl('texas', tolower(x))) {
    'TX'
  }
  else if (grepl('florida', tolower(x))) {
    'FL'
  }
  else if (grepl('colorado', tolower(x))) {
    'CO'
  }
  else if (grepl('georgia', tolower(x))) {
    'GA'
  }
  else if (grepl('north carolina', tolower(x))) {
    'NC'
  }
  else if (grepl('virginia', tolower(x))) {
    'VA'
  }
  else if (grepl('new york', tolower(x))) {
    'NY'
  }
  else if (grepl('washington', tolower(x))) {
    'WA'
  }
  else if (grepl('arizona', tolower(x))) {
    'AZ'
  }
  else if (grepl('south carolina', tolower(x))) {
    'SC'
  }
  else if (grepl('maryland', tolower(x))) {
    'MD'
  }
  else if (grepl('michigan', tolower(x))) {
    'MI'
  }
  else if (grepl('alabama', tolower(x))) {
    'AL'
  }
  else if (grepl('illinois', tolower(x))) {
    'IL'
  }
  else if (grepl('indiana', tolower(x))) {
    'IN'
  }
  else if (grepl('jersey', tolower(x))) {
    'NJ'
  }
  else if (grepl('Missouri', tolower(x))) {
    'MO'
  }
  else if (grepl('penn', tolower(x))) {
    'PA'
  }
  else if (grepl('tenn', tolower(x))) {
    'TN'
  }
  else if (grepl('hawaii', tolower(x))) {
    'HI'
  }
  else if (grepl('louis', tolower(x))) {
    'LA'
  }
  else if (grepl('okla', tolower(x))) {
    'OK'
  }
  else if (grepl('nevada', tolower(x))) {
    'NV'
  }
  else if (grepl('oregon', tolower(x))) {
    'OR'
  }
  else if (grepl('kent', tolower(x))) {
    'KY'
  }
  else if (grepl('wisc', tolower(x))) {
    'WI'
  }
  else if (grepl('minne', tolower(x))) {
    'MN'
  }
  else if (grepl('utah', tolower(x))) {
    'UT'
  }
  else if (grepl('alaska', tolower(x))) {
    'AK'
  }
  else if (grepl('district', tolower(x))) {
    'DC'
  }
  else if (grepl('delaware', tolower(x))) {
    'DE'
  }
  else if (grepl('mass', tolower(x))) {
    'MA'
  }
  else {
    'na'
  }
}

df_contact$Desired_State_of_Employment__c <- lapply(as.character(df_contact$Desired_State_of_Employment__c), clean_states)
df_contact$Desired_State_of_Employment__c <- as.factor(unlist(df_contact$Desired_State_of_Employment__c))


# Salary
summary(df_contact$Min_Salary_Expectations__c) # NORMALIZE OR SPLIT

# set type
df_contact$Salary_expectation_type <- lapply(df_contact$Min_Salary_Expectations__c, 
                                             function(x) {
                                               if (grepl('hr', x)){ 
                                               'hourly'
                                                 }
                                                else if (nchar(as.character(x)) > 1) {
                                                  'annually'
                                                }
                                               else {
                                                 'na'
                                               }
                                             })
df_contact$Salary_expectation_type <- as.factor(unlist(df_contact$Salary_expectation_type))

# annually
df_contact$Salary_annual_expected <- lapply(df_contact$Min_Salary_Expectations__c, 
                                            function(x) {
                                              if (grepl('hr', x)){ 
                                                'na'
                                              }
                                              else if (nchar(as.character(x)) > 1) {
                                                gsub( "\\$", "", as.character(x))
                                              }
                                              else {
                                                'na'
                                              }
                                            })
df_contact$Salary_annual_expected <- lapply(df_contact$Salary_annual_expected, function(x) {substr(x, 1, 6)})
df_contact$Salary_annual_expected<- lapply(df_contact$Salary_annual_expected, function(x) {gsub(",", "", x)})
df_contact$Salary_annual_expected <- as.integer(df_contact$Salary_annual_expected)

# hourly
df_contact$Salary_hourly_expected <- lapply(df_contact$Min_Salary_Expectations__c, 
                                            function(x) {
                                              if (grepl('hr', x)){ 
                                                gsub( "\\$", "", as.character(x))
                                              }
                                              else if (nchar(as.character(x)) > 1) {
                                                'na'
                                              }
                                              else {
                                                'na'
                                              }
                                            })
df_contact$Salary_hourly_expected <- lapply(df_contact$Salary_hourly_expected, function(x) {substr(x, 1, 2)})
df_contact$Salary_hourly_expected <- as.integer(df_contact$Salary_hourly_expected)




#################
# CLEANING 3/15 #
#################

# more in contacts <- REMOVE MORE?
# aggregate state
df_contact$MailingState <- lapply(as.character(df_contact$MailingState), clean_states)
df_contact$MailingState <- as.factor(unlist(df_contact$MailingState))


# usa into united states 
df_contact$MailingCountry <- lapply(df_contact$MailingCountry, function(x) {ifelse(as.character(x) == 'USA', 'United States', as.character(x))})
df_contact$MailingCountry <- as.factor(unlist(df_contact$MailingCountry))
df_contact$MailingCountry <- lapply(df_contact$MailingCountry, function(x) {ifelse(grepl('-', as.character(x)), '', as.character(x))})
df_contact$MailingCountry <- as.factor(unlist(df_contact$MailingCountry))
df_contact$MailingCountry <- lapply(df_contact$MailingCountry, function(x) {ifelse(grepl('2', as.character(x)), '', as.character(x))})
df_contact$MailingCountry <- as.factor(unlist(df_contact$MailingCountry))
df_contact$MailingCountry <- lapply(df_contact$MailingCountry, function(x) {ifelse(grepl('3', as.character(x)), '', as.character(x))})
df_contact$MailingCountry <- as.factor(unlist(df_contact$MailingCountry))


# LAST RNAK FUNCTION
clean_rank <- function(x){
  x <- toupper(gsub(" ", "", x, fixed = TRUE)) # remove whitespace
  if (grepl('E-4', x) | grepl('E4', x)) {
    'E-4'
  }
  else if (grepl('E-5', x) | grepl('E5', x)) {
    'E-5'
  }
  else if (grepl('E-6', x) | grepl('E6', x)) {
    'E-6'
  }
  else if (grepl('E-7', x)| grepl('E7', x)) {
    'E-7'
  }
  else if (grepl('E-9', x) | grepl('E9', x)) {
    'E-9'
  }
  else if (grepl('E-3', x) | grepl('E3', x)) {
    'E-3'
  }
  else if (grepl('E-2', x) | grepl('E2', x)) {
    'E-2'
  }
  else if (grepl('E-8', x) | grepl('E8', x)) {
    'E-8'
  }
  else if (grepl('O-3', x) | grepl('O3', x)) {
    'O-3'
  }
  else if (grepl('O-2', x) | grepl('O2', x)) {
    'O-2'
  }
  else if (grepl('O-4', x) | grepl('O4', x)) {
    'O-4'
  }
  else if (grepl('O-5', x) | grepl('O5', x)) {
    'O-4'
  }
  else if (grepl('W-4', x) | grepl('W4', x)) {
    'W-4'
  }
  else if (grepl('W-3', x) | grepl('W3', x)) {
    'W-3'
  }
  else if (grepl('W-1', x) | grepl('W1', x)) {
    'W-1'
  }
  else if (grepl('W-5', x) | grepl('W5', x)) {
    'W-5'
  }
  else if (grepl('W-2', x) | grepl('W2', x)) {
    'W-2'
  }
  else {
    'not specified'
  }
}

df_contact$Last_Rank__c <- lapply(as.character(df_contact$Last_Rank__c), clean_rank)
df_contact$Last_Rank__c <- as.factor(unlist(df_contact$Last_Rank__c))

#
clean_education <- function(x) {
  x <- tolower(as.character(x))
  if (grepl('4', x) | grepl('bach', x) | grepl('ba', x) | grepl('bs', x)) {
    'Bachelors'
  }
  else if (grepl('2', x) | grepl('asso', x) | grepl('aa', x) | grepl('as', x)) {
    'Associates'
  }
  else if (grepl('post', x) | grepl('master', x) | grepl('ma', x) | grepl('ms', x)) {
    'Masters'
  }
  else if (grepl('doct', x) | grepl('phd', x) | grepl('md', x)) {
    'Doctorate'
  }
  else if (grepl('some', x)) {
    'Some College'
  }
  else if (grepl('ged', x) | grepl('high', x)) {
    'High School / GED'
  }
  else {
    'not specified'
  }
}

df_contact$Highest_Level_of_Education_Completed__c <- lapply(as.character(df_contact$Highest_Level_of_Education_Completed__c), clean_education)
df_contact$Highest_Level_of_Education_Completed__c <- as.factor(unlist(df_contact$Highest_Level_of_Education_Completed__c))


# status
clean_status <- function(x) {
  x <- tolower(as.character(x))
  if (grepl('full', x)) {
    'full time'
  }
  else if (grepl('part', x)){
    'part time'
  }
  else if (grepl('enrolled', x) | grepl('student', x)) {
    'student'
  }
  else if (grepl('contract', x)){
    'contract / temporary'
  }
  else if (grepl('under', x)) {
    'under employed'
  }
  else if (x == ''){
    'not specified'
  }
  else {
    x
  }
}

df_contact$Status__c <- lapply(df_contact$Status__c, clean_status)
df_contact$Status__c <- as.factor(unlist(df_contact$Status__c))

# volunteer
clean_volunteer_services <- function(x) {
  x <- tolower(as.character(x))  
  
  if (grepl('mock', x)) {
    'Mock Interview'
  }
  else if (grepl('career', x)) {
    'Career Counseling'
  }
  else if (grepl('resume', x)) {
    'Resume / Application'
  }

  else {
    'None'
  }
}

df_contact$Volunteer_Services__c <- lapply(df_contact$Volunteer_Services__c, clean_volunteer_services)
df_contact$Volunteer_Services__c <- as.factor(unlist(df_contact$Volunteer_Services__c))


# military branch
df_contact$Military_Branch__c <- lapply(as.character(df_contact$Military_Branch__c), function(x) {ifelse(x == '--None--', '', x)})
df_contact$Military_Branch__c <- as.factor(unlist(df_contact$Military_Branch__c))




############################
# Additional hire cleaning #
############################

# city state separator
df_hire <- separate(df_hire, 16, c("Hired_Location_City", "Hired_Location_State"), sep = ",", remove = TRUE)
df_hire$Hired_Location_State <- as.factor(df_hire$Hired_Location_State)

df_hire$Hired_Location_State <- lapply(as.character(df_hire$Hired_Location_State), clean_states)
df_hire$Hired_Location_State <- as.factor(unlist(df_hire$Hired_Location_State))


# account
# billing state
df_accounts$BillingState <- lapply(as.character(df_accounts$BillingState), clean_states)
df_accounts$BillingState <- as.factor(unlist(df_accounts$BillingState))



######################
######################
######################

#################
# CLEANING 3/16 #
#################

# contact
df_contact$Service_Members_Status__c <- as.factor(df_contact$Service_Members_Status__c)
df_contact$Discharge_Disposition__c <- as.factor(df_contact$Discharge_Disposition__c)



####################################
# MERGE DATASETS - FROM MITCH 3/18 #
####################################

df_hire_contact_join <- left_join(df_contact, df_hire, by = c("Id" = "Client_Name__c"))

# reduce
df_topic_edit1 <- df_hire_contact_join[,c(1,4:6,9:11,23:26,47,49,54,58,66,79,85,89,96,99,104,117,157,168,179,
                                          183,186,187,190,238:241,257,260,261,272,283,292,302,303,305:310,
                                          315,318,336,337,359,361,377,382:389,394,395)]
# crate age
df_topic_edit1["Age"] <- as.numeric(today() - ymd(as.character(df_topic_edit1$Date_Of_Birth__c)))/365

# replace na with 0
for (i in 1:nrow(df_topic_edit1)){
  if(is.na(df_topic_edit1[i,"Age"])){
    df_topic_edit1[i,"Age"] <- 0
  }
}

# bin ages
df_topic_edit1["Age_bin"] <- ""

for (i in 1:nrow(df_topic_edit1)){
  if (df_topic_edit1[i,"Age"] < 16) {
    df_topic_edit1[i,"Age_bin"] <- 'Underage'
  }
  else if (df_topic_edit1[i,"Age"] >= 16 & df_topic_edit1[i,"Age"] < 21) {
    df_topic_edit1[i,"Age_bin"] <- '16-20'
  }
  else if (df_topic_edit1[i,"Age"] >= 21 & df_topic_edit1[i,"Age"] < 26) {
    df_topic_edit1[i,"Age_bin"] <- '21-25'
  }
  else if (df_topic_edit1[i,"Age"] >= 26 & df_topic_edit1[i,"Age"] < 31) {
    df_topic_edit1[i,"Age_bin"] <- '26-30'
  }
  else if (df_topic_edit1[i,"Age"] >= 31 & df_topic_edit1[i,"Age"] < 36) {
    df_topic_edit1[i,"Age_bin"] <- '31-35'
  }
  else if (df_topic_edit1[i,"Age"] >= 36 & df_topic_edit1[i,"Age"] < 41) {
    df_topic_edit1[i,"Age_bin"] <- '36-40'
  }
  else if (df_topic_edit1[i,"Age"] >= 41 & df_topic_edit1[i,"Age"] < 46) {
    df_topic_edit1[i,"Age_bin"] <- '41-45'
  }
  else if (df_topic_edit1[i,"Age"] >= 46 & df_topic_edit1[i,"Age"] < 51) {
    df_topic_edit1[i,"Age_bin"] <- '46-50'
  }
  else if (df_topic_edit1[i,"Age"] >= 51 & df_topic_edit1[i,"Age"] < 56) {
    df_topic_edit1[i,"Age_bin"] <- '51-55'
  }
  else if (df_topic_edit1[i,"Age"] >= 56 & df_topic_edit1[i,"Age"] < 61) {
    df_topic_edit1[i,"Age_bin"] <- '56-60'
  }
  else if (df_topic_edit1[i,"Age"] >= 61 & df_topic_edit1[i,"Age"] < 66) {
    df_topic_edit1[i,"Age_bin"] <- '61-65'
  }
  else if (df_topic_edit1[i,"Age"] >= 66 & df_topic_edit1[i,"Age"] < 71) {
    df_topic_edit1[i,"Age_bin"] <- '66-70'
  }
  else if (df_topic_edit1[i,"Age"] >= 71 & df_topic_edit1[i,"Age"] < 76) {
    df_topic_edit1[i,"Age_bin"] <- '71-75'
  }
  else if (df_topic_edit1[i,"Age"] >= 76 & df_topic_edit1[i,"Age"] < 81) {
    df_topic_edit1[i,"Age_bin"] <- '76-80'
  }
  else {
    df_topic_edit1[i,"Age_bin"] <- 'not specified'
  }
}

df_topic_edit1$Age_bin <- as.factor(unlist(df_topic_edit1$Age_bin))

# create days in program
df_topic_edit1["Days_in_Program"] <- NA

for (i in 1:nrow(df_topic_edit1)){
	if(!is.na(df_topic_edit1[i,"Date_Assigned_To_Online__c"])){
  		if(df_topic_edit1[i,"Active_Color__c"] =="Black"){
    			df_topic_edit1[i,"Days_in_Program"] <- difftime(df_topic_edit1[i, "Date_Turned_Black__c"] , df_topic_edit1[i,"Date_Assigned_To_Online__c"], units="days")
  		}
		else if (df_topic_edit1[i,"Active_Color__c"] =="Grey") {
    			df_topic_edit1[i,"Days_in_Program"] <- difftime(df_topic_edit1[i, "Date_turned_grey__c"] , df_topic_edit1[i,"Date_Assigned_To_Online__c"], units="days")
  		}
		else if (df_topic_edit1[i,"Active_Color__c"] =="Blue") {
    			df_topic_edit1[i,"Days_in_Program"] <- difftime(df_topic_edit1[i, "Confirmed_Hired_Date__c.y"] , df_topic_edit1[i,"Date_Assigned_To_Online__c"], units="days")
  		}
		else if (df_topic_edit1[i,"Active_Color__c"] =="Green" | df_topic_edit1[i,"Active_Color__c"] =="Purple" | df_topic_edit1[i,"Active_Color__c"] =="Red") {
    			df_topic_edit1[i,"Days_in_Program"] <- difftime(as.POSIXct("2019-3-1", format = "%Y-%m-%d", tz = "") , df_topic_edit1[i,"Date_Assigned_To_Online__c"], units="days")
  		}
		else {
    			df_topic_edit1[i,"Days_in_Program"] <- NA
  		}
	}
	else if(!is.na(df_topic_edit1[i,"Date_Assigned_To_HHUSA__c"])){
  		if(df_topic_edit1[i,"Active_Color__c"] =="Black"){
    			df_topic_edit1[i,"Days_in_Program"] <- difftime(df_topic_edit1[i, "Date_Turned_Black__c"] , df_topic_edit1[i,"Date_Assigned_To_HHUSA__c"], units="days")
  		}
		else if (df_topic_edit1[i,"Active_Color__c"] =="Grey") {
    			df_topic_edit1[i,"Days_in_Program"] <- difftime(df_topic_edit1[i, "Date_turned_grey__c"] , df_topic_edit1[i,"Date_Assigned_To_HHUSA__c"], units="days")
  		}
		else if (df_topic_edit1[i,"Active_Color__c"] =="Blue") {
    			df_topic_edit1[i,"Days_in_Program"] <- difftime(df_topic_edit1[i, "Confirmed_Hired_Date__c.y"] , df_topic_edit1[i,"Date_Assigned_To_HHUSA__c"], units="days")
  		}
		else if (df_topic_edit1[i,"Active_Color__c"] =="Green" | df_topic_edit1[i,"Active_Color__c"] =="Purple" | df_topic_edit1[i,"Active_Color__c"] =="Red") {
    			df_topic_edit1[i,"Days_in_Program"] <- difftime(as.POSIXct("2019-3-1", format = "%Y-%m-%d", tz = "") , df_topic_edit1[i,"Date_Assigned_To_HHUSA__c"], units="days")
  		}
		else {
    			df_topic_edit1[i,"Days_in_Program"] <- NA
  		}
	}
	else {
    			df_topic_edit1[i,"Days_in_Program"] <- NA
  		}	
}

# get rid of clients
df_clients <- filter(df_topic_edit1, Client__c == 1)

# outlier row
df_clients_no <- filter(df_clients, Days_in_Program < 73000 & Days_in_Program >0)

# create spouse
df_contact_spouses <- filter(df_topic_edit1, Military_Spouse_Caregiver__c ==1 & Client__c == 1)
str(df_contact_spouses, list.len=ncol(df_contact_spouses))
summary(df_contact_spouses)

# create vet
df_contact_vets <- filter(df_topic_edit1, Military_Spouse_Caregiver__c ==0 & Client__c == 1)
str(df_contact_vets, list.len=ncol(df_contact_vets))
summary(df_topic_edit1)


############################
# CREATE TEAM CAC REDUCDED #
############################

df_hire_contact_join <- left_join(df_contact, df_hire, by = c("Id" = "Client_Name__c"))

# reduce
df_topic_edit2 <- df_hire_contact_join[,c(1,4:6,9:11,18,20,23:26,30,34,35,45,47,49,53,54,58:60,66,79,85,89,95,
                                          96,97,99,101,102,104,117,123,125,126,157,168,170,179,180, 
                                          183,186,187,190,217,218,222,227,231,238:241,257,260,261,272,283,292,293,
                                          294,297,299, 302,303,305:310,318,324,336,337,338,339,357,
                                          359,361,362:369,377,382:389,392,394,395)]

# crate age 
df_topic_edit2["Age"] <- as.numeric(today() - ymd(as.character(df_topic_edit2$Date_Of_Birth__c)))/365

# replace na with 0
for (i in 1:nrow(df_topic_edit2)){
  if(is.na(df_topic_edit2[i,"Age"])){
    df_topic_edit2[i,"Age"] <- 0
  }
}


# create days in program
df_topic_edit2["Days_in_Program"] <- NA

for (i in 1:nrow(df_topic_edit2)){
	if(!is.na(df_topic_edit2[i,"Date_Assigned_To_Online__c"])){
  		if(df_topic_edit2[i,"Active_Color__c"] =="Black"){
    			df_topic_edit2[i,"Days_in_Program"] <- difftime(df_topic_edit2[i, "Date_Turned_Black__c"] , df_topic_edit2[i,"Date_Assigned_To_Online__c"], units="days")
  		}
		else if (df_topic_edit2[i,"Active_Color__c"] =="Grey") {
    			df_topic_edit2[i,"Days_in_Program"] <- difftime(df_topic_edit2[i, "Date_turned_grey__c"] , df_topic_edit2[i,"Date_Assigned_To_Online__c"], units="days")
  		}
		else if (df_topic_edit2[i,"Active_Color__c"] =="Blue") {
    			df_topic_edit2[i,"Days_in_Program"] <- difftime(df_topic_edit2[i, "Confirmed_Hired_Date__c.y"] , df_topic_edit2[i,"Date_Assigned_To_Online__c"], units="days")
  		}
		else if (df_topic_edit2[i,"Active_Color__c"] =="Green" | df_topic_edit2[i,"Active_Color__c"] =="Purple" | df_topic_edit2[i,"Active_Color__c"] =="Red") {
    			df_topic_edit2[i,"Days_in_Program"] <- difftime(as.POSIXct("2019-3-1", format = "%Y-%m-%d", tz = "") , df_topic_edit2[i,"Date_Assigned_To_Online__c"], units="days")
  		}
		else {
    			df_topic_edit2[i,"Days_in_Program"] <- NA
  		}
	}
	else if(!is.na(df_topic_edit2[i,"Date_Assigned_To_HHUSA__c"])){
  		if(df_topic_edit2[i,"Active_Color__c"] =="Black"){
    			df_topic_edit2[i,"Days_in_Program"] <- difftime(df_topic_edit2[i, "Date_Turned_Black__c"] , df_topic_edit2[i,"Date_Assigned_To_HHUSA__c"], units="days")
  		}
		else if (df_topic_edit2[i,"Active_Color__c"] =="Grey") {
    			df_topic_edit2[i,"Days_in_Program"] <- difftime(df_topic_edit2[i, "Date_turned_grey__c"] , df_topic_edit2[i,"Date_Assigned_To_HHUSA__c"], units="days")
  		}
		else if (df_topic_edit2[i,"Active_Color__c"] =="Blue") {
    			df_topic_edit2[i,"Days_in_Program"] <- difftime(df_topic_edit2[i, "Confirmed_Hired_Date__c.y"] , df_topic_edit2[i,"Date_Assigned_To_HHUSA__c"], units="days")
  		}
		else if (df_topic_edit2[i,"Active_Color__c"] =="Green" | df_topic_edit2[i,"Active_Color__c"] =="Purple" | df_topic_edit2[i,"Active_Color__c"] =="Red") {
    			df_topic_edit2[i,"Days_in_Program"] <- difftime(as.POSIXct("2019-3-1", format = "%Y-%m-%d", tz = "") , df_topic_edit2[i,"Date_Assigned_To_HHUSA__c"], units="days")
  		}
		else {
    			df_topic_edit2[i,"Days_in_Program"] <- NA
  		}
	}
	else {
    			df_topic_edit2[i,"Days_in_Program"] <- NA
  		}	
}

str(df_topic_edit2)

# connect to feedback
df_topic_edit2_feed <-left_join(df_topic_edit2, df_feedback, by = c("Id" = "ContactID__c"))

df_topic_edit2_fin <- df_topic_edit2_feed[ , c(1:104, 133)]


# final cleaning for edit 2
# get rid of clients
df2_clients <- filter(df_topic_edit2_fin, Client__c == 1)
df2_volunteers <- filter(df_topic_edit2_fin, Volunteer__c == 1)
df2_clients_w_vol <- filter(df_topic_edit2_fin, Used_Volunteer_Services__c == 1 & Client__c == 1)
df2_clients_wo_vol <- filter(df_topic_edit2_fin, Used_Volunteer_Services__c == 0 & Client__c == 1)

#######################
# Print out new files #
#######################

# account
print("writing accounts csv...")
write.csv(df_accounts, "../../data/interim/accounts.csv", row.names=FALSE)

# activites !
print("writing activities csv...")
write.csv(df_activities, "../../data/interim/activities.csv", row.names=FALSE)

# campaign
print("writing campaign csv...")
write.csv(df_campaign, "../../data/interim/campaign.csv", row.names=FALSE)

# cases
print("writing cases csv...")
write.csv(df_cases, "../../data/interim/case.csv", row.names=FALSE)

# contact !
print("writing contacts csv...")
write.csv(df_contact, "../../data/interim/contacts.csv", row.names=FALSE)

# email !
print("writing email csv...")
write.csv(df_email, "../../data/interim/emails.csv", row.names=FALSE)

# epo board
print("writing EPO csvs...")
write.csv(df_epo_board, "../../data/interim/epo_job_board.csv", row.names=FALSE)

# epo emp
write.csv(df_epo_emp, "../../data/interim/epo_employers.csv", row.names=FALSE)

# epo seeker
write.csv(df_epo_seeker, "../../data/interim/epo_seekers.csv", row.names=FALSE)

# feedback
print("writing feedback csv...")
write.csv(df_feedback, "../../data/interim/feedback.csv", row.names=FALSE)

# hire
print("writing hiring csv...")
write.csv(df_hire, "../../data/interim/hiring.csv", row.names=FALSE)

# oppo
print("writing opportunities csv...")
write.csv(df_opportunity, "../../data/interim/opportunities.csv", row.names=FALSE)

# type
print("writing record types csv...")
write.csv(df_type, "../../data/interim/record_types.csv", row.names=FALSE)


##########################
# WRITE REDUCED DATASETS #
#########################
 
# TEAM_MAT_DS
print("writing reduced datasets for team 2...")
write.csv(df_topic_edit1, "../../data/processed/contact_hire_MAT.csv", row.names=FALSE)
# df_contact_spouses
write.csv(df_contact_spouses, "../../data/processed/spouses_MAT.csv", row.names=FALSE)
# df_contact_vets
write.csv(df_contact_vets, "../../data/processed/vets_MAT.csv", row.names=FALSE)

# TEAM_CAC_DS
print("writing reduced datasets for team 1...")
write.csv(df_topic_edit2_fin, "../../data/processed/contact_hire_CAC.csv", row.names=FALSE)
# subsets
write.csv(df2_clients, "../../data/processed/clients_CAC.csv", row.names=FALSE)
write.csv(df2_volunteers, "../../data/processed/volunteers_CAC.csv", row.names=FALSE)
write.csv(df2_clients_w_vol, "../../data/processed/clients_w_volunteers.csv", row.names=FALSE)
write.csv(df2_clients_wo_vol, "../../data/processed/clients_without_volunteerts.csv", row.names=FALSE)

