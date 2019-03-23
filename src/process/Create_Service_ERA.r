##################################
# Create Service Era Var         #
# Substitute df name as needed   #
##################################
library(lubridate)

setwd('E:/projects/teradata/src/process/')
df_topic_edit1 <- read.csv('../../data/processed/team_CAC/contact_hire_CAC.csv')
# df_topic_edit1$Most_Recent_Service_ERA <- ''

#function to check for date and apply era
add_era <- function(x) {
	  x <- ymd(as.character(x))
	if (is.na(x)){
		'NA'
	}
	else if(x < ymd("1917-4-5")){
	'Mexican Border Period'
	}
	else if (x < ymd("1918-11-11")){
		'World War I'
	}
	else if (x < ymd("1946-12-31")){
		'World War II'
	}
	else if (x < ymd("1955-1-31")){
		'Korean Conflict'
	}
	else if (x < ymd("1975-5-7")){
		'Vietnam era'
	}
	else if (x < ymd(today())){
		'Gulf War'
	}	
	else {
		'Currently Enlisted'
	}
}

# apply function and unlist
df_topic_edit1$Most_Recent_Service_ERA <- lapply(df_topic_edit1$Date_of_SeparationNew__c, add_era)
df_topic_edit1$Most_Recent_Service_ERA <- as.factor(unlist(df_topic_edit1$Most_Recent_Service_ERA))

# write it out
write.csv(df_topic_edit1, file = "../../data/processed/df_cac_w_service_era.csv", row.names = FALSE)

