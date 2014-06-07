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

# plot2 - opening png graphics device, setting up the plot, and closing the png graphics device
# overriding OS locale settings in R by temporary setting them to "C" (North_American usage) 
lcTime <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME", "C")
# default values for png(): width = 480, height = 480, units = "px"
png(filename = "plot2.png")
with(consumptionData, {
    plot(DateTime, Global_active_power, type = "n", ylab = "Global Active Power (kilowatts)", xlab = "")
    # default values for lines(): type = "l" for lines, col = "black"
    lines(DateTime, Global_active_power)
})
# "housekeeping"
dev.off()
Sys.setlocale("LC_TIME", lcTime)