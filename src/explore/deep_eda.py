# -*- coding: utf-8 -*-
"""
Created on Sun Mar 17 13:18:43 2019

@author: andyj
"""

import pandas as pd
import matplotlib as plt
import seaborn as sns
import os 

########################
# contacts epxloration #
########################

# setwd
os.chdir('E:/projects/teradata/src/explore')
# import
df_contacts = pd.read_csv('../../data/interim/contacts.csv', encoding = "ISO-8859-1")

# detailing df
con_descript = df_contacts.describe()
df_contacts.info()

# col names
headers = list(df_contacts.head(0))

# EDA
# gender
sns.countplot(x = "Gender__c", data = df_contacts)

# Race
sns.countplot(x = "Race__c", data = df_contacts)

# state
df_contacts.groupby(['MailingState']).size().sort_values(ascending = False).head(20)

# Last Rank and Branch
sns.countplot(x = "Last_Rank__c", data = df_contacts[df_contacts['Last_Rank__c'] != 'not specified'])
sns.countplot(x = "Service_Branch__c", data = df_contacts[df_contacts['Last_Rank__c'] != 'not specified'])

# status
sns.countplot(x = "Status__c", data = df_contacts[df_contacts['Status__c'] != 'not specified'])

# client type
sns.countplot(x = "Client_Type__c", data = df_contacts)

# AVR
sns.countplot(x = "AVR__c", data = df_contacts)

# salary
sns.countplot(x = "Salary_Range__c", data = df_contacts)
df_contacts.groupby(['Min_Salary_Expectations__c']).size().sort_values(ascending = False)

# lead source
df_contacts.groupby(['LeadSource']).size().sort_values(ascending = False)

# education
sns.countplot(x = "Highest_Level_of_Education_Completed__c", data = df_contacts)
df_contacts.groupby(['Education_Summary__c']).size().sort_values(ascending = False).head(20)

##############
# Hired EDA #
##############

df_hire = pd.read_csv('../../data/interim/hiring.csv', encoding = "ISO-8859-1")
# col names
hire_headers = list(df_hire.head(0))

# Salary
sns.countplot(x = "Salary_Range__c", data = df_hire)

# Emp type
sns.countplot(x = "Employment_Type__c", data = df_hire)

# unemp months
sns.countplot(x = "Months_Unemployed__c", data = df_hire)

# hired and looking
df_contacts.groupby(['Hired_but_still_active_and_looking__c']).size().sort_values(ascending = False).head(20)

# hired inddustry
df_hire.groupby(['Industry_Hired_In__c']).size().sort_values(ascending = False).head(20)


##############
# Cases EDA #
##############

df_case = pd.read_csv('../../data/interim/case.csv', encoding = "ISO-8859-1")
# col names
case_headers = list(df_case.head(0))

# Volunteer
df_case.groupby(['Volunteer__c']).size().sort_values(ascending = False).head(20) # <- connector to volunteer

# requ vol assist
df_case.groupby(['Request_Volunteer_Assistance__c']).size().sort_values(ascending = False).head(20)

################
# Feedback EDA #
################

df_feed = pd.read_csv('../../data/interim/feedback.csv', encoding = "ISO-8859-1")
# col names
feed_headers = list(df_feed.head(0))

# employment satistfaction
sns.countplot(x = "Emplo__c", data = df_feed)



