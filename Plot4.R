setwd("/Users/oaks/Documents/Home/Workspaces/Coursera/EDA/Project1/CourseProject1")
##------------------------------------------------------------------------------------------------------##
library(sqldf)
##------------------------------------------------------------------------------------------------------##
# Download the zip file and get the files in the required directory
##------------------------------------------------------------------------------------------------------##

if(!(file.exists("household_power_consumption.txt"))) {
  fileUrl <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  if (!file.exists("download")) {
    dir.create("download")
  }
  download.file(fileUrl, destfile="download/pconsumption.zip", method="curl")
  unzip("download/pconsumption.zip", exdir="./")
}

#read the data in specific to the dates in the assignment
df <- read.csv2.sql(file="household_power_consumption.txt", 
                    sql = "select * from file where Date in('1/2/2007', '2/2/2007')",
                    sep=';', header =TRUE,row.names=NULL, na.strings='?')
closeAllConnections()

df$Date <- dmy(df$Date)
df$Time <- hms(df$Time)
df$date.time <- df$Date + df$Time
df$Global_active_power <- as.numeric(df$Global_active_power)
#-------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------#
# Open device
png(filename='plot4.png')

## Make 4 quadrants, two rows n two columns
par(mfrow=c(2,2))

# 0,0
plot(df$date.time, df$Global_active_power,ylab='Global Active Power', xlab='', type='l')

# 0,1
plot(df$date.time, df$Voltage,xlab='datetime', ylab='Voltage', type='l')

# 1,0
plot(df$date.time, df$Sub_metering_1, type='l',xlab='', ylab='Energy sub metering')
lines(df$date.time, df$Sub_metering_2, col='red')
lines(df$date.time, df$Sub_metering_3, col='blue')
legend('topright',  legend=c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'),col=c('black', 'red', 'blue'),  lty='solid', bty='n')

# 1,1
plot(df$date.time, df$Global_reactive_power,xlab='datetime', ylab='Global_reactive_power', type='l')

# Turn off device
dev.off()
#-------------------------------------------------------------------------------#

