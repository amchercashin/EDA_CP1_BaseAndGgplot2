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

#Join SCC descriptions with NEI
NEI_SCC <- inner_join(NEI, SCC, by="SCC")
#Filtering only those from motor sources
NEI_SCC <- filter(NEI_SCC, grepl("[Mm]otor",NEI_SCC$SCC.Level.Three))
#And from Baltimore or Los Angeles
NEI_SCC <- filter(NEI_SCC, fips == "24510" | fips == "06037")
# Summarise by year adn level 3 descriptions to draw motor vehicle fires separately
NEI_SCC <- group_by(NEI_SCC, year, fips, SCC.Level.Three) %>% summarise(emissions = sum(Emissions))

NEI_SCC$fips <- factor(NEI_SCC$fips, levels = c("06037", "24510"), labels = c("Los Angeles", "Baltimore"))


#Plot
png("plot6.png", 800, 600)

p <- ggplot(data = NEI_SCC, aes(x = year, y = emissions, colour = SCC.Level.Three)) +
  facet_grid(. ~ fips) +
  geom_point() +
  xlab("Year") +
  ylab("Tons") +
  scale_colour_discrete(name="Source type", 
                        breaks = c("Motor Vehicle Fires", "Motorcycles (MC)"),
                        labels = c("Motor vehicle fires", "Motor vehicles")) +
  ggtitle(expression("PM"[2.5]~" motor vehicle related emissions over 1999-2008")) +
  geom_smooth(method="lm", se=F)
print(p)
dev.off()