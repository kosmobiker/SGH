library(dplyr)
library(shiny)
library(data.table)
library(googleVis)
library(DT)

shinyServer(function(input, output) {

    outVar <- reactiveValues(
        selectYearVar = "2021"
    )
    
    observeEvent(input$selectYear,{
      outVar$selectYearVar <- input$selectYear
    })

    dataIn <- reactive({
        try({
            d <- (
              read.table(file=input$fileInPath$datapath,
                sep=";",dec=",",header=T, stringsAsFactors=FALSE, encoding = 'UTF-8')
            )

            d <- d[c("Rok","Region","liczba_ogolem")]
            d <- d[d$Region!="POLSKA",]
            d$Region <- tolower(d$Region)
            d <- aggregate(liczba_ogolem~Rok+Region,data=d,FUN="sum")
            colnames(d)[3] <- "Liczba"
            d <- d[order(d$Rok,d$Region),]
            d <- d[as.character(d$Rok)==as.character(outVar$selectYearVar),]
 
            return(d)
        },silent=T)
        return(data.frame())
    })

    
      output$dataSample <- DT::renderDataTable({
          DT::datatable(  
                      dataIn(), 
                      rownames = FALSE,
                      options = list(
                          scrollX = TRUE,
                          pageLength = 16,
                          lengthMenu = seq(from=2,by=2,to=16) 
                        )
        )
    })
    

    # output$dataSample <- renderTable({
    #     return(dataIn())
    # })
    
    output$view <- renderGvis({
      
      gvisGeoChart(dataIn(), locationvar="Region", colorvar="Liczba",
                   options=list(region="PL",
                                displayMode="regions",
                                resolution="provinces",
                                width=650, height=650))
    })
    
    output$gauge <- renderGvis({
      
      gvisGauge(dataIn() %>% select(Region, Liczba),labelvar="Region", numvar="Liczba",
                options=list(min=min(dataIn()$Liczba), max=max(dataIn()$Liczba),
                             greenFrom=min(dataIn()$Liczba),greenTo=0.33*max(dataIn()$Liczba),
                             yellowFrom=0.33*max(dataIn()$Liczba), yellowTo=0.66*max(dataIn()$Liczba),
                             redFrom=0.66*max(dataIn()$Liczba), redTo=max(dataIn()$Liczba),
                             width=800, height=800))
    })
    
})    