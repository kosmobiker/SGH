rm(list=ls())
library(lattice)
library(latticeExtra)


#--------------------------------------------------------------------------
# osie 
wyk <- xyplot(
   #sqrt(min.temp) + log(max.temp) + precip ~ day | month,
   min.temp + max.temp + precip ~ day | month,
   ylab = "Dane pogodowe",
   data = SeatacWeather, 
   col = c("black","red","blue"), 
   type = c("l", "l", "b"),
   #typ wykresu odpowiednio z type
   distribute.type = !TRUE,
   layout=c(3,1), 
   scales = list(
       #relation = "free", 
       #x = "same", y = "free",
       draw=T,
       log=!T,
       alternating = !F, # relation="same" - podpidu na dole i na przemian
       tick.number = 100 # 5, 100
       )
   )
x11()
print(wyk)

#--------------------------------------------------------------------------

x <- rnorm(400)
y <- rnorm(400)
a <- gl(4, 100)
wyk <- xyplot(y ~ x | a, 
        
        xlab = list("podpis osi ox", cex = 2), ylab = "podpis osi oy", 

        scales=list(
                relation = "free", 
                x=list(
                      at=c(-2, 0, 2), labels=c("x1","x2","x3"),
                      cex=c(0.5), col="orange", rot=45 ),
                y=list(
                      at=c(-2, 0, 2),labels=c("y1","y2","y3")
                )
        ),

        aspect = 1/4, #"fill", "xy",
        #layout = c(4,1),

        key = list(
            # polozenie 
            space="right", 
            #corner = c(1,1),
            #x = 0.2, y = 0.2, 

            title = "Tytul legendy",
            cex.title = 2,
            col= "brown",
            points = list(pch=1:2,col=c("red","blue")),
            text   = list(c('A', 'B'), cex = c(.8, 3), col=c("black","white")),
            lines  = list(lty = 1:2, col=c("white","black")),
            adj=1.0,
#            text=list(c("po A","po B")),
            background = "green", 
            border = "red",  # T/F/color,
            columns = 2
        ),
        main = "Tytul - poziom I",
        sub="Tytul - poziom II"
)

x11()
print(wyk)

#--------------------------------------------------------------------------

