######################################Bootstrap##########################################
#example 1
require('boot')
require('bootstrap')
x<- c(-0.3, 0.5, 2.6, 1.0, -0.9)
sample(1:5, 5, replace=TRUE)

set.seed(5^13) 
n<- 25 
x<- rnorm(n)
varx<- var(x)*(n-1)/n #sample variance, uncorrected
c(varx, varx - 1.0, -1/n) #sample variance and bias relative to true value of 1.0 and expected value of bias

N<- 5000 #number of bootstrap resamples
bvarx<- NULL #initialize resample variances vector
for (i in 1:N) { #for each resample
  xstar<- sample(x, n, replace=TRUE) #generate resample of size n from data
  bvarx[i]<- var(xstar)*(n-1)/n #resample variance, uncorrected
}
thetastar<- mean(bvarx) #estimate of variance
c(thetastar, thetastar - varx) #resample variance estimate and bias estimate

#example 2
x<- c(41.28, 45.16, 34.75, 40.76, 43.61, 39.05, 41.20, 41.02, 41.33, 40.61, 40.49, 41.77, 42.07,
      44.83, 29.12, 45.59, 41.95, 45.78, 42.89, 40.42, 49.31, 44.01, 34.87, 38.60, 39.63, 38.52, 38.52,
      43.95, 49.08, 50.52, 43.85, 40.64, 45.86, 41.25, 50.35, 45.18, 39.67, 43.89, 43.89, 42.16)

summary(x)
c(var(x), sd(x))#variance and standard deviation of sample
shapiro.test(x)#test for normality Shapiro-Wilk normality test
n<- length(x) #sample size

mean(x) + qt(0.975, n-1)*sd(x)*c(-1,+1)/sqrt(n) #student t based 95% CI

#example a
Yvar <- c(8,9,10,13,12, 14,18,12,8,9,1,3,2,3,4)

#To generate a single bootstrap sample
sample(Yvar, replace = TRUE) 

#generate 1000 bootstrap samples
boot <-list()
for (i in 1:1000) 
  boot[[i]] <- sample(Yvar,replace=TRUE)
boot



########################################Permutation#####################################
N<- 5000 #number of bootstrap resamples
bvarx<- NULL #initialize resample variances vector
for (i in 1:N) { #for each resample
  xstar<- sample(x, n, replace=FALSE) #generate resample of size n from data
  bvarx[i]<- var(xstar)*(n-1)/n #resample variance, uncorrected
}
thetastar<- mean(bvarx) #estimate of variance
c(thetastar, thetastar - varx) #resample variance estimate and bias estimate

#example b
Yvar <- c(8,9,10,13,12, 14,18,12,8,9,1,3,2,3,4)
#generate 1000 bootstrap samples
permutes <-list()
for (i in 1:1000) 
  permutes[[i]] <- sample(Yvar,replace=FALSE)
permutes
#######################################Jackknife########################################

#example 3
x <- rnorm(30)               
theta <- function(x){mean(x)}

results_j <- jackknife(x,theta)  

#example 4
xdata <- matrix(rnorm(30),ncol=2)
n <- 15
theta <- function(x,xdata){ cor(xdata[x,1],xdata[x,2]) }
results <- jackknife(1:n,theta,xdata)

#example c
Yvar <- c(8,9,10,13,12,14,18,12,8,9,1,3,2,3,4)
jackdf <- list()
jack <- numeric(length(Yvar)-1)

for (i in 1:length (Yvar)){
  for (j in 1:length(Yvar)){
    if(j < i){ 
      jack[j] <- Yvar[j]
    }  else if(j > i) { 
      jack[j-1] <- Yvar[j]
    }
  }
  jackdf[[i]] <- jack
}
jackdf

#######################################cross-validation########################################
# cross-validation of least squares regression
# note that crossval is not very efficient, and being a
#  general purpose function, it does not use the
# Sherman-Morrison identity for this special case
#example 5
x <- rnorm(85)
y <- 2*x +.5*rnorm(85)
theta.fit <- function(x,y){lsfit(x,y)}
theta.predict <- function(fit,x){
  cbind(1,x)%*%fit$coef
}
results_cv <- crossval(x,y,theta.fit,theta.predict,ngroup=6) #cv The cross-validated fit for each observation. 