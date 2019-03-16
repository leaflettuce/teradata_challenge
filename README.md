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
TEAM CAC (*possibly changing -  need team feedback)
- Is there anything in the client's demographic profile that indicates that a client is more likely to become a confirmed 
  hire or any other outcome?
- What can we prove - quantitatively - that our volunteers are increasing the overall effectiveness of our program?

TEAM MAT
- What is the average amount in days that a military spouse spends in the HHUSA program?
- Is there a correlation between education level and the black rate for military spouses.
```

## Overall Process
 
```
1 - Import Data
2 - Clean and process 
3 - EDA FTW
5 - Find solutions to HH business problems
6 - Create visuals
7 - Format into a presentation.
```

## Loading Data
```
(1) Upload Hire Heroes supplied datasets into /data/raw/ 
	|--> requires teradata challenge credentials to source data
	|--> manually download all files from challenge dataset page
	|--> save all csv's directly in this dir, no further pathing

(2) RUN src/process/process_data.bat
	|--> Give time to run. Will take up to 15 minutes.
	|--> Still in test.
```