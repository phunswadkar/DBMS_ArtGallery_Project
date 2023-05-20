## USE FORECAST LIBRARY.

library(forecast)

## CREATE DATA FRAME. 

# Set working directory for locating files.
setwd("/Users/pallavihunswadkar/Desktop/Time series/TimeSeriesLabs")

# Create data frame.
revenue.data <- read.csv("673_case2.csv")

# See the first 6 records of the file.
head(revenue.data)
tail(revenue.data)
##Creating timeseries data
revenue.ts <- ts(revenue.data$Revenue, 
                 start = c(2005, 1), end = c(2022, 4), freq = 4)
revenue.ts

## Use plot() to plot time series data  
plot(revenue.ts, 
     xlab = "Time", ylab = "Revenue (in $millions)", 
     ylim = c(60000, 170000), xaxt = 'n',
     main = "Walmart Revenue")
# Establish x-axis scale interval for time in months.
axis(1, at = seq(2005, 2022, 1), labels = format(seq(2005, 2022, 1)))

# Use stl() function to plot times series components of the original data. 
# The plot includes original data, trend, seasonal, and reminder 
# (level and noise component).
revenuedata.stl <- stl(revenue.ts, s.window = "periodic")
autoplot(revenuedata.stl, main = "Quarterly Revenue Time Series Components")


# Define the numbers of months in the training and validation sets,
# nTrain and nValid, respectively.
nValid <- 16
nTrain <- length(revenue.ts) - nValid
train.ts <- window(revenue.ts, start = c(2005, 1), end = c(2005, nTrain))
valid.ts <- window(revenue.ts, start = c(2005, nTrain + 1), 
                   end = c(2005, nTrain + nValid))
train.ts
valid.ts

##1A TEST PREDICTABILITY OF Walmart Revenue
# Use Arima() function to fit AR(1) model for S&P500 close prices.
# The ARIMA model of order = c(1,0,0) gives an AR(1) model.
revenue.ar1<- Arima(revenue.ts, order = c(1,0,0))
summary(revenue.ar1)

# Apply z-test to test the null hypothesis that beta 
# coefficient of AR(1) is equal to 1.
ar1 <- 0.9269
s.e. <- 0.0525
null_mean <- 1
alpha <- 0.05
z.stat <- (ar1-null_mean)/s.e.
z.stat
p.value <- pnorm(z.stat)
p.value
if (p.value<alpha) {
  "Reject null hypothesis"
} else {
  "Accept null hypothesis"
}

#1B Create first differenced Walmart revenue data using lag1.
diff.revenue <- diff(revenue.ts, lag = 1)
diff.revenue

# Use Acf() function to identify autocorrealtion for first differenced 
# Walmart revenue, and plot autocorrelation for different lags 
# (up to maximum of 8).
Acf(diff.revenue, lag.max = 8, 
    main = "Autocorrelation for Differenced Walmart Revenue Data")

#ANSWER 2A
# Use tslm() function to create quadratic trend and seasonal model.
train.quad.season <- tslm(train.ts ~ trend + I(trend^2) + season)

# See summary of quadratic trend and seasonality model and associated parameters.
summary(train.quad.season)


# Apply forecast() function to make predictions for ts with 
# trend and seasonality data in validation set.  
train.quad.season.pred <- forecast(train.quad.season, h = nValid, level = 0)
train.quad.season.pred

#ANSWER 2B
# Use Acf() function to identify autocorrelation for the model residuals 
# (training and validation sets), and plot autocorrelation for different 
# lags (up to maximum of 12).
Acf(train.quad.season.pred$residuals, lag.max = 8, 
    main = "Autocorrelation for Revenue Training Residuals")

#ValidationSet
Acf(valid.ts - train.quad.season.pred$mean, lag.max = 8, 
    main = "Autocorrelation for Revenue Validation Residuals")

