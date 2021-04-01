library(lattice)
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
total <- data.frame()
for (year in c(2013:2021)){
  ret <- getNBPData(year)
  ret <- ret[,grep("data|EUR|USD",colnames(ret))]
  total <- rbind(total, ret)
}

total$data <- as.Date(total$data)

img <- (xyplot(`1USD` + `1EUR` ~ data,
               data=total,
               main="Wykres kursów walut 2013-2021",
               auto.key=list(space="top", lines=T,  points = F, text=c("EUR", "USD")),
               type = "l",
               col.line = c("brown1", "cadetblue"),
               xlab = 'Rok',
               ylab = 'PLN',
               scales = list(x = list(tick.number=10), y = list(tick.number=10))))
x11()
print(img)

# Korzystajac z grupowania danych dostepnego w lattice, wykonac wykres szeregow czasowych
# kursow EUR i USD wzgledem PLN. Wykres powinien posiadac legende, podpisane osie i tytul. 
# Wykres powinien generowac sie takze dla danych z innych lat (od 2013 do 2021).
# Czas na rozwiazanie - do 2021.04.09 23:59:59.
# tytul maila: PiWD/XXXXX/zadanie_02.r, gdzie XXXXX - numer albumu
# Zadanie w formie skryptu zadanie_02.r (rozwiniecie tego skryptu)
# email: mkozak3@sgh.waw.pl