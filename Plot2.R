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
png(filename='plot2.png')

# Make plot
plot(df$date.time, df$Global_active_power, ylab='Global Active Power (kilowatts)', xlab='', type='l')

# Turn off device
dev.off()
#-------------------------------------------------------------------------------#

