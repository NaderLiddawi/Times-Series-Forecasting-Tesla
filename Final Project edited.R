library(astsa)
library(Metrics)

#read files and standardize frequency
data <- read.csv(file.choose(), header=TRUE)

# use (2010,26) because June 28 is 26th week of 2010
# use (2022, 8) since Feb 7 is 8th week of 2022
# these closing prices are not June 28 or Feb 7, but that week's Friday close; Yahoo Finance just gives us Monday date labels for some reason

tesla <- ts(data$Adj.Close, frequency = 52, start=c(2010,26), end=c(2022,8))  
x <- as.numeric(tesla)

#plot original weekly data
dev.new(10,6)
tsplot(tesla, main='Original Tesla Weekly Close Prices', ylab='Weekly Closing Prices')


#log transform the data to eliminate non-constant variance in the original data
dev.new(10,6)
tesla_log <- log(tesla)
tsplot(tesla_log, main='Log Transform of Tesla Weekly Close Prices')



#seasonality does NOT exist since there are no periodic spikes
# and we still have a lot of exponentially declining bars because we still have correlated terms (non-stationary)
dev.new(10,6)
acf2(log(x), max.lag=72, main='ACF/PACF of log data')


#take difference to reduce trend
dev.new(10,6)
tsplot(diff((tesla_log)), main='Log_Differenced Data of Tesla Weekly Close Prices', ylab='Log_Differenced Data')



#take double difference to further reduce trend/variance of log data (and achieve stationarity)
dev.new(10,6)
tsplot(diff(tesla_log, differences=2), main='Second- Order Log_Differenced Data of Tesla Weekly Close Prices', ylab='Log_Differenced Data')


#the exponential decline in ACF/PACF has been eliminated
dev.new(15,15)
acf2(diff(log(x), differences=2), max.lag=72, main='Estimated ACF and PACF for Log_Differenced Tesla')


# check p-value and residual assumptions
source("examine.mod.R")
dev.new(10,6)
bad.model <- sarima(log(x), p=3, d=2, q=1)
bad.model
examine.mod(candidate.model, 3, 2, 1)
# bad model


source("examine.mod.R")
dev.new(10,6)
candidate.model <- sarima(log(x), p=0, d=2, q=1)
candidate.model
examine.mod(candidate.model, 0, 2, 1)
# good model
#note: I got no good model while I used just first-order differencing


# you need to forecast with log data
dev.new(10,6)
forecast <- sarima.for(log(tesla), n.ahead=4, p=0, d=2, q=1, plot.all=FALSE)
forecast


# take exponential to get real data back
exp(forecast$pred)
exp(forecast$se)


# plot the real forecast telsa prices four weeks into the future
dev.new(10,6)
tsplot(exp(forecast$pred), ylab='Weekly Price of Tesla', ylim = c(850,900),
       xlab='Year', main="Forecasting Tesla Values 4 Weeks Out")

#buy put option at 883 (green) strike and sell put option at 888 (red) strike
abline(h=c(883,888), col=c("green", "red"), lty="solid")

#buy call option at 837 (green) strike and sell call option at 832 (red) strike
abline(h=c(899,894), col=c("green", "red"), lty="solid")

#plot the 95% confidence intervals
abline(h=c(889.00, 893.55), col="darkorchid", lty="dashed")

# add legend to understand the lines
legend("bottomleft", legend=c("Buy Line", "Sell Line", "Confidence Band"), col=c("green", "red", "darkorchid"),
       lty=c("solid", "solid", "dashed"),bty=0)


#____________________________________________________________________________________________________


# see how model predicts previous values
prediction.model <- ts(log(x) - candidate.model$fit$residuals, frequency=52, start=c(2010,26), end=c(2022,8))
                   

# plot how well our model did compared to true historical values
tesla <- ts(data$Adj.Close, frequency = 52, start=c(2010,26), end=c(2022,8))
dev.new(width=8, height=6)
tsplot(log(tesla), col='black', ylab="Tesla Weekly Log Prices", xlab="Year", type="o", pch=0,
       main="Historical Tesla stock data from 2010 to 2022", lty='solid')

lines((prediction.model), col="red", type="o", pch=5) 
legend("topleft", legend=c("Observed", "Forecast"), lty=c("solid", "solid"), col=c("black", "red"), pch=c(0, 5), bty="n")

rmse(log(x), prediction.model)


#____________________________________________________________________

# GARCH model to account for non-constant variance

# choose the ARIMA p,d,q order

# import the library ruGARCH
library(rugarch)

# sGarch = standard Garch; eGarch = exponential Garch, etc.
# specify GARCHorder(alpha=1,beta=1) -- most widely used order is (1,1) (function of past error(1) and a function of past volatility (1))
# armaOrder = (0,1) since AR=0 and MA=1 from code above
garch.model <- ugarchspec(variance.model=list(model="sGARCH", garchOrder=c(1,1)),
                mean.model=list(armaOrder=c(0,1)), distribution.model = "std")
    
my_data = diff(log(x), differences=2)
garch.fit <- ugarchfit(garch.model, data=my_data)          
garch.fit
# get parameter estimates via MLE by using two equations simultaneously (GARCH and ARMA)

# ARMA:
#mu (ARMA intercept) not significant
#ma1 significant
#ar1 (we did not use in our model-fitting)

# GARCH:
#omega (GARCH intercept) not significant
#alpha (past errors) #significant
#beta (past volatility) #significant
garch.fit@fit$coef

# forecast future 4 weeks
garch.forecast <- ugarchforecast(garch.fit, n.ahead=4)
garch.forecast
# exp(garch.forecast@forecast$)


#garch.predict <- ugarchboot(garch.fit, n.ahead=4, method=c("Partial", "Full")[1])
#garch.predict

# GARCH (forecasts=predictions) predicts volatility



garch.fit2 <- garchFit(formula=~arma(0,1)+garch(1,1), data=my_data)
garch.fit2

dev.new(width=8, height=6)
plot(garch.fit2)
plot(garch.fit2, which=4) # ACF

dev.new(width=8, height=6)
garch.predict2 <- predict(object=garch.fit2, n.ahead=4, plot=TRUE, nx=52, conf=0.95)
garch.predict2



