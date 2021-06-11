rm(list=ls())
library(shiny)
library(shinyWidgets)
library(data.table)
library(googleVis)
library(tidyverse)
library(ggplot2)
library(plotly)
library(scales)
library(reshape2)
library(shinythemes)
library(lmtest)
library(rmarkdown)
library(knitr)
library(pander)

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
  #first year
  outVar <- reactiveValues(
    selectFirstYearVar = "2021"
  )
  
  observeEvent(input$selectFirstYear,{
    outVar$selectFirstYearVar <- input$selectFirstYear
  })
  
  #last year
  outVar <- reactiveValues(
    selectLastYearVar = "2021"
  )
  
  observeEvent(input$selectLastYear,{
    outVar$selectLastYearVar <- input$selectLastYear
  })
  #waluty
  outVar <- reactiveValues(
    selectCurrency = "USD"
  )

  observeEvent(input$selectCurrency,{
    outVar$selectCurrencyVar <- input$selectCurrency
  })
  
  #read the data
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
  #dane do tworzenia mapy walut
  mapIn <- reactive({
    Country <-  c("Thailand", "United States", "Australia", "Hong Kong", "Canada", "New Zealand",
                  "Singapore", "Hungary", "Switzerland", 
                  "Ukraine", "Japan", "Czech Republic", "Denmark",
                  "Iceland", "Norway", "Sweden", "Croatia", "Romania", "Bulgaria",
                  "Turkey", "Israel", "Chile", "Philippines", "Mexico", "South Africa",
                  "Brazil", "Malaysia", "Russia", "Indonesia", "Indie", "South Korea",
                  "China", "United Kingdom", "Austria", "Belgium", "Cyprus", "Estonia",
                  "Finland", "France", "Grecce", "Spain", "Netherlands", "Ireland", 
                  "Lithuania", "Luxemburg", "Latvia", "Malta", "Germany", "Portugal", 
                  "Slovakia", "Slovenia", "Italy", "Andorra", "Monaco", "Montenegro",
                  "Kosovo", "Poland", "World")
    Currency <-  c("TBH", "USD", "AUD", "HKD",	"CAD",	"NZD",	"SGD", "HUF",	
                   "CHF",	"UAH", "JPY",	"CZK",	"DKK", "ISK",	"NOK", "SEK", "HRK",	
                   "RON",	"BGN", "TRY",	"ILS", "CLP",	"PHP", "MXN",	"ZAR", "BRL",
                   "MYR",	"RUB", "IDR", "INR", "KRW",	"CNY", "GBP", "EUR", "EUR", "EUR",
                   "EUR", "EUR", "EUR", "EUR", "EUR", "EUR", "EUR", "EUR", "EUR", "EUR",
                   "EUR", "EUR", "EUR", "EUR", "EUR", "EUR", "EUR", "EUR", "EUR", "EUR", 
                   "PLN", "XDR")
    
    map_df <- data.frame(Country, Currency) %>% filter(Currency %in% c(outVar$selectCurrencyVar[1],outVar$selectCurrencyVar[2]))
  })
  #Tabela kursów
  output$dataSample <- DT::renderDataTable({
    DT::datatable(  
      dataIn(), 
      rownames = FALSE,
      options = list(
        scrollX = TRUE,
        pageLength = 100,
        lengthMenu = seq(from=10, by=10, to=100) 
      )
    )
  })
  
  #mapa
  output$map <- renderGvis({
    
    gvisGeoChart(mapIn(), locationvar="Country", hovervar="Currency",
                 options=list(
                    width=650, 
                    height=400))
    
    })
  #szereg czasowy
  output$Timeseries <- renderPlotly({
    
    plot.data <- melt(dataIn(), id.vars = "data")
    plot.data$waluty <- substr(plot.data$variable, nchar(as.vector(plot.data$variable)) - 2, nchar(as.vector(plot.data$variable)))
    plot.data <- plot.data[plot.data$waluty %in% c(outVar$selectCurrencyVar[1], outVar$selectCurrencyVar[2]),]
    plot.data$data <- as.Date(plot.data$data)
    ggplot(plot.data) + geom_line(mapping = aes(x = data, y = value,
                                  colour = waluty, group = waluty), size=1)+
                                  scale_x_date(date_labels = "%B") +
                                  ylab("PLN") + 
                                  xlab("Data")
    })
  #scaterplot
  output$Scatter <- renderPlotly({
    
    plot.data <- melt(dataIn(), id.vars = "data")
    plot.data$Waluty <- substr(plot.data$variable, nchar(as.vector(plot.data$variable)) - 2, nchar(as.vector(plot.data$variable)))
    plot.data <- dcast(plot.data, data~Waluty)
    ggplot(plot.data) + 
    geom_point(mapping = aes(x = plot.data[, outVar$selectCurrencyVar[1]], 
                                  y = plot.data[, outVar$selectCurrencyVar[2]], 
                                  size=0.2), color = "orange") +
                                  xlab(outVar$selectCurrencyVar[1]) + 
                                  ylab(outVar$selectCurrencyVar[2])
  })
  #histogram
  output$Histogram <- renderPlotly({
    
    plot.data <- melt(dataIn(), id.vars = "data")
    plot.data$Waluty <- substr(plot.data$variable, nchar(as.vector(plot.data$variable)) - 2, nchar(as.vector(plot.data$variable)))
    plot.data <- plot.data[plot.data$Waluty %in% c(outVar$selectCurrencyVar[1],outVar$selectCurrencyVar[2]), ]
    plot.data1 <- plot.data[plot.data$Waluty %in% outVar$selectCurrencyVar[1], ]
    plot.data2 <- plot.data[plot.data$Waluty %in% outVar$selectCurrencyVar[2], ]
    plot.data$delta <- plot.data1$value-plot.data2$value
    ggplot(plot.data) + geom_histogram(aes(x = delta), col="darkgreen", fill="darkgreen", bins=30, size=0.3) +
                                  xlab("Różnica kursów") +
                                  ylab("Czestosci")
  })
  # regresja
  output$Regression <- renderPrint({
    plot.data <- melt(dataIn(), id.vars = "data")
    plot.data$Waluty <- substr(plot.data$variable, nchar(as.vector(plot.data$variable)) - 2, nchar(as.vector(plot.data$variable)))
    plot.data <- dcast(plot.data, data~Waluty)
    regresja <- lm(plot.data[,outVar$selectCurrencyVar[1]]~plot.data[,outVar$selectCurrencyVar[2]])
    names(regresja$coefficients) <- c("Intercept", outVar$selectCurrencyVar[2])
    summary(regresja)
  })
  #Test Rainbow
  output$TestRainbow <- renderPrint({
    plot.data <- melt(dataIn(), id.vars = "data")
    plot.data$Waluty <- substr(plot.data$variable, nchar(as.vector(plot.data$variable)) - 2, nchar(as.vector(plot.data$variable)))
    plot.data <- dcast(plot.data, data~Waluty)
    regresja <- lm(plot.data[, outVar$selectCurrencyVar[1]]~plot.data[,outVar$selectCurrencyVar[2]])
    raintest(regresja)
  })
  #Dodanie regresji przez Plotly
  output$Trend <- renderPlotly({
    plot.data <- melt(dataIn(), id.vars = "data")
    plot.data$Waluty <- substr(plot.data$variable, nchar(as.vector(plot.data$variable)) - 2, nchar(as.vector(plot.data$variable)))
    plot.data <- dcast(plot.data, data~Waluty)
    img <- ggplot(plot.data, aes(x = plot.data[, outVar$selectCurrencyVar[2]], 
                                 y = plot.data[, outVar$selectCurrencyVar[1]])) +
            geom_point(colour="green") +
            stat_smooth(method = "lm", colour="red")+
            ylab(outVar$selectCurrencyVar[1]) +
            xlab(outVar$selectCurrencyVar[2])
    ggplotly(img)
  })
  output$Report <- downloadHandler(
    filename = "raport.html",
    content = function(file) {
      tempReport <- file.path(tempdir(), "report.Rmd")
      file.copy("report.Rmd", tempReport, overwrite = TRUE)
      
      # Set up parameters to pass to Rmd document
      params <- list()
      params$cur1 <- outVar$selectCurrencyVar[1]
      params$cur2 <- outVar$selectCurrencyVar[2]
      params$mapka <- mapIn()
      params$dane <- dataIn()
      
      if(file.exists("Raport.html")) unlink("Raport.html")
      if(file.exists("params")) unlink("params")
      if(dir.exists("cache")) unlink("cache",recursive = T, force = T)
      
      save(params,file="params")
      
      library(knitr)
      library(markdown) 
      library(rmarkdown)
      
      knit(input='report.rmd', output="tmp.md",envir=new.env())
      markdownToHTML(file="tmp.md", output="Raport_final.html")
      
      unlink("tmp.md")      
      unlink("params") 
    }) 
      
})
