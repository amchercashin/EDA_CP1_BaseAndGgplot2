
#Create dir and download file
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