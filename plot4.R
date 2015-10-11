# Exploratory Data Analysis - Course Project 1
# plot4.R - plot the fourth graph

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

# set up the target file for the plot: a png file of size 480x480
png("plot4.png", width = 480, height = 480)

# set the text magnification factor to 0.75 and specify four plots
# to be drawn in row order
par(mfrow = c(2, 2), cex = .75)

# plot four line graphs in a 2x2 grid:
# in position (1,1): the graph of "Global_active_power" as a
#                    function of the observations timestamps
# in position (1,2): the graph of "Voltage" as a function
#                    of the observations timestamps
# in position (2,1): graphs of the variables "Sub_metering_1",
#                    "Sub_metering_2", and "Sub_metering_2" as
#                    functions of the observations timestamps
# in position (2,2): the graph of "Global_reactive_power" as a
#                    function of the observations timestamps
with(hpcdata, {                                   # specify the data frame to use
  plot(DateTime, Global_active_power,             # first plot: Global_active_power
       type = "l",                                # line plot
       xlab = "",                                 # blank out x-axis label
       ylab = "Global Active Power")              # set the y-axis label
  plot(DateTime, Voltage,                         # second plot: Voltage
       type = "l",                                # line plot
       xlab = "datetime")                         # set the x-axis label
  plot(DateTime, Sub_metering_1,                  # third plot: see plot3.R for details
       type = "l",
       xlab = "",
       ylab = "Energy sub metering")
  lines(DateTime, Sub_metering_2, col = "red")
  lines(DateTime, Sub_metering_3, col = "blue")
  legend("topright",                              # set the legend
         bty = "n",                               # no frame for the legend
         lty = 1,                                 # line type for legend
         col = c("black", "red", "blue"),         # color for the three items
         legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  plot(DateTime, Global_reactive_power,           # fourth plot: Global_reactive_power
       type = "l",                                # line plot
       xlab = "datetime")                         # set x-axis label
})

# close the png file
dev.off()

# and restore the old graphical parameter values
par(opar)
