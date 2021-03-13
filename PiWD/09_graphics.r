#library(png)
#my_image <- readPNG("sgh_logo.png")

library(jpeg)
my_image <- readJPEG("sgh_logo.jpeg")
 
x11()
plot(x=c(-3:3),y=c(-3:3), type="n", main="", xlab="", ylab="")
 
rasterImage(
    my_image, 
    xleft=1.5, xright=3.5,
    ybottom=2.0, ytop=3.5
)

points(
  x=rnorm(10000), 
  y=rnorm(10000),
  pch=16, col=rgb(1,0,0,0.3)
)
