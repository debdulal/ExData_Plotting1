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


par(mfrow = c(2,2))

#Graph1
#Global_active_power and datetime
with(consumption,plot(with(consumption, ymd(Date) + hms(Time)),Global_active_power, type = "l",ylab= "Global Active Power (kilowatts)",xlab= ""))

#Graph2
#Voltage and date time
with(consumption,plot(with(consumption, ymd(Date) + hms(Time)),Voltage, type = "l",ylab= "Voltage",xlab= "datetime"))

#Graph3
#plot line graphs for Sub metering
with(consumption,{
  plot(with(consumption, ymd(Date) + hms(Time)),Sub_metering_1, type = "l", ylab= "Energy sub metering",xlab= "",col = "black")
  points(with(consumption, ymd(Date) + hms(Time)),Sub_metering_2, type = "l",col = "red")
  points(with(consumption, ymd(Date) + hms(Time)),Sub_metering_3, type = "l",col = "blue")
})
legend("topright",inset=.02,lty =c(1,1,1), col=c("black", "blue","red"),legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),box.lty=0,cex=0.6)

#graph 4
#Global_reactive_power and datetime
with(consumption,plot(with(consumption, ymd(Date) + hms(Time)),Global_reactive_power, type = "l",ylab= "Global_reactive_power",xlab= "datetime"))

#copy as PNG
dev.copy(png,file.path("./project","plot4.png"), width = 480, height =480)
dev.off()
par(mfrow = c(1,1))