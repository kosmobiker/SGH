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
# SMA - Simple Moving Average (22 and 66)
add_SMA(n = 66, on = 1, col = "red")
add_SMA(n = 22, on = 1, col = "black")

#prolog data
df_log <- log(df)

#stationarity test
test_func <- function(x){
  c('Ljung-Box' = Box.test(diff(x), type="Ljung-Box")$p.value, 
    'Dickey-Fuller' = adf.test(diff(x)[-(1)], alternative = "stationary")$p.value,
    'KPSS' = kpss.test(x)$p.value)
}
stationarity <- sapply(df_log, test_func)
colnames(stationarity) <- "p-value"

#split date to train/test datasets
#80/20 train/test
split_date <- round(nrow(df_log) * 0.8)
train <- df_log[1:split_date, ]
test <- df_log[-c(1:split_date), ]

#horizon of predictions
h <- length(test)

#base ARIMA model
arima <- auto.arima(train, stepwise = FALSE, approximation = FALSE,
              seasonal = TRUE, lambda = "auto", trace=TRUE) 
arima_forecast <- forecast(arima, h=h, level=95)
arima_preds <- as.numeric(arima_forecast$mean)

#bootstrapping
arima_forecast_fun <- function(x) {
    #auxiliary function for bootstrapping
    #makes forecasting based for each bootstrap
    tmp <- unlist(x)%>% 
          auto.arima(stepwise = FALSE, approximation = FALSE,
                      seasonal = TRUE, lambda = "auto") %>% 
            forecast(h=h,level=95)
  return(tmp$mean)
}


# moving block bootstrap
arima_boot <- function(data, nsim, h, mdl){
  #function to calculate bootstrap
  #data - train data, nsim - number of blocks, h - horizon, mdl - auto ARIMA model
  sim <- bld.mbb.bootstrap(data, nsim)
  predictions <- do.call(rbind, lapply(sim, arima_forecast_fun))
  return(colMeans(predictions))
}

arima_mbb_bootstrap_100 <- arima_boot(train, 100, h=h, arima)

#metrics
metrics_func <- function(actual, predicted){
  c(rmse = rmse(actual, predicted), mae = mae(actual, predicted), mape = mape(actual, predicted))
}
t <- list(arima_preds, arima_mbb_bootstrap_100)
res <- sapply(t, metrics_func, actual=test)
colnames(res) <- c("ARIMA", "arima_mbb_bootstrap_100")
print(res)

#plot
test <- exp(test)
test$a <- exp(arima_preds)
test$b <- exp(arima_mbb_bootstrap_100)
r <- merge(exp(train), test)
colnames(r) <- c("train", "test", "ARIMA", "ARIMA_boot_100")
plot(r, main='Adjusted closing price for Microsoft Corp.', legend.loc='topleft')

