#load library(s)
library(dplyr)
library(data.table)
library(lubridate)

# Getting zipped data
zipurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(!file.exists("./project")){
  dir.create("./project")
}
destFile <- "./project/powerconsumption.zip"
sourceFile = file.path("./project", "household_power_consumption.txt")

#download
download.file(zipurl,destFile)

#unzip
unzip(zipfile=destFile,exdir="./project")

list.files("./project")
consumption <- fread(sourceFile,sep = ";",na.strings = c("?"))

#convert date and global power to date and numerc values
consumption$Date <- as.Date(strptime(consumption$Date, format = "%d/%m/%Y"))


#subset data
consumption <- subset(consumption, Date >= ymd("2007-02-01") & Date <= ymd("2007-02-02"))

#plot line graphs for Sub metering
with(consumption,{
  plot(with(consumption, ymd(Date) + hms(Time)),Sub_metering_1, type = "l", ylab= "Energy sub metering",xlab= "",col = "black")
  points(with(consumption, ymd(Date) + hms(Time)),Sub_metering_2, type = "l",col = "red")
  points(with(consumption, ymd(Date) + hms(Time)),Sub_metering_3, type = "l",col = "blue")
})
legend("topright",lty =c(1,1,1), col=c("black", "blue","red"),legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))


#copy as PNG
dev.copy(png,file.path("./project","plot3.png"), width = 480, height =480)
dev.off()