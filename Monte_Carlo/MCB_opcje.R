###############################################Opcja################################################################
# Black Scholes
library(randtoolbox)
library(fOptions)
K = 170
r = 0.019
sigma = 0.2
T = 15/252
S0 = 196
# call option
d1 <- (log(S0/K) + (r + sigma^2/2) * T)/(sigma * sqrt(T))
#d2 <- d1 - sigma * sqrt(T)
d2 <- (log(S0/K) + (r - sigma^2/2) * T)/(sigma * sqrt(T))
call_price <- S0 * pnorm(d1) - K * exp(-r * T) * pnorm(d2)
# put option
d1 <- (log(S0/K) + (r + sigma^2/2) * T)/(sigma * sqrt(T))
d2 <- d1 - sigma * sqrt(T)
put_price <- -S0 * pnorm(-d1) + K * exp(-r * T) * pnorm(-d2)
c(call_price, put_price)

#Pricing of European Options with Monte Carlo Simulation
call_put_mc<-function(nSim=10000, tau, r, sigma, S0, K, type="random") {
  
  if(type=="random"){
    #MC
    Z <- rnorm(nSim, mean=0, sd=1)
  }else if(type=="halton"){
    #QMC
    Z <- rnorm.halton(nSim, dimension=1)
  }else if(type=="sobol"){
    #QMC
    Z <- rnorm.sobol(nSim, dimension=1)
  }
  
  WT <- sqrt(tau) * Z
  ST = S0*exp((r - 0.5*sigma^2)*tau + sigma*WT)
  
  
  # call option
  call_payoffs <- exp(-r*tau)*pmax(ST-K,0)
  price_call <- mean(call_payoffs)
  SE_call <- sd(call_payoffs)/sqrt(nSim)
  LowerB_call <- price_call - 1.96*SE_call
  UpperB_call <- price_call + 1.96*SE_call
  # put option
  put_payoffs <- exp(-r*tau)*pmax(K-ST,0)
  price_put <- mean(put_payoffs)
  SE_put <- sd(put_payoffs)/sqrt(nSim)
  LowerB_put <- price_put - 1.96*SE_put
  UpperB_put <- price_put + 1.96*SE_put
  
  output<-list(price_call=price_call, SE_call=SE_call, LowerB_call=LowerB_call,UpperB_call=UpperB_call,
               price_put=price_put, SE_put=SE_put, LowerB_put=LowerB_put,UpperB_put=UpperB_put)
  return(output)
  
}
set.seed(1)
results1<-call_put_mc(nSim=1000000, tau=T, r=r, sigma=sigma, S0=S0, K=K)
results1$price_call
results2<-call_put_mc(nSim=1000000, tau=T, r=r, sigma=sigma, S0=S0, K=K, type="halton")
results2$price_call
results3<-call_put_mc(nSim=1000000, tau=T, r=r, sigma=sigma, S0=S0, K=K, type="sobol")
results3$price_call