rm(list=ls())
library(lattice)

#-----------------------------------
# Graphics ~ Lattice
x11() 
graphics::plot(
          dist~speed,
          data=cars,
          pch=3,
          main="Graphics!!!",
          col="red")

wyk <- xyplot(
   dist~speed,
   data=cars,
   pch=3,
   main="Lattice!!!",
   col.symbol="red",
)
x11()
#print(wyk)
plot(wyk)   

#-----------------------------------


## graph_type(formula, data=) 
# > ? panel.xyplot

wyk <- xyplot(
    dist~speed,
    data=cars,
      type=c("p","a"),
#    #   type=c("p", "l", "h", "b",
#    #        #"s", "S", "r", "a", "g","smooth","spline")
      col.symbol="red",
      col.line = "blue",      
      pch=3,
      lwd=3,
      lty=3,
      main="Lattice !!!"
)
x11()
plot(wyk)


wyk <- histogram(
    ~dist,
    data=cars,
    col=rgb(1,0,0,0.5),
    breaks=10,
    #type="percent"
    type="count"
    )
x11()
print(wyk)


x11()
wyk <- densityplot(~dist,data=cars, plot.points=F)
print(wyk)


# wyk <- dotplot(
#     dist~speed,
#    data=cars,
#    col="blue",
#    pch=1
#    )
# x11()
# print(wyk)


wyk <- barchart(
   dist~speed,
   data=cars,
   horizontal=F,
   col=c("grey")
   )
x11()
print(wyk)


# boxplot
wyk <- bwplot(
   dist~speed,
   data=cars,
   fill="darkorange2",
   col=F,
   horizontal=F)
x11()
print(wyk)


N <- 25
x <- pi*(-N:N)/N
y <- pi*(-N:N)/N
data <- expand.grid(x=x,y=y)

data$z <- (1-data$x*data$y)^2*sin(data$x)*sin(data$y)
print(head(data))

wyk <- wireframe(z~x*y,data) #,drape=T
x11(); print(wyk)

# wyk <- cloud(z~x*y,data)
# x11();print(wyk)

wyk <- levelplot(z~x*y,data)
x11();print(wyk)

wyk <- contourplot(z~x*y,data)
x11();print(wyk)


#-----------------------------
print(head(mtcars))
print(unique(mtcars$cyl))
wyk <- parallelplot(~mtcars[c("mpg", "disp","qsec","gear")] | factor(cyl),
                    mtcars, groups = carb, layout = c(3, 1),
                    auto.key = list(space = "top", columns = 3))
x11()
print(wyk)

#-----------------------------


wyk <- xyplot(
  dist~speed,
   data=cars,
   grid=list(h=-1,v=-1),#h=0,v=20),#h = 20, v = -1),
   type = c("p","a"),
   col.symbol="red",
   col.line = "blue",
   pch=0:25,
   lwd=2,
   lty=3,
   abline = list(
          #c(a = 0, b = 2), col="orange", lwd=4
          #v = 10, col="orange", lwd=4
          #h = c(1:10)*3, col="orange", lwd=2,lty=2
          ),
   main = "Ala ma kota"
   )
x11()
print(wyk)



# grupowanie 
wyk <- xyplot(disp~mpg,data=mtcars)
x11();print(wyk)

wyk <- xyplot(disp~mpg,
              groups=gear,
              data=mtcars,
              pch=16#,
              #type=c("p","r") #c("p","r")
              #,
              #col.symbol=c("red","blue","green"),
              #col.line=c("red","blue","green")
              )  #
x11();print(wyk)

wyk <- xyplot( disp~mpg | gear,data=mtcars, type=c("p","r"))
x11();print(wyk)


# grupowanie dla wiekszego zbioru danych
X <- do.call("rbind",
   lapply(1:5,function(i){
       data.frame(x=rnorm(500,i,0.5),y=rnorm(500,i,1.5-i*0.25))
   })
)

X <- do.call("rbind",lapply(1:5,function(i){
   X$y <- (1+runif(1))*X$y + runif(1,0,10)
   X$grupa = as.character(i)
   return(X)
}))

print(head(X,3))

wyk <- xyplot(y~x,X,type=c("p","r"))
x11();print(wyk)

wyk <- xyplot(y~x|grupa,X,type=c("p","r"))
x11();print(wyk)

wyk <- xyplot(y~x, groups=grupa,X,type=c("p","r"))
x11();print(wyk)

wyk <- xyplot(y~x|grupa,groups=grupa,X,type=c("p","r"))
x11();print(wyk)


# wyk <- histogram(disp~mpg|gear,data=mtcars)
# x11()
# print(wyk)
#  
# wyk <- histogram(disp~mpg,group=gear,data=mtcars)
# x11()
# print(wyk)


wyk <- xyplot(y~x,X,
              group=grupa,
              main="Moje dane",type=c("p","r"),
       auto.key = list(
                space="top", # "right","left","top","bottom"
                columns = 2, 
                points = !F,
                lines = !F,
                rectangles = !F)
)

x11()
print(wyk)