#ANSWER2C
# Use Arima() function to fit AR(1) model for training residuals. The Arima model of 
# order = c(1,0,0) gives an AR(1) model.
# Use summary() to identify parameters of AR(1) model. 
res.ar1 <- Arima(train.quad.season$residuals, order = c(1,0,0))
summary(res.ar1)

# Use forecast() function to make prediction of residuals in validation set.
res.ar1.pred <- forecast(res.ar1, h = nValid, level = 0)
res.ar1.pred

# Use Acf() function to identify autocorrealtion for the training 
# residual of residuals and plot autocorrelation for different 
# lags (up to maximum of 12).
Acf(res.ar1$residuals, lag.max = 8, 
    main = 
      "Autocorrelation for Training Residuals of Residuals")

#ANSWER2D
# Create data table with validation data, regression forecast
# for validation period, AR(1) residuals for validation, and 
# two level model results. 
valid.two.level.pred <- train.quad.season.pred$mean + res.ar1.pred$mean

valid.df <- round(data.frame(valid.ts, train.quad.season.pred$mean, 
                             res.ar1.pred$mean, valid.two.level.pred),3)
names(valid.df) <- c("Revenue", "Reg.Forecast", 
                     "AR(1)Forecast", "Combined.Forecast")
valid.df

# Use accuracy() function to identify common accuracy measures for validation period forecast:
# (1) two-level model (linear trend and seasonal model + AR(1) model for residuals),
round(accuracy(valid.two.level.pred, valid.ts), 3)
# (2) Quadratic trend and seasonality model only.
round(accuracy(train.quad.season.pred$mean, valid.ts), 3)

#ANSWER2E
## FIT REGRESSION MODEL WITH Quadratic TREND AND SEASONALITY 
# for the entire data set.
quad.season <- tslm(revenue.ts ~ trend  + I(trend^2) + season)

# See summary of quadratic trend and seasonality equation 
# and associated parameters.
summary(quad.season)
# Apply forecast() function to make predictions with quadratic trend and seasonal 
# model into the future 8 quarters.  
quad.season.pred <- forecast(quad.season, h = 8, level = 0)
quad.season.pred

# Use Acf() function to identify autocorrelation for the model residuals 
# for entire data set, and plot autocorrelation for different 
# lags (up to maximum of 8).
Acf(quad.season.pred$residuals, lag.max = 8, 
    main = "Autocorrelation of Regression Residuals for Entire Data Set")

# Use Arima() function to fit AR(1) model for regression residuals.
# The ARIMA model order of order = c(1,0,0) gives an AR(1) model.
# Use forecast() function to make prediction of residuals
residual.ar1 <- Arima(quad.season$residuals, order = c(1,0,0))
residual.ar1.pred <- forecast(residual.ar1, h = 8, level = 0)
# Use summary() to identify parameters of AR(1) model.
summary(residual.ar1)
# Use Acf() function to identify autocorrealtion for the residual of residuals 
# and plot autocorrelation for different lags (up to maximum of 8).
Acf(residual.ar1$residuals, lag.max = 8, 
    main = 
      "Autocorrelation for AR(1) Model Residuals for Entire Data Set")

# Identify two-level forecast for the 8 future periods 
# as sum of quadratic trend and seasonality model 
# and AR(1) model for residuals.
quad.season.ar1.pred <- quad.season.pred$mean + residual.ar1.pred$mean
quad.season.ar1.pred
# Create a data table with linear trend and seasonal forecast 
# for 8 future periods, AR(1) model for residuals for 8 
# future periods, and combined two-level forecast
table.df <- data.frame(quad.season.pred$mean, 
                       residual.ar1.pred$mean, 
                       quad.season.ar1.pred)
names(table.df) <- c("Reg.Forecast", "AR(1)Forecast",
                     "Combined.Forecast")
table.df

