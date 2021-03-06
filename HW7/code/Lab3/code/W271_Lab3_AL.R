## MIDS W271-4 Lab3           ##
## Carin, Davis, Levato, Song ##


## @knitr Libraries-Functions-Constants
# LIBRARIES, FUNCTIONS AND CONSTANTS -------------------------------------------------
# Load libraries
# library(e1071)
library(gtools)
library(ggplot2)
library(ggfortify)
library(scatterplot3d)
library(scales)
library(knitr)
library(pastecs)
library(car)
# library(sandwich)
# library(lmtest)
library(plyr)
library(dplyr)
library(tidyr)
library(stargazer)
library(pander)
# library(texreg)
# library(weatherData)
library(scales)
library(xts)
library(reshape2)
library(lubridate)
library(forecast)
library(zoo)

library(fGarch)
library(quantmod)
library(tseries)

# Define functions

# A function to apply format
frmt <- function(qty, digits = 3) {
  formatC(qty, digits = digits, format = "f", drop0trailing = FALSE, 
          big.mark = ",")
}

# A function to present descriptive statistics of 1 or more vectors
desc_stat <- function(x, variables, caption) {
  ds <- data.frame(x)
  names(ds) <- letters[1:dim(ds)[2]]
  
  ds <- ds %>%
    gather %>%
    group_by(Variable = key) %>%
    summarise(Mean = mean(value), 'St. Dev' = sd(value), 
              '1st Quartile' = quantile(value, 0.25), Median = median(value),
              '3rd Quartile' = quantile(value, 0.75), Min = min(value), 
              Max = max(value)) %>% 
    select(-Variable) %>% 
    t %>% data.frame
  kable(ds, digits = 2, caption = caption, col.names = variables)
  
  # ds <- ds %>%
  #   summarise_each(funs(Mean =mean, 'St. Dev' = sd, 
  #                       '1st Quartile' = quantile(., 0.25), Median = median, 
  #                       '3rd Quartile' = quantile(., 0.75), Min = min, 
  #                       Max = max)) %>% 
  #   gather
  # if (dim(ds)[1] > 7)
  #   ds <- ds %>%
  #   mutate(Statistic = gsub(".*\\_", "", key),
  #          variable = gsub("\\_.*", "", key)) %>%
  #   select(-key) %>%
  #   spread(key = variable, value = value) %>%
  #   mutate(order = c(3, 5, 7, 1, 3, 6, 2)) %>%
  #   arrange(order) %>%
  #   select(-order)
  # kable(ds, col.names = c('', variables), digits = 2, caption = caption)
}

# Define constants
par(cex.main = 1, cex.lab = 0.9, cex.axis = 0.9)
set.seed(1234)


## @knitr ex2-load
# Loading the Data --------------------------------------------------------
# setwd('./Lab3/data')
#load the data
d<-read.csv('lab3_series02.csv')
str(d)
all(d$X == 1:dim(d)[1]) # check if 1st column is just an incremental index
d <- d[, -1]


## @knitr ex2-desc_stats
# Exploratory Data Analysis -----------------------------------------------
# See the definition of the function in ## @knitr Libraries-Functions-Constants
desc_stat(d, 'Time series', 'Descriptive statistics of the time series.')


## @knitr ex2-hist
hist(d, breaks = 30, col="gray", freq = FALSE, 
     xlab = "Level / Amplitude", main = "Histogram of the time series")
lines(density(d), col = 'blue', lty = 2)
leg.txt <- c("Estimated density plot")
legend("topright", legend = leg.txt, lty = 2, col = "blue", bty = 'n', cex = .8)


## @knitr ex2-time_plot
d.ts <- ts(d, frequency =1)
plot.ts(d.ts, col = 'blue', type = 'l', 
        xlab = "Time period", ylab = "Level / Amplitude", 
        main = "Time-series plot of the data")
abline(h = mean(d), col = 'red', lty = 2)
lines(stats::filter(d.ts, sides=2, rep(1, 7)/7), lty = 1, lwd = 1.5, 
      col = "green")
leg.txt <- c("Time-series", "Mean value", 
             "13-Point Symmetric Moving Average")
legend("topleft", legend = leg.txt, lty = c(1, 2, 1), lwd = c(1, 1, 1.5), 
       col = c("blue", "red", "green"), bty = 'n', cex = .8)

## @knitr ex2-time_plot_zoom
plot.ts(window(d.ts, 1332), col = 'blue', type = 'l', 
        xlab = "Time Period", ylab = "Level / Amplitude", 
        main = paste0("Detail of the last 1000 observations"))
plot.ts(window(d.ts, 1967), col = 'blue', type = 'l', 
        xlab = "Time Period", ylab = "Level / Amplitude", 
        main = paste0("Detail of the last 365 observations (year)"))
plot.ts(window(d.ts, 2241), col = 'blue', type = 'l', 
        xlab = "Time Period", ylab = "Level / Amplitude", 
        main = paste0("Detail of the last 91 observations(quarter)"))
