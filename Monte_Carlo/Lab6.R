library(car)
library(MASS)
mod.duncan.hub <- rlm(prestige ~ income + education, data=Duncan, maxit=200)
summary(mod.duncan.hub)

set.seed(1234)
mod.duncan.hub <- lm(prestige ~ income + education, data=Duncan)
summary(mod.duncan.hub)

system.time(duncan.boot <- Boot(mod.duncan.hub, R=1999, method = 'case'))
summary(duncan.boot, high.moments = TRUE)

system.time(duncan.boot <- Boot(mod.duncan.hub, R=1999, method = 'residual'))
summary(duncan.boot, high.moments = TRUE)
