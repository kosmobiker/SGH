rm(list=ls())

x = 0:10;  
y = 0:10;  
  
x11()
op <- par(
      mar=c(14,14,4,4),  
      oma=c(5,5,2,2), 
      bg="black"
)   

plot(x, y, type="n", xlab="X", ylab="Y")   
  
text(5,5, "Plot", col="red", cex=2)  
grid(nx=20,ny=50)
box("plot", col="red")  
  
mtext("Margin: Line_2", side=3, line=2, cex=1, col="green")  
mtext("Line_1", side=3, line=1, col="green")  
mtext("Line 0", side=3, line=0, adj=1.0, col="green")  
#mtext("Line 1", side=3, line=1, adj=1.0, col="green")  
#mtext("Line 2", side=3, line=2, adj=1.0, col="green")  
mtext("Line 0", side=2, line=0, adj=1.0, col="green")  
#mtext("Line 1", side=2, line=1, adj=1.0, col="green")  
#mtext("Line 2", side=2, line=2, adj=1.0, col="green")  
box("figure", col="green")  
  
mtext("Outer Margin: Line_1", side=1, line=1, col="blue", outer=TRUE)  
mtext("Line_2", side=1, line=2, col="blue", outer=TRUE)  
mtext("Line 0", side=1, line=0, adj=0.0, col="blue", outer=TRUE)  
#mtext("Line 1", side=1, line=1, adj=0.0, col="blue", outer=TRUE)  
#mtext("Line 2", side=1, line=2, adj=0.0, col="blue", outer=TRUE)  

box("outer",col="red")  

par(op)


##############################################################################
##############################################################################
##############################################################################
x <- rnorm(100)

x11()
op <- par(bg = "pink")
plot(x,type="n")
rect(
    par("usr")[1], 
    par("usr")[3], 
    par("usr")[2], 
    par("usr")[4], 
    col = "yellow")
points(x,col="green",pch=16)
par(op)


