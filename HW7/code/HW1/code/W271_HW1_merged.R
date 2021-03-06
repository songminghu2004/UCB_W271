## MIDS W271-4 HW1            ##
## Carin, Davis, Levato, Song ##


## @knitr Libraries
# LIBRARIES AND CONSTANTS -------------------------------------------------
# Load libraries
# Define constants used in multiple chunks
library(ggplot2)
# library(knitr)
# library(plot3D)
# num_sim <- 100e3 # number of simulations



## @knitr Question1
# QUESTION 1 --------------------------------------------------------------
# Load the birthweight dataset
load("birthweight_w271.rdata")



## @knitr Question2
# QUESTION 2 --------------------------------------------------------------
# Examine the basic structure of the data set using desc, str, and summary
desc
str(data)
summary(data)



## @knitr Question3-1
# QUESTION 3 --------------------------------------------------------------
# Summarize the variable bwght: summary(data$bwght)
summary(data$bwght)

## @knitr Question3-2
# List the following quantiles: 1%, 5%, 10%, 25%, 50%, 75%, 90%, 95%, 99%**
quantile(data$bwght, probs = c(1, 5, 10, 25, 50, 75, 90, 95, 99)/100)

## @knitr Question3-3-1
# Plot the histogram of bwght and comment on the shape of its distribution
# Use hist and bin width = 5
bin_width = 5
hist(data$bwght, breaks = seq(floor(min(data$bwght)/bin_width)*bin_width, 
                              ceiling(max(data$bwght)/bin_width)*bin_width, 
                              by = bin_width), 
     xlab = "Birth weight (ounces)", ylab = "Count", 
     main = "Histogram of birth weight")

## @knitr Question3-3-2
# Use ggplot and bin width = 5
ggplot(data = data, aes(bwght)) + 
  geom_histogram(colour = 'black', fill = 'white', 
                 binwidth = bin_width) +  
  labs(x = "Birth weight (ounces)", y = "Count", 
       title = "Histogram of birth weight")

# With density plot
# ggplot(data = data, aes(bwght)) + 
#   geom_histogram(aes(y = ..density..), colour = 'black', fill = 'white', 
#                  binwidth = bin_width) +  
#   labs(x = "Birth weight (ounces)", y = "Density", 
#        title = "Histogram of birth weight") + 
#   stat_function(fun = dnorm, args = list(mean = mean(data$bwght, 
#                                                      na.rm = TRUE), 
#                                          sd = sd(data$bwght, na.rm = TRUE)), 
#                 colour = 'black', size = 1)

## @knitr Question3-3-3
# Use ggplot and bin width = 10
bin_width = 10
ggplot(data = data, aes(bwght)) + 
  geom_histogram(colour = 'black', fill = 'white', 
                 binwidth = bin_width) +  
  labs(x = "Birth weight (ounces)", y = "Count", 
       title = "Histogram of birth weight")

## @knitr Question3-3-4
# Use ggplot and bin width = 20
bin_width = 20
ggplot(data = data, aes(bwght)) + 
  geom_histogram(colour = 'black', fill = 'white', 
                 binwidth = bin_width) +  
  labs(x = "Birth weight (ounces)", y = "Count", 
       title = "Histogram of birth weight")



## @knitr Question4-1
# QUESTION 4 --------------------------------------------------------------
# Summarize the variable cigs: summary(data$cigs)
summary(data$cigs)

## @knitr Question4-2
# List the following quantiles: 1%, 5%, 10%, 25%, 50%, 75%, 90%, 95%, 99%**
quantile(data$cigs, probs = c(1, 5, 10, 25, 50, 75, 90, 95, 99)/100)

## @knitr Question4-3-1
# Plot the histogram of bwght and comment on the shape of its distribution
# Use hist and bin width = 1
bin_width = 1
hist(data$cigs, breaks = seq(floor(min(data$cigs)/bin_width)*bin_width, 
                             ceiling(max(data$cigs)/bin_width)*bin_width, 
                             by = bin_width), 
     xlab = "Cigarettes smoked each day by the mother while pregnant", 
     ylab = "Count", 
     main = "Histogram of cigarettes smoked each day\nby the mother while pregnant")

