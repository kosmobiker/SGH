rm(list=ls())

# otwieranie terminala grafiki 
x11()

# zamykanie biezacego terminala grafiki 
dev.off()

# Podstawowe typy wykresu 
x11();plot(x=cars$speed,y=cars$dist, type="l")
x11();plot(x=cars$speed,y=cars$dist, type="p")
x11();plot(x=cars$speed,y=cars$dist, type="b")
x11();plot(x=cars$speed,y=cars$dist, type="c")
x11();plot(x=cars$speed,y=cars$dist, type="o")
x11();plot(x=cars$speed,y=cars$dist, type="h")
x11();plot(x=cars$speed,y=cars$dist, type="s")
x11();plot(x=cars$speed,y=cars$dist, type="S")
x11();plot(x=cars$speed,y=cars$dist, type="n")


# zapis grafiki 

#pdf(file="test.pdf")

bmp(file="test_2.bmp",width = 3*480, height = 3*480)
plot(x=cars$speed,y=cars$dist,type="b")
dev.off()

## inne formay 
## >? png 


# ## zapis/odczyt grafiki 
x11()
plot(x=cars$speed,y=cars$dist,type="b")
img <- recordPlot()
dev.off()
x11()
replayPlot(img)
save(img,file="binarka")
x <- get(load("binarka"))
x11();replayPlot(x)


# #
# saveRDS(img,file="img.rds")
# rm(img)
# img <- readRDS("img.rds")
# replayPlot(img)


## linie/punkty 
x11()
plot(x=cars$speed,y=cars$dist,type="l")
lines(x=cars$speed,y=cars$dist-5, lty=3, col="red")
points(x=cars$speed,y=cars$dist,  pch=5)

## text 
x11()
plot(
  x=cars$speed,
  y=cars$dist,
  type="b")
text(
  x=cars$speed-0.3,
  y=cars$dist+1,
  #labels=1:nrow(cars)   
  labels=paste("pkt.",1:nrow(cars))
  )
text(x=15,y=100, labels="HELLO!!!!",col="red")


x11()
plot(
  x=cars$speed,
  y=cars$dist,
  type="b")
abline(h=15,col="red")
abline(v=15,col="blue")
abline(h=c(1:10)*10)

model <- lm(cars$dist ~ cars$speed )
#abline(a=model$coefficients)

abline(
    a=model$coefficients[1],
    b=model$coefficients[2],
    col="green")


# 
x11()
#op <- par(mfcol=c(3,3))
op <- par(mfrow=c(3,3))
    plot(1:10)
    plot(1:10)
    plot(1:10)
    plot(1:10)
par(op)

x11()
#attach(mtcars)
layout(
  matrix(c(1,1,2,3), 2, 2, byrow = TRUE)
)
hist(mtcars$wt)
hist(mtcars$mpg)
hist(mtcars$disp)



## rodzaje linii 
x11()
op <- par(mfrow=c(3,2))
lapply(1:6,function(i){
    plot(x=cars$speed,
         y=cars$dist,
         type="l",
         lty=i,
         main=paste("lty =",i)
        )
})
par(op)


## grubosc linii 
x11()
op <- par(mfrow=c(3,3))
lapply(1:9,function(i){
    plot(x=cars$speed,
         y=cars$dist,
         type="l",
         lwd=i,
         lty=3,
         main=paste("lwd =",i))
})
par(op)



## typ punktu 
x11()
op <- par(mfrow=c(5,6))
lapply(0:25,function(i){
    
    plot(x=cars$speed,
         y=cars$dist,
         type="b",
         pch=i,
         main=paste("pch =",i))
})
par(op)

x11()
plot(cars$speed,pch="$") 
#plot(1:10,pch=c("$","@","#")) 
#plot(1:10,pch=letters[1:10])


## colory - podstawowe 
x11()
op <- par(mfrow=c(2,4))
lapply(1:8,function(i){
    plot(
      x=cars$speed,
      y=cars$dist,
      type="b",
      col=i,
      main=paste("col =",i))
})
par(op)


## http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf
x11();plot(x=cars$speed,y=cars$dist,type="b",col="darkorange2",lwd=1:8)

# palety kolorow
x11(); plot(1:100,col=rainbow(100))
x11();plot(x=cars$speed,y=cars$dist,
          type="b",col=rainbow(10),
          lwd=1:10)


x11();plot(
  x=cars$speed,
  y=cars$dist,
  type="b",
  col=rgb( 1, 0, 1,  0.5 ),
  lwd=1:10)

## inne parametry 
x11()
plot(x=cars$speed,y=cars$dist,type="b",col=rainbow(10),lwd=1:10,
      main="Tytul glowny", col.main="red",cex.main=3.2,
      sub="Podtytul", col.sub="blue", cex.sub=1,
      xlab="Podpis osi OX", ylab="Podpis osi OY",
      col.lab="green", cex.lab=0.75) 

## alternatywnie
# x11()
# plot(x=cars$speed,y=cars$dist,type="b",col=rainbow(10),lwd=1:10)
# title(main="Tytul glowny", col.main="red",cex.main=3.2,
#       sub="Podtytul", col.sub="blue", cex.sub=1,
#       xlab="Podpis osi OX", ylab="Podpis osi OY",
#       col.lab="green", cex.lab=0.75) 


