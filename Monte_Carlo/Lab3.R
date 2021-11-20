library(ggplot2)
library(ragtop)
library(tidyverse)

GRB <- function(nsim = 100, t = 25, mu = 0, sigma = 0.1, S0 = 100, dt = 1./365) {
  # matrix of random draws - one for each day for each simulation
  z <- matrix(rnorm(t*nsim), ncol = nsim, nrow = t)  
  # get GBM and convert to price paths
  gbm <- exp((mu - sigma * sigma / 2) * dt + sigma * z * sqrt(dt))
  gbm <- apply(rbind(rep(S0, nsim), gbm), 2, cumprod)
  return(gbm)
}

rb1 <- GRB(1000, 22, 1, 0.8, 100)

df <- as.data.frame(rb1) %>%
  mutate(ix = 1:nrow(rb1)) %>%
  pivot_longer(-ix, names_to = 'sim', values_to = 'price')
img <- 
  ggplot(data = df, aes(x=ix, y=price, color=sim)) +
  geom_line() +
  ggtitle("Ruch Browna. Symulacja N=1000") + 
  theme(legend.position = 'none')
print(img)
# KGHM akchje
stocks <- function(S0, S, N, delta){
  profit <- S*N - S0*N - delta*N
  return(profit)
}
stocks(170, 196, 100, 15)

BlackScholes <- function(S, K, r, T, sig, type){
  # S = Stock Price
  # K = Strike Price at Expiration 
  # r = Risk-free Interest Rate
  # T = Time to Expiration
  # sig = Volatility of the Underlying asset
  if(type=="C"){
    d1 <- (log(S/K) + (r + sig^2/2)*T) / (sig*sqrt(T))
    d2 <- d1 - sig*sqrt(T)
    
    value <- S*pnorm(d1) - K*exp(-r*T)*pnorm(d2)
    return(value)}
  
  if(type=="P"){
    d1 <- (log(S/K) + (r + sig^2/2)*T) / (sig*sqrt(T))
    d2 <- d1 - sig*sqrt(T)
    
    value <-  (K*exp(-r*T)*pnorm(-d2) - S*pnorm(-d1))
    return(value)}
}

prices <- c(196, 161, 170)
calls <- lapply(prices, BlackScholes, S=184, r=0.02, T=3/52, sig=0.2, type="C")
puts <- lapply(prices, BlackScholes, S=184, r=0.02, T=3/52, sig=0.2, type="P")
df <- data.frame(unlist(prices), unlist(calls), unlist(puts))
names(df) <- c("Cena opcji", "CALL", "PUT")


generate_values <- function(N, values){
  z <- sample(x = values, 
              size = N,
              replace = TRUE)
  return(z)
}

longest_run <- function(vec){
  z <- tapply(rle(vec)$lengths, rle(vec)$values, FUN=max)
  return(z)
}

num_of_heads <- function(N){
  tmp <- replicate(N, longest_run(generate_values(1000, c("H", "T")))["H"], simplify=TRUE)
  return(round(mean(tmp), 0))
}

num_of_heads(10000)


p <- 0.5
n <- 1000
L <- -log(n*(1-p), base=p)
