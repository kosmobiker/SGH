rm(list=ls())
library(lattice)

#-----------------------------

wyk <- xyplot(dist~speed,data=cars,
         panel = function(...) {
           panel.xyplot(...,col.symbol="red",type=c("b","l"),col.line="orange")
           #panel.xyplot(...,type="r",col.line = "black")
           #panel.abline(a=0,b=1,col.line="blue")
           #panel.abline(a=0,b=2,col.line="pink")
           #panel.abline(h=10,col.line="grey")
           #panel.text(x=15,y=50,labels="lattice",col="red",cex=2)
           #panel.text(x=cars$speed-0.3,y=cars$dist-1,labels=1:nrow(cars))
         }
         
)
x11();print(wyk)

#-----------------------------

wyk <- histogram(~ dist, data = cars ,
         type = "density",
         panel=function(x) {
            panel.histogram(x, breaks=10, col="yellow")
            panel.densityplot(x,col.line="red",col.symbol="blue")
     })
x11()
print(wyk)




#-----------------------------
# wielokaty

p <- xyplot(1 ~ 1,
            xlim = c(0, 1),
            ylim = c(0, 1),
            panel = function(x, y, ...) {

               panel.polygon(x = c(0.25, 0.75, 0.75, 0.25),
                             y = c(0, 0, 0.50, 0.50), 
                            border = NA,
                            col = "yellow"
              )
            }
)

x11()
print(p)

#-----------------------------