plot.ts(window(d.ts, 2272 ), col = 'blue', type = 'l', 
        xlab = "Time Period", ylab = "Level / Amplitude", 
        main = paste0("Detail of the last 60 observations(two months"))


## @knitr ex2-boxplot
boxplot(d ~ factor(rep(1:22, each = 106)), 
        outcex = 0.4, medcol="red", lwd = 0.5, 
        xlab = 'Year', ylab = 'Level / Amplitude',
        main = 'Box-and-whisker plot of\nthe time series per year')
#plot the squared timeseries to check for staionarity in the variance
plot.ts(d.ts*d.ts, col = 'purple', type = 'l', 
        xlab = "Time period", ylab = "Level / Amplitude", 
        main = "Squared Time-series plot of the data")

## @knitr ex2-acf_pacf
# ACF and PACF of the Time Series -----------------------------------------
# Plot the ACF and PACF of the series
par(mfrow=c(1, 2))
par(cex.main = 1, cex.lab = 0.9, cex.axis = 0.9)
acf(d.ts, lag.max = 24, main = "ACF of the time series")
pacf(d.ts, lag.max = 24, main = "PACF of the time series")
par(mfrow=c(1, 1))
par(cex.main = 1, cex.lab = 0.9, cex.axis = 0.9)

## @knitr ex2-subset
#subset the data to only use observation 1500-2332
d_sub<-d[1500:2332]
d_sub.ts<-ts(d_sub, frequency =16)

## @knitr ex2-sub_time_plot
plot.ts(d_sub.ts, col = 'blue', type = 'l', 
        xlab = "Time period", ylab = "Level / Amplitude", 
        main = "Time-series plot of the data")
abline(h = mean(d_sub), col = 'red', lty = 2)
lines(stats::filter(d_sub.ts, sides=2, rep(1, 7)/7), lty = 1, lwd = 1.5, 
      col = "green")
leg.txt <- c("Time-series", "Mean value", 
             "13-Point Symmetric Moving Average")
legend("topleft", legend = leg.txt, lty = c(1, 2, 1), lwd = c(1, 1, 1.5), 
       col = c("blue", "red", "green"), bty = 'n', cex = .8)

## @knitr ex2-decompose
plot(decompose(d_sub.ts, type = 'multiplicative'), col = 'blue', 
     xlab = "Time Period")


## @knitr ex2-first_diff
d1.ts<-diff(d_sub.ts, frequency=16)
plot(d1.ts)
#Now we take a look at the variance of this differenced model by looking at the squared ts
plot.ts(d1.ts*d1.ts, col = 'purple', type = 'l', 
        xlab = "Time period", ylab = "Level / Amplitude", 
        main = "Squared Time-series plot of the first differenced data")

## @knitr ex2-acf
#conduct the acf of the squared values of the difference to identify conditional heteroskedasticity 
acf((d1.ts-mean(d1.ts))^2, lag.max = 24, main = "ACF of the squared values")

## @knitr ex2-sarima
#create function to find the best seasonal ARIMA model 
get.best.arima <- function(x.ts, maxord = c(1,1,1,1,1,1))
{
  best.aic <- 1e8
  n <- length(x.ts)
  for (p in 0:maxord[1]) for(d in 0:maxord[2]) for(q in 0:maxord[3]) 
    for (P in 0:maxord[4]) for(D in 0:maxord[5]) for(Q in 0:maxord[6])
    {
      fit <- arima(x.ts, order = c(p,d,q),
                   seas = list(order = c(P,D,Q), frequency(x.ts)),
                   method = "CSS")
      fit.aic <- -2*fit$loglik + (log(n)+1)*length(fit$coef)
      if (fit.aic < best.aic)
      {
        best.aic <- fit.aic
        best.fit <- fit
        best.model <- c(p,d,q,P,D,Q)
      }
    }
  list(best.aic, best.fit, best.model)
}
#run the function on the data
best_sarima_d1<-get.best.arima(d1.ts, maxord= c(2,2,2,2,2,2))
#pull out the best model coefs
best_sarima_d1[[3]]

## @knitr ex2-sarima_acf
#plot the acf and acf of squared vales to check for volitility 
best_fit_d1<-best_sarima_d1[[2]]
acf(resid(best_fit_d1))
acf(resid(best_fit_d1)^2)

## @knitr ex2-garch
#first we need to initialize the sarima model with the best coefs identified above
d1_sarima<-arima(d1.ts, order = c(0,0,0), seas = list(order = c(0,1,2), 16))
t(confint(d1_sarima))
d1_res<-resid(d1_sarima)
d1_garch<-garch(d1_res, trace=FALSE)
t(confint(d1_garch))
d1_gres <- resid(d1_garch)[-1]

## @knitr ex2-garch_acf
acf(d1_gres)
acf(d1_gres^2)

## @knitr ex2-forcast
plot(forecast(d1_sarima, h=36))