rm(list=ls())
options(width=250)
#library(colorout)
library(reshape)
library(lattice)


L <- read.table(file="data/PZHGrypaZachorowania.csv",sep=";",dec=",",header=T,stringsAsFactors=F)
#print(head(L))
Z <- read.table(file="data/PZHGrypaZgony.csv",sep=";",dec=",",header=T,stringsAsFactors=F)
#print(head(Z))

daneRobocze <- L[L$Region=="POLSKA",]
#daneRobocze <- Z[Z$Region=="POLSKA",]

daneRobocze[is.na(daneRobocze)] <- 0
daneRobocze$Nr <- gsub("A|B|C|D","",daneRobocze$Nr)
daneRobocze$Nr <- gsub("([0-9]{1}|[0-9]{2})\\(|\\)","",daneRobocze$Nr)
daneRobocze$Nr <- as.integer(daneRobocze$Nr)
daneRobocze <- daneRobocze[order(daneRobocze$Rok,daneRobocze$Nr),]

#print(head(daneRobocze))

colors <- heat.colors(length(unique(daneRobocze$Rok)))
colors[length(colors)] <- "black"

wyk_1 <- xyplot(
 liczba_ogolem~Nr,groups=Rok,data=daneRobocze, type="l",
 col=colors,
 xlab="Tygodnie", ylab="Liczba", main="Grypa - zestawienie roczne",
 abline    = list(v=seq(from=1,to=49,by=4), col="blue", lty=2),
 auto.key  = list(space="right", points=F,lines=F,col=colors)
)
x11()
print(wyk_1)

#----------------------------------------------------------------------
# wyk_1 <- xyplot(
#  liczba_ogolem~Nr,groups=Rok,data=daneRobocze, type="l",
#  xlab="Tygodnie", ylab="Liczba", main="Grypa - zestawienie roczne",
#  abline    = list(v=seq(from=1,to=49,by=3), col="blue", lty=2),
#  auto.key  = list(space="right", points=F,lines=T)
# )
# x11()
# print(wyk_1)
##----------------------------------------------------------------------
tmpData <- daneRobocze
tmpData$Id <- 1:nrow(tmpData)
tmpData <- reshape::melt(tmpData[c("Id","liczba_ogolem","liczba_0_4","liczba_5_14","liczba_15_64","liczba_65_inf")],id.vars="Id")

wyk_2 <- xyplot(
 value~Id,group=variable,data=tmpData, type="l",
 xlab="Tygodnie", ylab="Liczba", main="Grypa - miesieczne szeregi czasowe", lwd=2,
 abline    = list(v=seq(from=1,by=48,length.out=12), col="blue", lty=2),
 auto.key  = list(space="right", points=F,lines=T)
)
x11()
print(wyk_2)
##----------------------------------------------------------------------
tmpData <- daneRobocze
tmpData <- reshape::melt(tmpData[c("Miesiac","liczba_ogolem","liczba_0_4","liczba_5_14","liczba_15_64","liczba_65_inf")],id.vars="Miesiac")
tmpData$Miesiac <- substr(tmpData$Miesiac,1,3)
tmpData$Miesiac <- factor( 
        tmpData$Miesiac, levels=c("sty", "lut", "mar", "kwi", "maj", "cze", "lip", "sie", "wrz", "paz", "lis", "gru") 
)

wyk_3 <- bwplot(
 value~Miesiac|variable,
 data=tmpData,
 fill=heat.colors(12), col=F,
 scales=list(y=list(relation="free"),x=list(rot=45)),
 layout=c(1,5)
)
x11()
print(wyk_3)
##----------------------------------------------------------------------
tmpData <- aggregate(liczba_ogolem~Rok,data=daneRobocze,FUN="sum")
tmpData$Rok <- as.character(tmpData$Rok)

wyk_4 <- barchart(
 liczba_ogolem ~ Rok,
 col=heat.colors(length(unique(tmpData$Rok))),
 data=tmpData
)

tmpData <- daneRobocze
tmpData <- reshape::melt(tmpData[c("Rok","liczba_0_4","liczba_5_14","liczba_15_64","liczba_65_inf")],id.vars="Rok")
tmpData <- aggregate(value~Rok + variable, data=tmpData,FUN="sum")
tmpData$Rok <- as.character(tmpData$Rok)

wyk_5 <- barchart(
 value ~ Rok,
 groups=variable,
 data=tmpData,
 col=c("grey","green","yellow","red"),
 auto.key = list(space="bottom",columns=4,lines=F,points=F,rectangles=F,col=c("grey","green","yellow","red"))
)
x11()
print(wyk_4,split=c(1,1,1,2),more=T)
print(wyk_5,split=c(1,2,1,2),more=F)
#
#----------------------------------------------------------------------
