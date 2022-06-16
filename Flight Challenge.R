## Activity 6

#Look at summary of all columns in the dataset
summary(Flight_Challenge_Results_dataset)

# Explore ArrDelay Data
summary(Flight_Challenge_Results_dataset$ArrDelay)
sd(Flight_Challenge_Results_dataset$ArrDelay)

# ArrDelay Summary result
# Min = -94 Mean = 6.567 SD = 38.44812 Max = 1845

## Activity 7

# load ggplot and gridExtra for plotting
library("ggplot2")
library("gridExtra")
install.packages("ggplot2")
install.packages("gridExtra")

# Determine range values for ArrDelay
range(Flight_Challenge_Results_dataset$ArrDelay)

# Set plot properties and Plot Histogram with Box Plot
options(repr.plot.width = 6, repr.plot.height = 3)

# Calculate binwidth for histogram
rg = range(Flight_Challenge_Results_dataset['ArrDelay'])
rg

# Each Bin is seperated by a value of 64.63333
bw = (rg[2] - rg[1])/30
bw

# Plot Histogram
p1 = ggplot(Flight_Challenge_Results_dataset, aes(ArrDelay)) +
            geom_histogram(bins = 30, fill = "blue") +
            labs(x = "ArrDelay", y = "Count of Flights", title = "Histogram of ArrDelay") +
            theme_bw()

p1

# Plot boxplot
p2 = ggplot(Flight_Challenge_Results_dataset, aes(x = factor(0), y = ArrDelay)) +
           geom_boxplot(color = "blue") +
           ggtitle("Boxplot of ArrDelay1") +
           theme_bw()
p2
# Arrange the Histogram and Box plot on same row
grid.arrange(p1,p2,nrow=1)


## Activity 8: Histograms to compare Numeric Columns

# Create function to plot conditioned histograms
# ggplot2 and gridExtra have been loaded and installed. Plot have been set to appropiate width and height

arrdel15.hist = function(x){
              library(ggplot2)
              library(gridExtra)
              options(repr.plot.width=6, repr.plot.height=3)
              title = paste("Histogram of", x, "conditioned on ArrDel15")
              ## Create the histogram
              ggplot(Flight_Challenge_Results_dataset, aes_string(x)) +
              geom_histogram(aes(y = ..count..), bins = 30, fill = "red") +
              facet_grid(. ~ ArrDel15) +
              ggtitle(title) +
              ylab("Count of ArrDelay") +
              theme_bw()
}

## Create histograms for specified features.
plot.cols2 = c("DepDelay",
               "CRSArrTime",
               "CRSDepTime",
               "DayofMonth",
               "DayOfWeek",
               "Month")

lapply(plot.cols2, arrdel15.hist)


## Activity 9: Use Scatter Plots to Compare Numeric Columns
# Scatter plot using color to differentiate points

scatter_flights = function(x){
                library(ggplot2)
                library(gridExtra)
                options(repr.plot.width = 6, repr.plot.height = 3)
                title = paste("ArrDelay vs.", x, "with color by ArrDel15")
                ggplot(Flight_Challenge_Results_dataset, aes_string(x, 'ArrDelay')) +
                  geom_point(aes(color = factor(ArrDel15))) +
                  ggtitle(title) +
                  theme_bw()
}

# Define columns for scatter plot

plot.col3 = c("DepDelay",
              "CRSArrTime",
              "CRSDepTime",
              "DayofMonth",
              "DayOfWeek",
              "Month")

lapply(plot.col3, scatter_flights)
