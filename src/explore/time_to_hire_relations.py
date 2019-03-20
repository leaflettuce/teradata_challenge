# -*- coding: utf-8 -*-
"""
Created on Wed Mar 20 15:27:10 2019

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
df_contacts = pd.read_csv('../../data/processed/team_CAC/contact_hire_CAC.csv', encoding = "ISO-8859-1")

# detailing df
con_descript = df_contacts.describe() 
df_contacts.info()

# col names
headers = list(df_contacts.head(0))
