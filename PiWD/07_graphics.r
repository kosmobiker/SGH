rm(list=ls())

x11()
plot(x=cars$speed,y=cars$dist,axes=F)
#axis(1)
#axis(2)
#axis(1,at=cars$speed,labels=cars$speed)
#axis(2,at=cars$dist,labels=cars$dist)
#axis(1, col = "red", col.axis = "blue", lwd = 3, cex=5)
#box()


tmin <- as.Date("2000-01-01")
tmax <- as.Date("2001-01-01")
tlab <- seq(tmin, tmax, by="1 month")
lab <- tlab #format(tlab,format="%Y-%b")
set.seed(1)
x <- seq(tmin, tmax, length.out=100)
y <- cumsum(rnorm(100))

x11() 
op <- par(mar=c(6,4,1,1))
  plot(x, y, t="l", xaxt="n", xlab="",ylab="")
  axis(1, at=tlab, labels=FALSE)
  text(x=tlab, y=par()$usr[3]-0.1*(par()$usr[4]-par()$usr[3]),labels=lab, srt=45, adj=1, xpd=TRUE,cex=0.5,col="blue")
par(op)

