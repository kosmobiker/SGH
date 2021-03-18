rm(list=ls())

# odczyt danych + formatowanie 
d <- read.table(file="../data/data_pwid/PL_WYK_KSE.csv",sep=";",dec=",",header=T,stringsAsFactors=F)
d <- d[,c(1:3)]
colnames(d) <- c("Data","Godzina","KSE")
print(table(d$Godzina))
d <- d[-grep("2A",d$Godzina),]
print(table(d$Godzina))
d$Godzina <- as.integer(d$Godzina)
d$Timestamp <- as.POSIXct(paste0(d$Data," ",d$Godzina-1,":00:00"),tz="GMT")
print(head(d))
print(tail(d))

d <- d[c("Timestamp","KSE")]
d <- d[order(d$Timestamp),]

#x11(); plot(d$KSE,type="l",col=rgb(1,0,0,0.5))

# acf, pacf, ccf 
x11(); acf(d$KSE,lag.max=7*24)
x11(); pacf(d$KSE,lag.max=7*24)
x11(); ccf(d$KSE,d$KSE,lag.max=7*24)


dTs <- ts(d$KSE,freq=168)
myDecompAllData <- decompose(dTs)
x11(); plot(myDecompAllData)


dTsTail <- ts(head(tail(d$KSE,5*28*24),2*28*24),freq=168)
x11(); plot(dTsTail)
myDecompTail <- decompose(dTsTail)
x11(); plot(myDecompTail)

res <- as.numeric(myDecompTail$random)
x11(); qqnorm(res,col=rgb(1,0,0,0.5))
qqline(res,col="blue")
x11(); lag.plot(na.omit(res),set.lags=c(1:24)*1)

# model prognostyczny 
library("forecast")
model <- HoltWinters(dTsTail)
pred <- forecast(model,h=7*24)
x11();plot(pred)


