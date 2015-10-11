# Exploratory Data Analysis - Course Project 1
# plot1.R - plot the first graph

# Step 1: load the data into a data frame
library(readr)

# first create a connection to the zipped data file specifying the
# item we want in the archive, namely "household_power_consumption.txt"
# Note: in this case the archive contains only one item!
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
# Note: we don't actually need to do this for the first plot but
# we will need the new variable to plot the time series in the
# next three plots!

# Step 3: produce the plot
# First save the current graphical parameters values so we can
# restore them when we are done
opar <- par()

# set the text magnification value to 0.8
par(cex = .8)

# set up the target file for the plot: a png file of size 480x480
png("plot1.png", width = 480, height = 480)

# plot the histogram
hist(hpcdata$Global_active_power,
     col = "red",                               # set bar color to red
     xlab = "Global Active Power (kilowatts)",  # set the label for the x-axis
     main = "Global Active Power")              # set the text of the title

# close the png file
dev.off()

# and restore the old graphical parameter values
par(opar)
