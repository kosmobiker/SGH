library(ggplot2)
set.seed(123)
x <- replicate(n = 3, rnorm(10000, 0, 3), simplify = FALSE)
res <- sapply(x, sd)
rnorm(4)

set.seed(1)

length_of_time_series <- 1000
num_replications <- 4

errors <- matrix(rnorm(length_of_time_series*num_replications),
                 ncol=num_replications)
rw <- apply(errors, 2, cumsum)
df <- data.frame(matrix(unlist(rw), nrow=length(rw), byrow=FALSE))
