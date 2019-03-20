# -*- coding: utf-8 -*-
"""
Created on Wed Mar 20 15:27:10 2019

@author: andyj
"""
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os 

########################
# contacts epxloration #
########################

# setwd
os.chdir('E:/projects/teradata/src/explore')
# import
df = pd.read_csv('../../data/processed/team_CAC/contact_hire_CAC.csv', encoding = "ISO-8859-1")

# detailing df
con_descript = df.describe() 
df.info()

# col names
headers = list(df.head(0))

# remove outliers
df = df[(df['Days_in_Program'] < 400) & (df['Days_in_Program'] >= 0)]

# check numeric correlations to dyas in program
numeric_cols = ['Number_of_dependents__c', 'Min_Salary_Expectations__c', 'Salary_annual_expected', 
                'Salary_hourly_expected', 'Age', 'Days_in_Program']
df_num = df[numeric_cols]

df_num_corr = df_num.corr()
sns.heatmap(df_num_corr,
            xticklabels=df_num_corr.columns,
            yticklabels=df_num_corr.columns)

sns.scatterplot(x = 'Age', y = 'Days_in_Program', data = df)

sns.scatterplot(x = 'Min_Salary_Expectations__c', y = 'Days_in_Program', data = df)

sns.scatterplot(x = 'Min_Salary_Expectations__c', y = 'Days_in_Program', hue = 'Gender__c', data = df)


# RACE AND GENDER
sns.countplot(x = 'Race__c', data = df)
sns.boxplot(x = 'Gender__c', y = 'Days_in_Program', data = df)
sns.barplot(x = 'Race__c', y = 'Days_in_Program', data = df)
# THIS
sns.violinplot(x = 'Race__c', y = 'Days_in_Program', hue = 'Gender__c', data = df, 
               palette = 'muted', split = True, scale = 'count', inner = 'quartile')