## @knitr Question4-3-2
# Use ggplot and bin width = 1
ggplot(data = data, aes(cigs)) + 
  geom_histogram(colour = 'black', fill = 'white', 
                 binwidth = bin_width) +  
  labs(x = "Cigarettes smoked each day by the mother while pregnant", 
       y = "Count", 
       title = "Histogram of cigarettes smoked each day\nby the mother while pregnant")

## @knitr Question4-3-3
# Use ggplot and bin width = 5
bin_width = 5
ggplot(data = data, aes(cigs)) + 
  geom_histogram(colour = 'black', fill = 'white', 
                 binwidth = bin_width) +  
  labs(x = "Cigarettes smoked each day by the mother while\n pregnant", 
       y = "Count", 
       title = "Histogram of cigarettes smoked each day\nby the mother while pregnant")

## @knitr Question4-3-4
# Use ggplot and bin width = 10
bin_width = 10
ggplot(data = data, aes(cigs)) + 
  geom_histogram(colour = 'black', fill = 'white', 
                 binwidth = bin_width) +  
  labs(x = "Cigarettes smoked each day by the mother while\n pregnant", 
       y = "Count", 
       title = "Histogram of cigarettes smoked each day\nby the mother while pregnant")

## @knitr Question4-3-5
# Use ggplot and bin width = 5, smokers only
bin_width =5 
ggplot(data = data[!data$cigs==0,], aes(cigs)) +
  geom_histogram(colour = 'black', fill = 'white',
                 binwidth= bin_width) + 
  labs(x = "Cigarettes smoked each day by the mother while\n pregnant.", 
       y = "Count", 
       title = "Histogram of cigarettes smoked each day\nby the mother while pregnant. Smokers only.")

## @knitr Question4-3-6
# Use ggplot and bin width = 0.5, smokers only
bin_width =0.5 
ggplot(data = data[!data$cigs==0,], aes(log(cigs))) +
  geom_histogram(colour = 'black', fill = 'white',
                 binwidth= bin_width) + 
  labs(x = "Log of Cigarettes smoked each day by the mother while\n pregnant.", 
       y = "Count", 
       title = "Histogram of Log of cigarettes smoked\neach day by the mother while pregnant.\nSmokers only.")

## @knitr Question5
# QUESTION 5 --------------------------------------------------------------

## @knitr Question5-1
# Use ggplot
ggplot(data, aes(cigs, bwght)) + geom_point() +
  ggtitle('Scatterplot of Birght Weight and \n Cigarettes Smoked During Pregnancy') + 
  labs(x = 'Cigarettes smoked by the mother', y= "Birth weight") + 
  theme(plot.title = element_text(size=14, face="bold", margin = margin(10, 0, 10, 0)))


## @knitr Question6
# QUESTION 6 --------------------------------------------------------------

## @knitr Question6-1
# Exclude any data where there is no observation for cigs or bwght. Exclude outliers and 0s. 
data = data[complete.cases(data$bwght, data$cigs),]
# Exclude the upper outlier for bwght
data = data[!data$bwght == 0, ]
data = data[!data$bwght > 250,]
m <- lm(data$bwght~data$cigs)
summary.lm(m)


## @knitr Question7
# QUESTION 7 --------------------------------------------------------------

## @knitr Question7-1
#scatterplotMatrix in car. Show linear trend lines.
summary(data$faminc)
qnt <-  c(.01, .05, .1, .25, .5, .75, .9, .95, .99)
quantile(data$faminc, qnt)
h <- ggplot(data, aes(faminc)) + geom_histogram(binwidth= 5) +
  ggtitle('Family Income') + 
  theme(plot.title = element_text(size=14, face="bold", margin = margin(10, 0, 10, 0)))
h
require(car)
scatterplotMatrix(data[, c("bwght", "cigs", "faminc")], smoother = F)


## @knitr Question8
# QUESTION 8 --------------------------------------------------------------

## @knitr Question8-1
data = data[complete.cases(data$bwght, data$cigs, data$faminc),]
m2 <- lm(bwght~cigs + faminc, data = data)
summary.lm(m2)

## @knitr Question9
# QUESTION 9 --------------------------------------------------------------



## @knitr Question10
# QUESTION 10 --------------------------------------------------------------
