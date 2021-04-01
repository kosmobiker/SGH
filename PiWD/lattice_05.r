rm(list=ls())
library(lattice)

#-----------------------------

mysettings <- trellis.par.get()
print(names(mysettings))
print(mysettings$fontsize$text)
mysettings$fontsize$text <- 20
mysettings$panel.background$col <- "blue"
mysettings$background$col="pink"
mysettings$plot.symbol$col= "red"

wyk <- xyplot(
        dist~speed,data=cars,
        #par.settings=mysettings,
        col.symbol="green",
        pch=16,
        cex=5
        )
x11()
print(wyk)

#-----------------------------
