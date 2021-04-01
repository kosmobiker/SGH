rm(list=ls())

# L <- read.table(
#    file="../data/data_pwid/PZHGrypaZachorowania.csv",
#    sep=";",
#    dec=",",
#    header=T,
#    stringsAsFactors=F,
#    encoding = 'UTF-8')

L <- read.table(
   file="data/PZHGrypaZachorowania.csv",
   sep=";",
   dec=",",
   header=T,
   stringsAsFactors=F,
   encoding = 'UTF-8')

daneRobocze <- L[L$Region=="POLSKA",]

daneRobocze$Nr <- gsub("A|B|C|D","",daneRobocze$Nr)
daneRobocze$Nr <- gsub("([0-9]{1}|[0-9]{2})\\(|\\)","",daneRobocze$Nr)
daneRobocze$Nr <- as.integer(daneRobocze$Nr)

lata <- sort(unique(daneRobocze$Rok))
daneRobocze <- daneRobocze[order(daneRobocze$Rok,daneRobocze$Nr) , ]


 x11()
 plot(daneRobocze$liczba_ogolem,
   type="l", lwd=2, col="black",
   axes=F,
   main="Grypa - szeregi czasowe w podziela na segmenty wiekowe",
   xlab="Tygodnie", ylab="Liczba przypadkow"
 )
 lines(daneRobocze$liczba_0_4,col="grey",lwd=2)
 lines(daneRobocze$liczba_5_14,col="green",lwd=2)
 lines(daneRobocze$liczba_15_64,col="yellow",lwd=2)
 lines(daneRobocze$liczba_65_inf,col="red",lwd=2)

 axis(1, at=c(1,which(diff(daneRobocze$Rok)==1))+24, labels=lata)
 axis(2)

 abline(v=c(1,which(diff(daneRobocze$Rok)==1)+1),lty=2,col="blue")

 mtext("Zrodlo danych: PZH",side=4,line=0,adj=0)
 mtext("http://wwwold.pzh.gov.pl/oldpage/epimeld/grypa/index.htm",side=4,line=1,adj=0)

  legend(
    "topleft",
    c("liczba_ogolem","liczba_0_4","liczba_5_14","liczba_15_64","liczba_65_inf"),
    fill=c("black","grey","green","yellow","red"),
   box.lwd = 0, box.col="white",
   bg = "white"
 )

 pieData <- apply(daneRobocze[c("liczba_0_4","liczba_5_14","liczba_15_64","liczba_65_inf")],2,sum)
#  pieLabs <- names(pieData)
 pieLabs <- round(100*pieData/sum(pieData),2)
 pieLabs <- paste0(gsub("_","-",gsub("liczba_","",names(pieLabs))),"  (",as.numeric(pieLabs),"%)")


 x11()
 pie(
   pieData,
   col=c("grey","green","yellow","red"),
   main="Rozklad",
 #  radius=1.0,
   clockwise=T,
   init.angle=90,
   labels = ""
   )

 mtext("Zrodlo danych: PZH",side=4,line=0,adj=0)
 mtext("http://wwwold.pzh.gov.pl/oldpage/epimeld/grypa/index.htm",side=4,line=1,adj=0)
 legend("topright",
   pieLabs,
   fill=c("grey","green","yellow","red"),
   bty="n"
   )


 colors <- heat.colors(length(lata))
 colors[length(colors)-1]  <- "gray40"
 colors[length(colors)]    <- "gray0"
 #print(head(daneRobocze))

 xlim <- range(daneRobocze$Nr)
 ylim <- range(daneRobocze$liczba_ogolem)

 lapply(split(daneRobocze,daneRobocze$Rok),function(tmpD){

   if(min(tmpD$Rok)==min(daneRobocze$Rok)){

     x11()
     plot(
       x=tmpD$Nr,
       y=tmpD$liczba_ogolem,
       xlim = xlim, ylim = ylim,
       col=colors[tmpD$Rok-2010+1],type="l",
       xlab = "Tygodnie", ylab = "Liczba",
       lwd=2,
       axes=F
     )

   }else{

     lines(
       x=tmpD$Nr,
       y=tmpD$liczba_ogolem,
       col=colors[tmpD$Rok-2010+1],
       lwd=2
     )

   }

 })

 axis(1, at=seq(from=1,to=48,by=4)+2, labels=c("I","II","III","IV","V","VI","VII","VIII","IX","X","XI","XII") )
 axis(2)
 abline(v=seq(from=1,to=60,by=4),col="blue",lty=2)
 title(main=paste0("Grypa - zestawienie danych tygodniowych z lat ",min(daneRobocze$Rok),"-",max(daneRobocze$Rok)))
 mtext("Zrodlo danych: PZH",side=4,line=0,adj=0)
 mtext("http://wwwold.pzh.gov.pl/oldpage/epimeld/grypa/index.htm",side=4,line=1,adj=0)
 legend("topright",
        legend=as.character(sort(unique(daneRobocze$Rok))),lty=1,col=colors,
        #box.lwd = 0 ,
        bg = "white"
        )

