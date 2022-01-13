#import libraries
library(plotly)
library(dplyr)
library(ggplot2)
library(tseries)
library(TSstudio)
library(forecast)
library(quantmod)
library(Metrics)
#set the seed
set.seed(123)

# set dates and frequency
first.date <- as.Date('2021-01-01 UTC')
last.date <- as.Date('2021-12-31 UTC')
freq.data <- 'daily'

# set tickers
ticker <- c('MSFT')

df <- getSymbols(Symbols = ticker, src = "yahoo", from = first.date, 
                        to = last.date, auto.assign = FALSE)
df <- Cl(df)

#basic plot
chart_Series(df, name=ticker, col = "black")
# SMA - Simple Moving Average (30 and 90)
add_SMA(n = 90, on = 1, col = "red")
add_SMA(n = 30, on = 1, col = "black")

#split date to train/test datasets
#80/20 train/test
split_date <- round(nrow(df) * 0.8)
train <- df[1:split_date, ]
test <- df[-c(1:split_date), ]

#horizon of predictions
h <- length(test)

#base ARIMA model
arima <- auto.arima(train, stepwise = FALSE, approximation = FALSE,
              seasonal = FALSE, lambda = "auto", trace=TRUE) 
arima_forecast <- forecast(arima, h=h, level=95)
arima_preds <- as.numeric(arima_forecast$mean)

#bootstrapping
arima_forecast_fun <- function(x) {
    #auxiliary function for bootstrapping
    #makes forecasting based for each bootstrap
    tmp <- unlist(x)%>% 
          auto.arima(stepwise = FALSE, approximation = FALSE,
                      seasonal = FALSE, lambda = "auto") %>% 
            forecast(h=h,level=95)
  return(tmp$mean)
}

arima_boot <- function(data, nsim, h, mdl){
  #function to calculate bootstrap
  #data - train data, nsim - number of blocks, h - horizon, mdl - auto ARIMA model
  sim <- bld.mbb.bootstrap(data, nsim)
  predictions <- do.call(rbind, lapply(sim, arima_forecast_fun))
  return(colMeans(predictions))
}

arima_boot_preds_50 <- arima_boot(train, 50, h=h, arima)
arima_boot_preds_200 <- arima_boot(train, 200, h=h, arima)

#metrics
metrics_func <- function(actual, predicted){
  c(rmse = rmse(actual, predicted), mae = mae(actual, predicted), mape = mape(actual, predicted))
}
t <- list(arima_preds, arima_boot_preds_50, arima_boot_preds_200)
res <- sapply(t, metrics_func, actual=test)
colnames(res) <- c("ARIMA", "ARIMA_boot_50", "ARIMA_boot_200")
print(res)

#plot
# img <- ggplot(data=train, aes(x=))
