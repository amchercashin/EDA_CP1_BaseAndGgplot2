library(dplyr)
library(ggplot2)

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

#Find SCC values related for combustion and coal
combustCoalSCC <- filter(SCC, grepl("[Cc]omb", SCC$SCC.Level.One) & grepl("[Cc]oal", SCC$SCC.Level.Three))
combustCoalSCC <- as.character(unique(combustCoalSCC$SCC))

#Aggregte emissions in Baltimore City by year and type
combustCoal <- filter(NEI, SCC %in% combustCoalSCC) %>% group_by(year) %>% summarise(emissions = sum(Emissions))

#Plot
png("plot4.png", 480, 480)

p <- qplot(year, emissions/1000, data = combustCoal) +
  xlab("Year") +
  ylab("Thousands of tons") +
  ggtitle(expression("Total PM"[2.5]~" coal combustion-related emissions over 1999-2008")) +
  geom_smooth(method="lm", se=F)
print(p)
dev.off()