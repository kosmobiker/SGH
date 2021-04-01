rm(list=ls())
options(width=200)
#library(colorout)
library(lattice)
# trzeba zainstalowac 
library(latticeExtra)


wyk <- barchart(
   Class ~ Freq | Sex + Age,
   data = as.data.frame(Titanic),
   groups = Survived, 
   # kumulowanie danych/zestawienie obok, beside=T/F
   stack = TRUE,
   # rozłożenie dla 
   layout = c(2,2),
   auto.key = list(title = "Ocaleni", columns = 2, space="bottom"),
   scales = list(x = "free")
)
x11()
print(wyk)

x11()
# uwaga na numerację!!!
print(wyk[1,1])

x11()
print(wyk[2,2])

# aktualizacja wykresu
wyk_2 <- update(wyk,
   panel = function(...) {
       #panel.barchart(...)
       panel.barchart(...,border = "transparent")
       panel.grid(h = 10, v = 10)
   }
)
x11()
print(wyk_2)

#library(latticeExtra)
d <- data.frame(x=1:10,y=1:10,z=10:1)
p1 <- xyplot(y~x,data=d,col="green")
p2 <- xyplot(z~x,data=d,col="red")

x11(); plot(p1)
x11(); plot(p2)
x11()
print(p1 + p2)



# wiele wykrsow na jednym obrazku 

w1 <- ts(cumsum(rnorm(100)),freq=12)
w2 <- ts(cumsum(rnorm(100)),freq=12)
w3 <- ts(cumsum(rnorm(100)),freq=12)

px1 <- xyplot(w1,main="1")
px2 <- xyplot(w2,col.line="green",main="2")
px3 <- xyplot(w3,col.line="red",main="3")

x11();plot(px1)
x11();plot(px2)
x11();plot(px3)

# x11()
# plot( wyk,split=c(col, row, ncol, nrow))
# print(wyk,split=c(col, row, ncol, nrow))

x11()
plot(px1,   split=c(1,1,1,3),   more=T)
print(px2,  split=c(1,2,1,3),   more=T)
print(px3,  split=c(1,3,1,3),   more=F)


# (x_0,y_0,x_1,y_1)
x11()
print(px1,  position=c(0, .6, 1, 1), more=TRUE)
print(px2,  position=c(0, 0, 0.5, .6) , more=TRUE)
print(px3,  position=c(0.5, 0, 1, .6) )






