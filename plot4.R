# setting up temp directory and temp file as a placeholder for file download
tempDir <- tempdir()
tempFile <- tempfile(tmpdir = tempDir, fileext = ".zip")
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, tempFile)

# extracting name of file inside zip archive; unzipping the contents of zip archive
fileName <- unzip(tempFile, list = T)$Name[1]
unzip(tempFile, files = fileName, exdir = tempDir, overwrite = T, unzip = "unzip")
filePath <- file.path(tempDir, fileName)

# extracting data only for 1/2/2007 and 2/2/2007, and saving it in cleanSet.txt
# reading contents of cleanSet.txt into data frame consumptionData
cat(grep("(^Date)|(^[1|2]/2/2007)", readLines(filePath), value = T), sep = "\n", file = "cleanSet.txt")
consumptionData <- read.table("cleanSet.txt", header = T, sep = ";", row.names = NULL, stringsAsFactors = F)

# cleaning temp directory and temp file; removing all variables used in data acquirement process
unlink(tempDir)
unlink(tempFile)
rm(fileUrl)
rm(fileName)
rm(filePath)
rm(tempDir)
rm(tempFile)

# appending variable DateTime necessary for correct graph implementations to consumptionData
consumptionData$DateTime <- strptime(paste(consumptionData$Date, consumptionData$Time), format = "%d/%m/%Y %H:%M:%S")

# plot4 - opening png graphics device, setting up the plot, and closing the png graphics device
# overriding OS locale settings in R by temporary setting them to "C" (North_American usage) 
lcTime <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME", "C")
# default values for png(): width = 480, height = 480, units = "px"
png(filename = "plot4.png")
# saving current state of graphical parameters saved in par(); adjusting mfrow for mulitple graphs (row-wise fill)
opar <- par()
par(mfrow = c(2, 2))
# mini plot 1 (upper-left)
with(consumptionData, {
    plot(DateTime, Global_active_power, type = "n", ylab = "Global Active Power", xlab = "")
    # default values for lines(): type = "l" for lines, col = "black"
    lines(DateTime, Global_active_power)
})
# mini plot 2 (upper-right)
with(consumptionData, {
    plot(DateTime, Voltage, type = "n", ylab = "Voltage", xlab = "datetime")
    # default values for lines(): type = "l" for lines, col = "black"
    lines(DateTime, Voltage)
})
# mini plot 3 (lower-left)
with(consumptionData, {
    plot(DateTime, Sub_metering_1, type = "n", ylab = "Energy sub metering", xlab = "")
    # default values for lines(): type = "l" for lines, col = "black"
    lines(DateTime, Sub_metering_1)
    lines(DateTime, Sub_metering_2, col = "red")
    lines(DateTime, Sub_metering_3, col = "blue")
    # parameter bty deals with legend box border
    legend("topright", lty = c(1, 1, 1), col = c("black", "red", "blue"), 
           legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n")
})
# mini plot 4 (lower-right)
with(consumptionData, {
    plot(DateTime, Global_reactive_power, type = "n", ylab = "Global_reactive_power", xlab = "datetime")
    # default values for lines(): type = "l" for lines, col = "black"
    lines(DateTime, Global_reactive_power)
})
# "housekeeping"
dev.off()
par(opar)
Sys.setlocale("LC_TIME")