rm(list=ls())
#options(width=200)

###########################################################################################
## hist - podstawy 
x11()
hist(
    cars[,1],
    breaks=10, 
    col=c("grey","green","yellow"),
    freq=F,
    # density=40,
    # angle=15,
    border="red",
    xlab="cars"
)

lines(
    density(cars[,1]),
    col="red",
    lwd=4)

# x11()
# d <- density(cars[,1])
# plot(d)
# polygon(d, col="red", border="blue")

### hist 2 
x11()
h2<-rnorm(1000,4)
h1<-rnorm(1000,8)
hist(h1, 
     col=rgb(1,0,0,0.5), 
     xlim=c(range(c(h1,h2))), #ylim=c(0,200), 
     main="Dwa rozklady")
hist(h2, 
     col=rgb(0,0,1,0.5), add=T)

###########################################################################################
# barplot
x11()
counts <- table(cars[,1])
barplot(
  counts,
  col = "red",
  horiz = F
)


x11()
op <- par(mfrow=c(1,2))
    barplot(
      counts,
        col = counts %% 5,
        horiz = F
    )

    barplot(
      counts,
        col = counts %% 5,
        horiz = T
    )
par(op)



counts <- table(mtcars$vs, mtcars$gear)
x11()
op <- par(mfrow=c(2,1))
    barplot(counts, 
        main="mtcars - beside=F",
        xlab="Gears", col=c("blue","red"),
        legend = rownames(counts)
    ) 

    barplot(counts, 
        main="mtcars - beside=T",
        xlab="Gears", col=c("blue","red"),
        legend = rownames(counts),
        beside=T
    ) 
par(op)


###########################################################################################
# boxplot
x11()
boxplot(
  dist~speed,
  data=cars,
  #col=rainbow(4),
  xlab="speed",
  ylab="dist"
) 

tmpList <- lapply(split(cars,cars$speed),function(d){d$dist})

x11()
op <- par(mfrow=c(2,2))
    boxplot(tmpList,xlab="speed",ylab="dist",col=c("gold","darkgreen")) 
    boxplot(tmpList,xlab="dist",ylab="speed",col=c("gold","darkgreen"),horizontal=T) 
    
    boxplot(tmpList,xlab="speed",ylab="dist",col=c("gold","darkgreen"),varwidth=T) 
    boxplot(tmpList,xlab="speed",ylab="dist",col=c("gold","darkgreen"),notch=T) 
par(op)

###########################################################################################
## pie 

x11()
pie(table(cars$speed),
    col=rainbow(max(cars$speed)))

x11(); pie(
    table(cars$speed),
    # edges=50,#length(unique(cars$speed)),
    # radius=1.05, 
    # clockwise = !TRUE, 
    # init.angle = 0,
    # density = 50, 
    # angle = 30,
    # border = "orange2",
    col=rainbow(max(cars$speed))
)


############################################################################################
## Polygon 
#
x11()
alpha <- c(0:6)*(2*pi/6)

x <- cos(alpha)
y <- sin(alpha)

x11()
plot(x,y,type='l')
polygon(x,y,col="blue",border="red",lwd=3)

####
x11()
x <- c( 0, 1, 1, 0, 0)
y <- c( 0, 0, 1, 1, 0)

plot(x,y,type='l', xlim=c(-3,3), ylim=c(-5,5))
polygon(x,y,col=rgb(1,0,1,1),border="red",lwd=3)



x11()
op <- par(mfrow=c(3,3))
lapply(1:9,function(i){

    plot(x,y,main=paste0("alpha=",i/10)) 
    polygon(x,y,col=adjustcolor("blue", alpha=i/10),border="red",lwd=3)

})
par(op)


############################################################################################
## curve 
#
# 1:10 <-> seq(from=1,to=10,by=1)

x <- seq(from=(-2*pi),to=2*pi,by=0.1)
y <- sin(x)
x11()
plot(x,y,type="l")

x11()
curve(sin, -2*pi, 2*pi, xname = "t")

myFun <- function(x){
    return(sin(2*x)/(1+x^2))
}

x11();
curve(myFun,from=-10,to=10,n=10000)


############################################################################################
## scatterplot 

n <- 10000
x1  <- matrix(rnorm(n), ncol = 2)
x2  <- matrix(rnorm(n, mean = 4, sd = 1.4), ncol = 2)
x   <- rbind(x1, x2)

x11()
op <- par(mfrow=c(1,2))
    plot(x,pch=16,col=rgb(0,0,1,0.2),cex=1.5)
    smoothScatter(x)
    #    smoothScatter(x, colramp = colorRampPalette(c("white", "red")))
par(op)



