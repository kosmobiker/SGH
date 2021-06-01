library(shiny)
# 20 - biblioteka plotly 
library(plotly)

# definicja interfejsu 
shinyUI(fluidPage(
  
  # 1. Nazwa aplikacji  
  titlePanel("Это проект"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      # 9. pobieranie danych z sieci 
      
      selectInput("selectFirstYear",
                  label = "Od",
                  choices = as.vector(as.character(2021:2010),mode="list")),
      selectInput("selectLastYear",
                  label = "Do",
                  choices = as.vector(as.character(2021:2010),mode="list")),
                  
    
      # 2. Przegladarka do pobrania danych 
      selectizeInput(inputId = 'selectCurrency',
                     label = "Wybór 2 walut do analizy",
                     choices = c("THB", "USD", "AUD", "HKD","CAD","NZD",
                                 "SGD","EUR","HUF","CHF","GBP","UAH",
                                 "JPY","CZK","DKK","ISK","NOK","SEK",
                                 "HRK","RON","BGN","TRY","LTL","LVL",
                                 "ILS","CLP","PHP","MXN","ZAR","BRL",
                                 "MYR","RUB","IDR","INR","KRW","CNY","XDR"),
                     multiple=T, options = list(maxItems = 2)),
      #get data from server
      actionButton("getDataFromServer", "Pobierz dane"),
      # 7. export wynikow 
      
      downloadButton("fileOutPath",
                     label = "Eksport danych"
      )
      
    ),
    
    mainPanel(
      
      # 5. Panel zakladek  
      tabsetPanel(type = "tabs",
                  
                  tabPanel("test1rok",verbatimTextOutput("plainText1")),
                  tabPanel("test2rok",verbatimTextOutput("plainText2")),
                  tabPanel("test3cur",verbatimTextOutput("plainText3")),
                  tabPanel("Moja tabela", DT::dataTableOutput("dataSample"))
                  
      )
      
      
    )
    
    
  )
  
))