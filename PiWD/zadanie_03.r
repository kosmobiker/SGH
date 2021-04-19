getNBPData <- function(year=2021){
    
  ret <- data.frame()

  if(year>=2013){

    fileName <- paste0(year,"_NBP_data.csv")
  
    try({
      if(file.exists(fileName)){
        if(as.Date(file.info(fileName)$mtime)==Sys.Date()){
          cat(paste("Reading data from local file\n"))
          ret<-read.table(file=fileName,sep=";",dec=",",header=T,stringsAsFactor=F)
    	  colnames(ret) <- gsub("X","",colnames(ret))
	  return(ret)
	}
      }
    })
  
    cat(paste("Downloading data\n"))
  
    res <- try({
  
      d <- readLines(paste0("https://www.nbp.pl/kursy/Archiwum/archiwum_tab_a_",year,".csv"))
      d <- d[-2]
      d <- d[-c((length(d)-3):length(d))]
      tmpColnames <- strsplit(d[1],";",useBytes=T)[[1]]
      tmpColnames <- tmpColnames[-c((length(tmpColnames)-1):length(tmpColnames))]
      d <- do.call("rbind",
        lapply(strsplit(d[-1],";"),
        function(x){
          matrix(as.numeric(gsub(",",".",x[-c((length(x)-1):length(x))])),nrow=1)
        })
      )
      colnames(d) <- tmpColnames
      d <- as.data.frame(d)
      
      d$data <- as.Date(as.character(d$data),format="%Y%m%d")
      ret <- d
      write.table(ret,file=fileName,sep=";",dec=",",row.names=F)
    
    },silent=T)
  
    if(inherits(res,"try-error")){
      cat(paste("An error occurred while downloading data!!!\n")) 
    }
  

  }

  return(ret)

}
#--------------------------------------
ret <- getNBPData(2017)
ret <- ret[,grep("data|EUR|USD|GBP",colnames(ret))] 

#print(head(ret))
#print(tail(ret))


# img <- (
#   ggplot(ret,...)
#   
# )
# x11()
# print(img)

# Zadanie za 2 pkt.
# Korzystajac z grupowania danych dostepnego w ggplot, wykonac dwa wykresy szeregow czasowych
# kursow EUR, USD, GPB wzgledem PLN. Wykres pierwszy powinien posiadac legende, podpisane osie i tytul.
# Powinien byc wykresem zbiorczym - w ramach jednego ukladu wspolrzednych.
# Wykres drugi powiniem przedstawiac kursy walut w ramach trzech osobnych ukladow wspolrzednych o 
# dobranych dla kursow osiach OY. 
# Wykresy powinien generowac sie takze dla danych z innych lat (od 2013 do 2021).
# Czas na rozwiazanie - do 2021.04.30 23:59:59.
# tytul maila: PiWD/XXXXX/zadanie_03.r, gdzie XXXXX - numer albumu
# Zadanie w formie skryptu zadanie_03.r (rozwiniecie tego skryptu)
# email: mkozak3@sgh.waw.pl




                                                                                    
