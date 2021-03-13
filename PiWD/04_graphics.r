rm(list=ls())
options(width=200)
#library(colorout)


tmpData <- as.table(as.matrix(data.frame(
    "Kobiety" = c(100,200),
    "Mezczyzni" = c(110,150),
    stringsAsFactors=F    
)))
row.names(tmpData) <- c("TAK","NIE")
names(dimnames(tmpData)) <- c("Odpowiedz","Plec")
print(tmpData)

x11(); assocplot(tmpData, main = "Zestawienie")
x11(); fourfoldplot(tmpData,main = "Zestawienie")
x11(); mosaicplot(tmpData, color = TRUE,main = "Zestawienie")


#--

aaa <- seq(0, pi, length.out =10)
xxx <- rep(aaa, 10)
yyy <- rep(aaa, each=10)
zzz <- sin(xxx) + sin(yyy)
x11();image(matrix(zzz, ncol=10), col=gray(1:12/13))
x11();contour(matrix(zzz, ncol=10), levels=seq(0, 2, .25))

##--
# Dwa jednoczesnie
x11()
x <- 10*(1:nrow(volcano))
y <- 10*(1:ncol(volcano))
image(x, y, volcano, col = terrain.colors(100))
contour(x, y, volcano, levels = seq(90, 200, by = 5), add = TRUE, col = "peru")
box()

##--
x11()
z <- 2 * volcano        
x <- 10 * (1:nrow(z))   
y <- 10 * (1:ncol(z))   
persp(x, y, z, 
      theta = 135, 
      phi = 10, 
      col = "green3", 
      scale = FALSE,
      ltheta = -120, shade = 0.75, 
      box=FALSE)


x11()
aaa <- seq(0, pi, length=10)
xxx <- rep(aaa, 10)
yyy <- rep(aaa, each=10)
zzz <- sin(xxx) + sin(yyy)
symbols(xxx, yyy, circles=zzz, inches=.03)











