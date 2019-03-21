##################################
# Create Service Era Var         #
# Substitute df name as needed   #
##################################


for (i in 1:nrow(df_topic_edit1)){
	x <- as.character(df_topic_edit1[i,'Date_of_SeparationNew__c'])
	if (is.na(x)){
		df_topic_edit1[i,'Most_Recent_Service_ERA']<- 'NA'
	}
	else if(x < ymd("1917-4-5")){
		df_topic_edit1[i,'Most_Recent_Service_ERA']<- 'Mexican Border Period'
	}
	else if (x < ymd("1918-11-11")){
		df_topic_edit1[i,'Most_Recent_Service_ERA']<- 'World War I'
	}
	else if (x < ymd("1946-12-31")){
		df_topic_edit1[i,'Most_Recent_Service_ERA']<- 'World War II'
	}
	else if (x < ymd("1955-1-31")){
		df_topic_edit1[i,'Most_Recent_Service_ERA']<- 'Korean Conflict'
	}
	else if (x < ymd("1975-5-7")){
		df_topic_edit1[i,'Most_Recent_Service_ERA']<- 'Vietnam era'
	}
	else if (x < ymd(today())){
		df_topic_edit1[i,'Most_Recent_Service_ERA']<- 'Gulf War'
	}	
	else {
		df_topic_edit1[i,'Most_Recent_Service_ERA']<- 'Currently Enlisted'
	}
}

df_topic_edit1$Most_Recent_Service_ERA <- as.factor(unlist(df_topic_edit1$Most_Recent_Service_ERA))

