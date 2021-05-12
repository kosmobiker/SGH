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
ret <- getNBPData(2021)
ret <- ret[,grep("data|EUR|USD|GBP",colnames(ret))] 


#print(head(ret))
#print(tail(ret))

# Zadanie za 2 pkt.
# Napisac raport zadanie_05.Rmd, ktory:
# -- bedzie mial tytul, autora, date wykonania,
# -- bedzie zawieral wykres kursow USD, EUR, GBP. Wykres ma zawierac dane za ostatnie 7 dni!!! Wykres ma znajdowac sie w osobnym rozdziale raportu,
# -- bedzie zawieral tabele z notowaniami tych trzech kursow walut. Tabelka ma zawierac sie w osobnym rozdziale raportu.

# Czas na rozwiazanie - do 2021.05.28 23:59:59.
# tytul maila: PiWD/XXXXX/zadanie_05, gdzie XXXXX - numer albumu
# Zadanie w formie skryptu zadanie_05.Rmd
# email: mkozak3@sgh.waw.pl






                                                                                    
