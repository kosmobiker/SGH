"
wczytaj dane (3 szeregi czasowe)
wyznacz stopy zwrotu
oblicz średnią, kurtozę, skośność, odchylenie standardowe
zbadaj czy zmienne mają rozkład normalny
zbadaj stacjonarność szeregu czasowego
narysuj wykres, histogram, wykres kwantyl-kwantyl
oblicz obserwacje odstające powyżej 99 percentyla
wyznacz korelacje między szeregami czasowymi
znajdź dopasowanie rozkładut- Studenta do danych empirycznych
"
library(moments)
library(dplyr)
library(BatchGetSymbols)
library(ggplot2)
library(quantmod)
# set dates
first.date <- Sys.Date() - 100
last.date <- Sys.Date()
freq.data <- 'daily'
# set tickers
tickers <- c('FB','MSFT','AMZN')

l.out <- BatchGetSymbols(tickers = tickers, 
                         first.date = first.date,
                         last.date = last.date, 
                         freq.data = freq.data,
                         cache.folder = file.path(tempdir(), 
                                                  'BGS_Cache') ) # cache in tempdir()

print(l.out$df.control)
df <- l.out$df.tickers
#stopa wzrotu dla  Adjusted Closing Price

res <- df %>% 
        group_by(ticker) %>% 
        select(price.adjusted) %>% 
        summarise(round(Delt(price.adjusted)*100, 2))
df <- df[order(df$ticker), ]
colnames(res) <- c("ticker", "calc_RoR")
df <- cbind(df, calc_RoR = res$calc_RoR)
#oblicz średnią, kurtozę, skośność, odchylenie standardowe
median(df[, 'price.adjusted'])
kurtosis(data[, 'price.adjusted'])
skewness(data[, 'price.adjusted'])
sd(data[, 'price.adjusted'])
