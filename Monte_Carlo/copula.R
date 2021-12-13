library(psych)
cor(z,method='spearman')

e <- RData$USDEUR
y <- RData$USDJPY

library(VineCopula)

u <- pobs(as.matrix(cbind(e,y)))[,1] # Pseudo observations are the observations in the [0,1] interval.
v <- pobs(as.matrix(cbind(e,y)))[,2]
selectedCopula <- BiCopSelect(u,v,familyset=NA) #estimated the parameters 
selectedCopula

#comparison using copula package
library(copula)
t.cop <- tCopula(dim=2)
set.seed(500)
m <- pobs(as.matrix(cbind(e,y)))
fit <- fitCopula(t.cop,m,method='ml')
coef(fit)

rho <- coef(fit)[1]
df <- coef(fit)[2]
persp(tCopula(dim=2,rho,df=df),dCopula)

# build the copula and sample from it n random sample
u <- rCopula(7989,tCopula(dim=2,rho,df=df))
plot(u[,1],u[,2],pch='.',col='blue')
cor(u,method='kendall')


#modelling the marginals. 
e_mu <- mean(e)
e_sd <- sd(e)
y_mu <- mean(y)
y_sd <- sd(y)



## Frank copula

d <- 2 # dimension
theta <- -9 # copula parameter
fc <- frankCopula(theta, dim = d) # define a Frank copula

set.seed(2010)
n <- 5 # number of evaluation points
u <- matrix(runif(n * d), nrow = n) # n random points in [0,1]^d
pCopula(u, copula = fc) # copula values at u

dCopula(u, copula = fc) # density values at u

wireframe2(fc, FUN = pCopula, # wireframe plot (copula)
           draw.4.pCoplines = FALSE)
wireframe2(fc, FUN = dCopula, delta = 0.001) # wireframe plot (density)
contourplot2(fc, FUN = pCopula) # contour plot (copula)
contourplot2(fc, FUN = dCopula, n.grid = 72, # contour plot (density)
             lwd = 1/2)

set.seed(1946)
n <- 1000
U  <- rCopula(n, copula = fc)
U0 <- rCopula(n, copula = setTheta(fc, value = 0))
U9 <- rCopula(n, copula = setTheta(fc, value = 9))
par(mar=c(1,1,1,1))
par(mfrow=c(2,2))
plot(U,  xlab = quote(U[1]), ylab = quote(U[2]))
plot(U0, xlab = quote(U[1]), ylab = quote(U[2]))
plot(U9, xlab = quote(U[1]), ylab = quote(U[2]))


### Copula in Regression #############################################################

### Conditional modeling based on marginal gamma GLMs
require(copulaData)
data(NELS88, package = "copulaData")
nels <- subset(NELS88, select = -ID) # remove school ID

nels$Size <- scale(nels$Size) # mean 0, standard deviation 1


## Build the design matrix
math.glm <- glm(Math ~ Minority + SES + Female + Public + Size +
                  Urban + Rural, data = nels, family = Gamma(link = "log"))
(math.summary <- summary(math.glm))

## The estimates of (beta_{1,1}, ..., beta_{1,9})
(ts.math <- c(math.glm$coefficients, disp = math.summary$dispersion))


## Science score
sci.glm <- glm(Science ~ Minority + SES + Female + Public + Size +
                 Urban + Rural, data = nels, family = Gamma(link = "log"))
## The estimates of (beta_{2,1}, ..., beta_{2,9})
(ts.sci <- c(sci.glm$coefficients, disp = summary(sci.glm)$dispersion))

## Reading score
read.glm <- glm(Reading ~ Minority + SES + Female + Public + Size +
                  Urban + Rural, data = nels, family = Gamma(link = "log"))
## The estimates of (beta_{3,1}, ..., beta_{3,9})
(ts.read <- c(read.glm$coefficients, disp = summary(read.glm)$dispersion))

## Parametric pseudo-observations from the underlying trivariate conditional
## copula under the parametric assumptions and the simplifying assumption
U <- pobs(cbind(residuals(math.glm), residuals(sci.glm),
                residuals(read.glm)))

splom2(U, cex = 0.3, col.mat = "black") # scatter-plot matrix
library(lattice)
cloud2(U) # 3d cloud plot based on lattice's cloud()



summary(ts.g <- fitCopula(gumbelCopula(dim = 3), data = U))

summary(ts.f <- fitCopula(frankCopula (dim = 3), data = U))

summary(ts.n.ex <- fitCopula(normalCopula(dim = 3, dispstr = "ex"), data=U))
