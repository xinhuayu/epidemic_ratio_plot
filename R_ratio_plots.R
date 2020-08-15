# R codes to demonstrate the ratio plot
# Original paper:
# Assessing Epidemic Trends in Real Time with a Simple Ratio Plot, AJE, 2020 

library(RCurl)
library(data.table)
library(ggplot2)

# read COVID-19 data by US counties from new york times
datalink <- getURL("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv")
uscounty <- data.table(read.csv(text=datalink))
str(uscounty)
# order by date
#every five days
nycdata5 <- uscounty[tolower(county)=="new york city",][,casedate:=as.Date(date)][order(casedate),]
setkeyv(nycdata5,c("casedate"))
nycdata5[,newcases:=cases-shift(cases)][,mean5 :=frollmean(newcases,5)][,fivedayratio :=mean5/shift(mean5)] 
head(nycdata5,20)
#remove the first six NA obs
nycdata5<-nycdata5[-(1:6),]

ggplot(nycdata5,aes(casedate,fivedayratio)) + geom_line() + geom_hline(yintercept=1) + 
labs(x = "Date",y="Ratio of 5 Day Change in New Cases") + scale_x_date(date_breaks="2 week",date_labels = "%b %d") +
theme(panel.grid.minor = element_blank(),panel.background = element_blank(),axis.line = element_line(colour = "black")) 

# seven day ratio
nycdata7 <- uscounty[tolower(county)=="new york city",][,casedate:=as.Date(date)][order(casedate),]
setkeyv(nycdata5,c("casedate"))
nycdata7[,newcases:=cases-shift(cases)][,mean7 :=frollmean(newcases,7)][,sevendayratio :=mean7/shift(mean7)] 
head(nycdata7,20)
#remove the first eight NA obs
nycdata7<-nycdata7[-(1:8),]

ggplot(nycdata7,aes(casedate,sevendayratio)) + geom_line() + geom_hline(yintercept=1) +
labs(x = "Date",y="Ratio of 7 Day Change in New Cases") + scale_x_date(date_breaks="2 week",date_labels = "%b %d") +
  theme(panel.grid.minor = element_blank(),panel.background = element_blank(),axis.line = element_line(colour = "black")) 

