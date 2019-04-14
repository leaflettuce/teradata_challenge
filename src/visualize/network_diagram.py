# -*- coding: utf-8 -*-
"""
Created on Sun Apr 14 12:00:00 2019

@author: andyj
"""
import os
import pandas as pd
import networkx as nx
import matplotlib.pyplot as plt

# setwd
os.chdir('E:/projects/teradata/src/visualize/')

# import
df = pd.read_csv('../../data/processed/team_CAC/for_network.csv', encoding = "ISO-8859-1")

df.describe()
df.index

# remove missing
df = df.dropna()
df.head()

# clean up text
skills = df.Qualifications
for i in range(1,len(skills)): #iterate through and replace/split out
    try:
        skills[i] = skills[i].lower().replace(' and', '').replace(',', ' ').split(" ")
    except KeyError:
        pass



# iterate through qualifications and track words
skills_list = {}
for section in df.Qualifications:
    
    for char in characters:
        if char in section:
            if str(iterative) in sections_dictionary.keys():
                sections_dictionary[str(iterative)].append(char)  
            else:
sections_dictionary[str(iterative)] = [char] 