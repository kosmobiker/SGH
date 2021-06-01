library(shiny)
library(ggplot2)
# 17 - biblioteka plotly 
library(plotly)

#funkcja do pobrania csv plikóW
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

# czesc obliczeniowa
shinyServer(function(input, output) {
  
  outVar <- reactiveValues(
    selectFirstYearVar = "2021"
  )
  
  observeEvent(input$selectFirstYear,{
    outVar$selectFirstYearVar <- input$selectFirstYear
  })
  
  
  outVar <- reactiveValues(
    selectLastYearVar = "2021"
  )
  
  observeEvent(input$selectLastYear,{
    outVar$selectLastYearVar <- input$selectLastYear
  })
  
  outVar <- reactiveValues(
    selectCurrency = "USD"
  )
  
  observeEvent(input$selectCurrency,{
    outVar$selectCurrencyVar <- input$selectCurrency
  })
  
  # 11. akcja przycisku 
  dataIn <- reactive({

      data_str = paste("data|", outVar$selectCurrencyVar[1], "|", outVar$selectCurrencyVar[2], sep='')
      
      total <- data.frame()
      for (year in seq(outVar$selectFirstYearVar, outVar$selectLastYearVar)){
          ret <- getNBPData(year)
          ret <- ret[,grep(data_str,colnames(ret))]
          total <- rbind(total, ret)
        }  
      
      return(total)
})  
  
  
  
  
  output$dataSample <- DT::renderDataTable({
    DT::datatable(  
      dataIn(), 
      rownames = FALSE,
      options = list(
        scrollX = TRUE,
        pageLength = 100,
        lengthMenu = seq(from=10,by=10,to=100) 
      )
    )
  })
  
  
  
  output$plainText1 <- renderPrint({
    return(outVar$selectFirstYearVar)
  })
  output$plainText2 <- renderPrint({
    return(outVar$selectLastYearVar)
  })
  output$plainText3 <- renderPrint({
    return(outVar$selectCurrencyVar)
  })
})