#ANSWER3A
## FIT ARIMA(1,1,1)(1,1,1) MODEL.
# Use Arima() function to fit ARIMA(1,1,1)(1,1,1) model for 
# trend and seasonality.
# Use summary() to show ARIMA model and its parameters.
train.arima.seas <- Arima(train.ts, order = c(1,1,1), 
                          seasonal = c(1,1,1)) 
summary(train.arima.seas)

# Apply forecast() function to make predictions for ts with 
# ARIMA model in validation set.    
train.arima.seas.pred <- forecast(train.arima.seas, h = nValid, level = 0)
train.arima.seas.pred

# Use Acf() function to create autocorrelation chart of ARIMA(2,1,2)(1,1,2) 
# model residuals.
Acf(train.arima.seas$residuals, lag.max = 8, 
    main = "Autocorrelations of ARIMA(1,1,1)(1,1,1) Model Residuals")

#ANSWER3B
## FIT AUTO ARIMA MODEL.
# Use auto.arima() function to fit ARIMA model.
# Use summary() to show auto ARIMA model and its parameters.
train.auto.arima <- auto.arima(train.ts)
summary(train.auto.arima)

# Apply forecast() function to make predictions for ts with 
# auto ARIMA model in validation set.  
train.auto.arima.pred <- forecast(train.auto.arima, h = nValid, level = 0)
train.auto.arima.pred

# Using Acf() function, create autocorrelation chart of auto ARIMA 
# model residuals.
Acf(train.auto.arima$residuals, lag.max = 8, 
    main = "Autocorrelations of Auto ARIMA Model Residuals")

#ANSWER3C
# (1) ARIMA(1,1,1)(1,1,1) model; and 
round(accuracy(train.arima.seas.pred$mean, valid.ts), 3)
# (2) Auto ARIMA model.
round(accuracy(train.auto.arima.pred$mean, valid.ts), 3)

#ANSWER3D
# Use arima() function to fit seasonal ARIMA(1,1,1)(1,1,1) model 
# for entire data set.
# use summary() to show auto ARIMA model and its parameters for entire data set.
arima.seas <- Arima(revenue.ts, order = c(1,1,1), 
                    seasonal = c(1,1,1)) 
summary(arima.seas)

# Apply forecast() function to make predictions for ts with 
# seasonal ARIMA model for the future 12 periods. 
arima.seas.pred <- forecast(arima.seas, h = 8, level = 0)
arima.seas.pred

# Use Acf() function to create autocorrelation chart of seasonal ARIMA 
# model residuals.
Acf(arima.seas$residuals, lag.max = 8, 
    main = "Autocorrelations of Seasonal ARIMA (1,1,1)(1,1,1) Model Residuals")

# Use auto.arima() function to fit ARIMA model for entire data set.
# use summary() to show auto ARIMA model and its parameters for entire data set.
auto.arima <- auto.arima(revenue.ts)
summary(auto.arima)

# Apply forecast() function to make predictions for ts with 
# auto ARIMA model for the future 12 periods. 
auto.arima.pred <- forecast(auto.arima, h = 8, level = 0)
auto.arima.pred

# Use Acf() function to create autocorrelation chart of auto ARIMA 
# model residuals.
Acf(auto.arima$residuals, lag.max = 8, 
    main = "Autocorrelations of Auto ARIMA Model Residuals")

#ANSWER3E
#(1) regression model with quadratic trend and seasonality;
round(accuracy(quad.season$fitted, revenue.ts), 3)
#(2) two-level model (with AR(1) model for residuals); 
round(accuracy(quad.season$fitted + residual.ar1$fitted, revenue.ts), 3)
#(3) ARIMA(1,1,1)(1,1,1) model; 
round(accuracy(arima.seas.pred$fitted, revenue.ts), 3)
#(4) auto ARIMA model;
round(accuracy(auto.arima.pred$fitted, revenue.ts), 3)
#(5) seasonal naïve
round(accuracy((snaive(revenue.ts))$fitted, revenue.ts), 3)

