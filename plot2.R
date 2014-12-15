library(dplyr)

#Create dir and download file unless alrwady done
if (!file.exists("./data")) {dir.create("./data")}
if (!file.exists("./data/NEIdata.zip")) {download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
                                                       , "./data/NEIdata.zip", mode = "wb")}
#Unzip unless already done
if (!file.exists("./data/summarySCC_PM25.rds")) {unzip("./data/NEIdata.zip", 
                                                       files = "summarySCC_PM25.rds",
                                                       exdir = "./data")}
if (!file.exists("./data/Source_Classification_Code.rds")) {unzip("./data/NEIdata.zip", 
                                                                  files = "Source_Classification_Code.rds",
                                                                  exdir = "./data")}                                                 

#Read data
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

#Aggregte emissions in Baltimore City
totalBal <- filter(NEI, fips == "24510") %>% group_by(year) %>% summarise(emissions = sum(Emissions))

#Plot
png("plot2.png")
plot(totalBal$year, totalBal$emissions/1000, ann=F)
title(main = expression("Total PM"[2.5]~" emissions over 1999-2008 in Baltimore City, Maryland"),
      xlab = "Year",
      ylab = "Thousands of tons"
)
#Add linear approximation for the clear answer
abline(lm(emissions/1000 ~ year, data = totalBal), col = "blue")
dev.off()