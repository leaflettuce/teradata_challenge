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
df.dropna(inplace=True)
df.reset_index(drop=True, inplace=True)
df.head()

# clean up text ###########################################
#skills = df.Qualifications
#for i in range(1,len(skills)): #iterate through and replace/split out
#    try:
#        skills[i] = skills[i].lower().replace(' and', '').replace(',', ' ').split(" ")
#    except KeyError:
#        pass
###########################################################

# set skills'
skills = ['military','program','analyst','security', 'career', 'veteran', 'risk',
          'comprehensive', 'managed', 'performance', 'clearance', 'results', 'senior',
          'army', 'teams', 'secret', 'awards', 'training', 'years', 'global', 'meeting', 
          'science', 'bachelor', 'professional', 'manager', 'business', 'logistics', 'project',
          'technical', 'planning', 'service', 'information', 'fastpaced', 'maintenance', 'operational', 
          'diverse', 'airforce', 'navy', 'marines', 'stategic', 'systems', 'programming', 'cultural', 
          'certifications', 'defense', 'collaborating', 'analysis', 'steward', 'process', 'network', 
          'associate', 'tactical', 'medical', 'safety', 'organizational', 'university', 'intelligence',
          'administrative', 'data', 'medal', 'control', 'inventory', 'employees', 'private', 'bechelors', 
          'masters', 'health', 'sales', 'transportation', 'budget', 'services', 'engineering', 
          'public', 'guard', 'accountability', 'computer', 'justice', 'financial', 'developing', 
          'policy', 'maintained', 'law', 'technician', 'supervised', 'leader', 'marketing', 'worldwide',
          'officer', 'accounting', 'lean', 'sigma', 'comptai', 'repair', 'electronic', 'coordinated']

# iterate through qualifications and track skills
skills_dictionary = {}
iterative = 0
for section in df.Qualifications:
    iterative += 1
    for skill in skills:
        if skill in section.lower():
            if str(iterative) in skills_dictionary.keys():
                skills_dictionary[str(iterative)].append(skill)  
            else:
                skills_dictionary[str(iterative)] = [skill] 
                
##set base df (co-occurance matrix)
matrix = pd.DataFrame(columns = skills, index = skills)
matrix[:] = int(0)

#iterate through each client and add one for each skill-skill relationship
#-> in this case, relationship equates to appearing in the same row
for value in skills_dictionary.values():
    for skill1 in skills:
        for skill2 in skills:
            if skill1 in value and skill2 in value:
                matrix[skill1][skill2] += 1
                matrix[skill2][skill1] += 1
     

           
#add weights to edges
weight_denominator = 32
edge_list = [] #test networkx
for index, row in matrix.iterrows():
    i = 0
    for col in row:
        weight = float(col)/weight_denominator
        edge_list.append((index, matrix.columns[i], weight))
        i += 1

#Remove edge if 0.0
updated_edge_list = [x for x in edge_list if not x[2] == 0.0]


#create duple of char, occurance in novel
node_list = []
for i in skills:
    for e in updated_edge_list:
        if i == e[0] and i == e[1]:
           node_list.append((i, e[2]*6))
for i in node_list:
    if i[1] == 0.0:
        node_list.remove(i)
        
#remove self references
for i in updated_edge_list:
    if i[0] == i[1]:
        updated_edge_list.remove(i)
        
        
###############                         AESTETICS
    #############
        #############    
            #############
        #########
    ##########
###############
    
    
#set canvas size
plt.subplots(figsize=(12.5,12.5))

#networkx graph time!
G = nx.Graph()
for i in sorted(node_list):
    G.add_node(i[0], size = i[1])
G.add_weighted_edges_from(updated_edge_list)

#check data of graphs
#G.nodes(data=True)
#G.edges(data = True)

#manually copy and pasted the node order using 'nx.nodes(G)'
#Couldn't determine another route to listing out the order of nodes for future work
node_order = ['leader', 'medal', 'administrative', 'programming', 'electronic', 'employees', 
              'private', 'transportation', 'teams', 'risk', 'information', 'officer', 'defense', 
              'business', 'collaborating', 'planning', 'services', 'army', 'guard', 'accountability', 
              'results', 'clearance', 'military', 'bachelor', 'senior', 'technical', 'analysis', 
              'medical', 'certifications', 'veteran', 'training', 'budget', 'computer', 'developing', 
              'lean', 'inventory', 'career', 'intelligence', 'navy', 'coordinated', 'systems', 'safety', 
              'operational', 'comprehensive', 'worldwide', 'science', 'public', 'steward', 'global', 
              'sigma', 'tactical', 'control', 'meeting', 'program', 'maintained', 'associate', 'financial', 
              'managed', 'engineering', 'maintenance', 'fastpaced', 'technician', 'supervised', 'manager', 
              'secret', 'performance', 'marketing', 'security', 'policy', 'diverse', 'health', 'cultural', 
              'organizational', 'service', 'analyst', 'airforce', 'repair', 'marines', 'university', 'awards', 
              'process', 'data', 'masters', 'project', 'years', 'professional', 'network', 'justice', 'sales', 
              'law', 'logistics', 'accounting']
             

#reorder node list
updated_node_order = []
for i in node_order:
    for x in node_list:
        if x[0] == i:
            updated_node_order.append(x)
            
#reorder edge list - this was a pain
test = nx.get_edge_attributes(G, 'weight')
updated_again_edges = []
for i in nx.edges(G):
    for x in test.keys():
        if i[0] == x[0] and i[1] == x[1]:
            updated_again_edges.append(test[x])
            
#drawing custimization
node_scalar = .06
edge_scalar = .00032
sizes = [x[1]*node_scalar for x in updated_node_order]
widths = [x*edge_scalar for x in updated_again_edges]

#draw the graph
pos = nx.spring_layout(G, k=15, iterations=22)

nx.draw(G, pos, with_labels=True, font_size = 9, font_weight='bold', edge_color='grey',
        node_size = sizes, width = widths, node_color= '#6592B2')

plt.axis('off')
plt.savefig("hired_network_6.png") # save as png