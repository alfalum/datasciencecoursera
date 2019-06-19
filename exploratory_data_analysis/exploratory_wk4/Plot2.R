Baltimore <- subset(NEI, fips == "24510")
totalEmissions <- tapply(Baltimore$Emissions, Baltimore$year, sum)
p2 <- barplot(totalEmissions, xlab = "Year", ylab = "Total Emission (ton)", 
              main = "Total Emission per year in Baltimore")
