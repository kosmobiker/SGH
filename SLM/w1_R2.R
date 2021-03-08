sizes <- seq(from = 10, to = 200, by = 10)
reps <- 10000

sim.r.squared <- function(n) {
    x <- rnorm(n)
    y <- 1 + x + rnorm(n)
    model <- lm(y ~ x)
    return(summary(model)$r.squared)
}

r.squared.q95 <- numeric(length(sizes))
r.squared.q5 <- numeric(length(sizes))
r.squared.mean <- numeric(length(sizes))

system.time(for (i in 1:length(sizes)) {
    print(sizes[i])
    result <- replicate(reps, sim.r.squared(sizes[i]))
    r.squared.mean[i] <- mean(result)
    r.squared.q5[i] <- quantile(result, 0.05)
    r.squared.q95[i] <- quantile(result, 0.95)
})

plot(sizes, r.squared.mean,
     ylim=c(min(r.squared.q5), max(r.squared.q95)),
     xlab="sample size", ylab=expression(R^2))
lines(sizes, r.squared.q5); lines(sizes, r.squared.q95)
