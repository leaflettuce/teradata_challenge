# -*- coding: utf-8 -*-
"""
Created on Sun Mar 17 13:18:43 2019

@author: andyj
"""

import pandas as pd
import matplotlib as plt
import seaborn as sns

########################
# contacts epxloration #
########################

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

# Last Rank
sns.countplot(x = "Last_Rank__c", data = df_contacts[df_contacts['Last_Rank__c'] != 'not specified'])