#
#
#
##-------------------------------------------------------------------------
##-------------------------------------------------------------------------
##-------------------------------------------------------------------------

## wskazowka - barplot
bardata <- aggregate(daneRobocze[c("liczba_0_4","liczba_5_14","liczba_15_64","liczba_65_inf")], 
                      by=list(daneRobocze$Rok), 
                      sum)
 
rownames(bardata) <- bardata$Group.1
bardata = subset(bardata, select = -Group.1)
x11()
par(mfrow = c(2, 1))
barplot(liczba_ogolem~Rok, aggregate(liczba_ogolem~Rok,daneRobocze,sum), 
        axes=F,ylab="Liczba przypadkow",xlab="Rok",
        col=colors)
axis(2)
title(main=paste0("Grypa - zestawienie danych tygodniowych z lat ",min(daneRobocze$Rok),"-",max(daneRobocze$Rok)))

barplot(t(as.matrix(bardata)), beside = T,
        axes=F,ylab="Liczba przypadkow",xlab="Rok",
        col = c("grey", "green", "yellow", "red"))
axis(2)

mtext("Zrodlo danych: PZH",side=4,line=0,adj=0)
mtext("http://wwwold.pzh.gov.pl/oldpage/epimeld/grypa/index.htm",side=4,line=1,adj=0)

legend(
   "topleft",
   c("liczba_0_4","liczba_5_14","liczba_15_64","liczba_65_inf"),
   fill=c("grey","green","yellow","red"),
   box.lwd = 0, box.col="white",
   bg = "white",
   cex = 0.7,
   inset = 0.02
)
dev.copy2pdf(file = "output4.pdf")


## wskazowka - boxplot

month <- factor(daneRobocze$Miesiac,
               levels=unique(daneRobocze$Miesiac))

x11()
layout(matrix(c(1,1,2,3,4,5), 3, 2, byrow = TRUE))
boxplot(daneRobocze$liczba_ogolem~month,
        col=colors, frame=F,
        xlab='',
        ylab='')
mtext("Ogolem", side=1, line=-9, cex=0.75,font=2)
boxplot(daneRobocze$liczba_0_4~month,
        col=colors,frame=F,
        main="0-4",
        xlab='',
        ylab='')
boxplot(daneRobocze$liczba_5_14~month,
        col=colors, frame=F,
        main="5-14",
        xlab='',
        ylab='')
boxplot(daneRobocze$liczba_15_64~month,
        col=colors, frame=F,
        main="15-64",
        xlab='',
        ylab='')
boxplot(daneRobocze$liczba_65_inf~month,
        col=colors, frame=F,
        main="65-Inf",
        xlab='',
        ylab='')
mtext("Grypa - zestawienie danych tygodniowych z lat 2010-2021", side = 3, line = -2, outer = TRUE, font=2)
mtext("Zrodlo danych: PZH",side=4,line=0,adj=0, cex=0.75)
mtext("http://wwwold.pzh.gov.pl/oldpage/epimeld/grypa/index.htm",side=4,line=1,adj=0, cex=0.75)
dev.copy2pdf(file = "output5.pdf")