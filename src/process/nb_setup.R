library(reshape)

setwd('E:/projects/teradata/src/process/')
df <- read.csv('../../data/processed/team_CAC/demo2.csv')

# remove na
df <- df[rowSums(is.na(df)) == 0,]

# reshape into binary matrix
