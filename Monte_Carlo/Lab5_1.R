library(bootstrap)
M <- NULL
S <- NULL
for (i in 1:1000) {
  m <- mean(sample(1:5, 5, replace = TRUE))
  s <- sd(sample(1:5, 5, replace = TRUE))
  M <- rbind(m, M)
  S <- rbind(s, S)
}
mean(M)
mean(S)
jackknife	(M, theta=mean)
