# 2019 Teradata Challenge
Competing in the 2019 TUN data challenge by solving business problems for Hire Heroes USA. Conducted as part of SNHU hosted team.

## Goals
```
TUN data challenge for 2019 has provided teams with data from Hire Heroes USA. Each team taking part in the challenge is to
focus on answering one or two business questions proposed by the non-profit. Cleaning, analysis, and visualization will all
be necessary components to succeed in this goal.
```

## Business Questions
```
TEAM CAC (Data Snhupers)
- Is there anything in the client's demographic profile that indicates that a client is more likely to become a confirmed 
  hire or any other outcome?
- What can we prove - quantitatively - that our volunteers are increasing the overall effectiveness of our program?

TEAM MAT
- What is the average amount in days that a military spouse spends in the HHUSA program?
- Is there a correlation between education level and the black rate for military spouses.
```

## Overall Process
 
```
1 - [X] Import Data
2 - [X] Clean and process 
3 - [X] EDA FTW
5 - [X] Find solutions to HH business problems
6 - [X] Create visuals
7 - [X] Format into a presentation.
```

## Loading Data
```
(1) Upload Hire Heroes supplied datasets into /data/raw/ 
	|--> requires teradata challenge credentials to source data
	|--> manually download all files from challenge dataset page
	|--> save all csv's directly in this dir, no further pathing

(2) RUN /src/process/process_data.bat
	|--> Give time to run. Will take up to 15 minutes.
	|--> Cleaned files will write to /data/interim/

(3) RUN /src.process/create_era.bat
	|--> Give time to run. Can take up to 20 minutes.
	|--> Only run if you need this variable for analysis.
```

## Results
 
```

o - Identified inequalities among demographics within HH USA hiring success rates.
o - Identified differences between time in program based on client type and demographics.
o - Highlighted challenges which HH USA faces within their program.
o - Quantified benefits and effectiveness of Volunteer Services to HH USA program.
o - Performed Qualification Keyword Analysis to suggest words to include within client resumes.
o - Leveraged State Job Growth and Unemployment Rates data to suggest a path to increasing success of program.
o - Created Logistic Regression successfully classifying clients as successful or not at 70% accuracy.
o - Standardized co-efficients of this model to identify most important factors contributing to client success. 
o - Formed final PP presentation to convey these findings in an interesting and informative manner.
```
