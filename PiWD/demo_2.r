rm(list=ls())
options(width=200)

# wczytywanie danych 
dane <- read.table(file="../data/data_pwid/18684_multimulti.csv",sep=";",dec=".",header=T,stringsAsFactors=F)


#>!# 1. Jaki jest wymiar i typ kolumn danych? 
print(head(dane))
print(dim(dane))
print(str(dane))



#>!# 2. Jaka liczba jest najczestsza dla L1?
print(table(dane[,"L1"]))
print(table(dane["L1"]))
print(table(dane$L1))
print(table(dane[,which(colnames(dane)=="L1")]))
print(summary(dane["L1"]))
print(which.max(table(dane$L1)))
print(max(table(dane$L1)))
print(quantile(as.numeric(dane$L1)))



##>!3# mediana L1, L2, L3
print(apply(dane[,grep("^L",colnames(dane))],2,median))



#>!4# mediana L1 dla dane z roku 2017? dane z roku 2016?
print(apply(dane[dane$Rok==2016,grep("^L",colnames(dane))],2,median))
# dane z roku 2017 i miesiaca 3
print(apply(dane[dane$Rok==2017 & dane$Miesiac==10,grep("^L",colnames(dane))],2,median))



# tabela przestawna 
#>!5# Mediany dla wszyskich lat - wynik jako lista  
retList <- lapply(unique(dane$Rok),function(R){
    apply(dane[dane$Rok==R,grep("^L",colnames(dane))],2,median)
})


# z wykorzystaniem split 
retList <- lapply(split(dane,dane$Rok),function(d){
    apply(d[,grep("^L",colnames(d))],2,median)
})



#>!6# Mediany dla wszyskich lat w postaci tabeli  
retList <- lapply(unique(dane$Rok),function(R){
    # formatowanie wyniku do data.frame()
    ret <- as.data.frame(t(apply(dane[dane$Rok==R,grep("^L",colnames(dane))],2,median)))
    ret$Rok <- R
    return(ret)
})

retDF <- do.call("rbind",retList)
print(retDF)

# alternatywa dla do.call
## data.table()
library(data.table)
retDT <- as.data.frame(rbindlist(retList))
print(retDT)


## reshape 
library(reshape)
tmpDane <- reshape::melt(
    #dane[c("Rok",grep("^L",colnames(dane),valu=T))],
    dane[,4:ncol(dane)],
    id.vars="Rok"
    )

retDF_cast <- cast(tmpDane,Rok~variable,fun=median,value="value")
print(retDF_cast)



## Wiele funkcji na zbiorze danych 
##>!7# Srednia, odchylenie, mediana dla kazdego roku (z wszystkich notowan)
retList <- lapply(c("median","mean","sd"),function(f){
    ret <- aggregate(L1~Rok,dane,FUN=f)
    colnames(ret) <- c("Rok",f)
    return(ret)
})

retDF <- Reduce(function(X,Y){merge(X,Y)},retList)
print(retDF)


## 
library(plyr)
retDF <- ddply(
    .data=dane, 
    .variables=.(Rok),
    .fun=summarise,
    "median"=median(L1),
    "mean"=mean(L1),
    "sd" = sd(L1)
)
print(retDF)


## Pipeline
library(tidyverse)
dane %>%
    dplyr::group_by(Rok) %>%
    dplyr::summarise(
        median  =   median(L1),
        mean    =   mean(L1),
        sd      =   sd(L1)
    ) %>%
    data.frame(.,stringsAsFactors=F) -> retDF
print(retDF)

write.table(retDF,file="out.csv",sep=";",dec=".",row.names=F)







