rm(list=ls())


d <- read.table(file="../data/data_pwid/GoldPrice.csv",sep=",",dec=".",header=T,stringsAsFactors=F)
#d <- d[,c(1,grep("USD",d[2,]))]
d <- d[-c(1:4),c(1,14)]

colnames(d) <- c("Date","Price")
d$Date <- as.Date(d$Date,format="%d/%m/%y")
d$Price <- as.numeric(d$Price)
print(head(d))

x11(); plot(d$Price)

library(zoo)
z <- zoo(d$Price,d$Date)

x11(); plot(z,xlab="Days",ylab="USD")

z <- na.approx(z)
lines(z,col="red")

z.mean.center <- rollmean(z,4*7,align="center")

lines(z.mean.center,col="green3",lwd=4,lty=3)

abline(
  v=seq(from=as.Date("2015-01-01"),to=as.Date("2021-01-01"),by="1 year"),
  col="orange",lty=2
)


z2 <- zoo(
    data.frame(
        A=d$Price,
        B=d$Price+rnorm(nrow(d),100,50),
        C=d$Price+rnorm(nrow(d),10,250)
    ),
    d$Date)
x11();plot(
  z2,main="Trzy szeregi czasowe",col=c("red","blue","green"),
  xlab="Czas",ylab="USD",screens=c(1,2,3))

