
# wczytaj dane (3 szeregi czasowe)
# wyznacz stopy zwrotu
# oblicz średnią, kurtozę, skośność, odchylenie standardowe
# zbadaj czy zmienne mają rozkład normalny
# zbadaj stacjonarność szeregu czasowego
# narysuj wykres, histogram, wykres kwantyl-kwantyl
# oblicz obserwacje odstające powyżej 99 percentyla
# wyznacz korelacje między szeregami czasowymi
# znajdź dopasowanie rozkładu t- Studenta do danych empirycznych
library(plotly)
library(moments)
library(dplyr)
library(ggpubr)
library(BatchGetSymbols)
library(ggplot2)
library(quantmod)
library(tseries)
library(TSstudio)
library(tidyr)
library(fitdistrplus)
# set dates
first.date <- Sys.Date() - 100
last.date <- Sys.Date()
freq.data <- 'daily'
# set tickers
tickers <- c('FB','MSFT','ORCL', 'GOOGL', 'CSCO', 'NET', 'GE')

l.out <- BatchGetSymbols(tickers = tickers, 
                         first.date = first.date,
                         last.date = last.date, 
                         freq.data = freq.data,
                         cache.folder = file.path(tempdir(), 
                                                  'BGS_Cache') )

print(l.out$df.control)
df <- l.out$df.tickers

#stopa wzrotu dla  Adjusted Closing Price
res <- df %>% 
        group_by(ticker) %>% 
        dplyr::select(price.adjusted) %>% 
        summarise(round(Delt(price.adjusted)*100, 2))
df <- df[order(df$ticker), ]
colnames(res) <- c("ticker", "calc_RoR")
df <- cbind(df, calc_RoR = res$calc_RoR)

#oblicz średnią, kurtozę, skośność, odchylenie standardowe
statistics <- df %>% 
        group_by(ticker) %>% 
        dplyr::select(price.adjusted) %>% 
        summarise(
              Mean = median(price.adjusted),
              Kurtosis = kurtosis(price.adjusted),
              Skewness = skewness(price.adjusted),
              Stds = sd(price.adjusted)
              )
# zbadaj czy zmienne mają rozkład normalny (p-value > 0,05 oznacza, 
# że rozkład danych nie różni się znacząco od rozkładu normalnego. 
# Innymi słowy, możemy przyjąć normalność.)
normality <- df %>%
        group_by(ticker) %>%
        summarise(
                statistic = shapiro.test(price.adjusted)$statistic,
                p.value = shapiro.test(price.adjusted)$p.value
                )
#zbadaj stacjonarność szeregu czasowego
stationarity <- df %>%
        group_by(ticker) %>%
        summarise(
                'Ljung-Box' = Box.test(price.adjusted, lag=22, type="Ljung-Box")$p.value,
                'Dickey-Fuller' = adf.test(price.adjusted, alternative = "stationary")$p.value,
                'KPSS' = kpss.test(price.adjusted)$p.value
        )
# narysuj wykres, histogram, wykres kwantyl-kwantyl
img1 <- ggplot(data = df, aes(x=ref.date, y=price.adjusted)) + 
                        geom_line(aes(colour=ticker), size=1) +
                        ggtitle("Adjusted closing prices") +
                        labs(x = "Date",y = "USD", color = "Tickers")
f <- ggplotly(img1)
print(f)

img2 <- ggplot(data = df, aes(y=calc_RoR, fill=ticker), binwidth=2, size=0.3) + 
                        geom_histogram(aes(colour=ticker)) + 
                        facet_grid(ticker ~ .) + 
                        coord_flip() +
                        xlab("Counts") +
                        ylab("Rates of return,%")
f <- ggplotly(img2)
print(f)

img3 <- ggplot(data = df, aes(sample=calc_RoR)) + 
                        stat_qq(aes(colour=ticker))
f <- ggplotly(img3)
print(f)
# oblicz obserwacje odstające powyżej 99 percentyla
extravagante <- df %>%
        group_by(ticker) %>%
        filter(
                price.adjusted >= quantile(price.adjusted, 0.99)
        )
# wyznacz korelacje między szeregami czasowymi
ts_df <- df %>%
        dplyr::select(price.adjusted, ref.date, ticker) %>%
        pivot_wider(names_from=ticker, values_from=price.adjusted)
ggscatter(ts_df, x = "FB", y = "MSFT", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          color = 'orange', size = 4,
          xlab = "FB", ylab = "MSFT")
# znajdź dopasowanie rozkładu t- Studenta do danych empirycznych
res <- fitdistr(ts_df$MSFT, "t",
                start = list(m=mean(ts_df$MSFT),
                             s=sd(ts_df$MSFT),
                             df=3),
                lower=c(-1, 0.001,1))

