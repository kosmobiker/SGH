library(randtoolbox)
library(ggplot2)
library(plotly)
library(tidyverse)
library(VineCopula)
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
r <- matrix(runif(2000), nrow = 1000, ncol = 2)
df <- data.frame(unlist(h), unlist(s), unlist(r)) 
names(df) <- c("Halton1", "Halton2", "Sobol1", "Sobol2", "Random1", "Random2")
df <- df %>%
  mutate(ix = 1:nrow(df)) %>%
  pivot_longer(-ix, names_to = 'type', values_to = 'values')
img <- 
  ggplot(data = df, aes(x=ix, y=values, color=type)) +
  geom_line() +
  ggtitle("Trololo")
f <- ggplotly(img)
print(f)

BiCop(1, h)
