# Exploratory Data Analysis - Course Project 1
# plot3.R - plot the third graph

# Step 1: load the data into a data frame
library(readr)

# first create a connection to the zipped data file specifying the
# item we want in the archive, namely "household_power_consumption.txt"
hpc <- unz("exdata_data_household_power_consumption.zip",
           filename = "household_power_consumption.txt")

# and read in the content of the file into a data frame using the
# read_delim function from the "readr" package
# Note: the record separator is a semicolon and missing values
# are marked by a question mark
hpcdata  <-  read_delim(hpc, delim = ";", na = "?")

# Finally subset the data to the "1/2/2007" and "2/2/2007" dates
hpcdata <-  hpcdata[hpcdata$Date %in% c("1/2/2007", "2/2/2007"),]

# Step 2: create a new variable to hold the timestamp of each observation
hpcdata["DateTime"] = NA
# and populate it with POSIX timestamps computed from the Date and
# Time variables of the data frame
hpcdata$DateTime = strptime(paste(hpcdata$Date, hpcdata$Time, sep = ' '),
                            format = "%d/%m/%Y %H:%M:%S")

# Step 3: produce the plot
# First save the current graphical parameters values so we can
# restore them when we are done
opar <- par()

# set the text magnification value to 0.8
par(cex = .8)

# set up the target file for the plot: a png file of size 480x480
png("plot3.png", width = 480, height = 480)

# plot line graphs of the variables "Sub_metering_1", "Sub_metering_2",
# and "Sub_metering_2" as functions of the observations timestamps
with(hpcdata, {                                   # specify the data frame to use
  plot(DateTime, Sub_metering_1,                  # line plot of Sub_metering_1 as a
       type = "l",                                # function of the observations timestamps
       xlab = "",                                 # blank out the x-axis label
       ylab = "Energy sub metering")              # set the y-axis label
  lines(DateTime, Sub_metering_2, col = "red")    # add line graph of Sub_metering_2 in red
  lines(DateTime, Sub_metering_3, col = "blue")   # add line graph of Sub_metering_3 in blue
  legend("topright",                              # set the legend in the upper right corner
         lty = 1,                                 # the line type for the legend
         col = c("black", "red", "blue"),         # the colors for the three legend items
         legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")) # the text of the legend
})

# close the png file
dev.off()

# and restore the old graphical parameter values
par(opar)
