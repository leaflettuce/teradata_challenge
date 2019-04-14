# -*- coding: utf-8 -*-
"""
Created on Sun Apr 14 12:00:00 2019

@author: andyj
"""
import os
import pandas as pd

# setwd
os.chdir('E:/projects/teradata/src/visualize/')

# import
df = pd.read_csv('../../data/processed/team_CAC/for_network.csv', encoding = "ISO-8859-1")

df.describe()
df.index

# remove missing
df = df.dropna()

df.head()
