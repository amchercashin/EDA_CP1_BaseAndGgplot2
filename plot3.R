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

#Aggregte emissions in Baltimore City by year and type
byTypeBal <- filter(NEI, fips == "24510") %>% group_by(year, type) %>% summarise(emissions = sum(Emissions))

#Plot
png("plot3.png", 960, 480)

p <- qplot(year, emissions, data = byTypeBal, facets = . ~ type) +
      xlab("Year") +
      ylab("Tons") +
      ggtitle(expression("Total PM"[2.5]~" emissions over 1999-2008 in Baltimore City, Maryland by type")) +
      geom_smooth(method="lm", se=F)
print(p)
dev.off()