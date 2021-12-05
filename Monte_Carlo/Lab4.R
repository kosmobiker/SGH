library(randtoolbox)
library(ggplot2)
library(plotly)
library(ggpubr)
library(dplyr)
library(tidyr)
library(fOptions)
library(copula)
library(VineCopula)
library(tidyverse)
library(scatterplot3d)
library(BatchGetSymbols)


Halton <- function(n, prime) {
  halton_single_number <- function(n, prime) {
    n_0 <- n
    hn <- 0
    f <- 1/prime
    while(n_0 > 0) {
      n_1 <- floor(n_0/prime)
      r <- n_0 - n_1*prime
      hn <- hn + f*r
      f = f/prime
      n_0 = n_1
    }
    return(hn)
  }
  vector <- rep(0, n)
  for(i in 1:n) {
    vector[i] <- halton_single_number(i, prime)
  }
  return(vector)
}
h <- halton(1000, 2)
s <- sobol(1000, 2)
r <- matrix(runif(200), nrow = 1000, ncol = 2)
df <- data.frame(unlist(h), unlist(s), unlist(r)) 
names(df) <- c("Halton1", "Halton2", "Sobol1", "Sobol2", "Random1", "Random2")
# df <- df %>%
#   mutate(ix = 1:nrow(df)) %>%
#   pivot_longer(-ix, names_to = 'type', values_to = 'values')
img1 <- ggplot(df, aes(x=Halton1, y=Halton2)) +
  geom_point(colour="red")
img2 <- ggplot(df, aes(x=Sobol1, y=Sobol2)) +
  geom_point(size=0.8, shape=1, colour="blue")
img3 <- ggplot(df, aes(x=Random1, y=Random2, fill='blue')) +
  geom_point(size=0.8, shape=1)
ggarrange(img1, img2, img3, 
          labels = c("Halton", "Sobol", "Random"),
          ncol = 2, nrow = 2)
ggplot(df, aes(x=Random1, y=Random2)) +
  geom_point(color='darkblue') +
  xlab("X") + ylab("Y")

prices <- c(196, 161, 170)
calls <- NULL
puts <- NULL
for (i in prices){
  tmp <- BlackScholesOption(TypeFlag = "c", S = i, X = 184, Time = 3/52, r = 0.03,
                   b = 0.03, sigma = 0.20)@price
  calls <- rbind(calls, tmp)
  tmp <- BlackScholesOption(TypeFlag = "p", S = i, X = 184, Time = 3/52, r = 0.03,
                   b = 0.03, sigma = 0.20)@price
  puts <- rbind(puts, tmp)
}
df <- data.frame(unlist(prices), unlist(calls), unlist(puts))
names(df) <- c("Cena opcji, PLN", "CALL", "PUT")

# set dates
first.date <- Sys.Date() - 1000
last.date <- Sys.Date()
freq.data <- 'daily'
# set tickers
tickers <- c('HPE', 'DELL')

l.out <- BatchGetSymbols(tickers = tickers, 
                         first.date = first.date,
                         last.date = last.date, 
                         freq.data = freq.data,
                         cache.folder = file.path(tempdir(), 
                                                  'BGS_Cache'))

df <- l.out$df.tickers
df <- df %>% select(ref.date, ticker, price.adjusted) 
df <- spread(df, ticker, price.adjusted)
hpe <- pobs(df)[, 2]
dell <- pobs(df)[, 3]
m <- as.matrix(cbind(hpe,dell))
selectedCopula <- BiCopSelect(hpe, dell, familyset = NA)

gauss_cop <- normalCopula(dim=2)
fit <- fitCopula(gauss_cop, m, method='ml')
par_2 <- coef(fit)
gf <- gofCopula(gauss_cop, m, N = 50)
x_mean <- mean(df$HPE)
x_var <- var(df$HPE)
x_rate <- x_mean / x_var
x_shape <- ( (x_mean)^2 ) / x_var

y_mean <- mean(df$DELL)
y_var <- var(df$DELL)
y_rate <- y_mean / y_var
y_shape <- ( (y_mean)^2 ) / y_var


my_dist <- mvdc(normalCopula(par_2, dim=2), margins = c("gamma","gamma"), paramMargins = list(list(shape = x_shape, rate = x_rate), list(shape = y_shape, rate = y_rate)))
# Generate random sample observations from the multivariate distribution
v <- rMvdc(5000, my_dist)
# Compute the density
pdf_mvd <- dMvdc(v, my_dist)
# Compute the CDF
cdf_mvd <- pMvdc(v, my_dist)
# 3D plain scatterplot of the generated bivariate distribution
par(mfrow = c(1, 2))
scatterplot3d(v[,1],v[,2], pdf_mvd, color="red", main="Density", xlab = "u1", ylab="u2", zlab="pMvdc",pch=".")
scatterplot3d(v[,1],v[,2], cdf_mvd, color="red", main="CDF", xlab = "u1", ylab="u2", zlab="pMvdc",pch=".")
img2 <- scatterplot3d(v[,1],v[,2], 
                      cdf_mvd, 
                      color="blue",
                      main="CDF", 
                      xlab = "u1", 
                      ylab="u2", 
                      zlab="pMvdc",
                      pch=".")
cor(m, method = "kendall")
