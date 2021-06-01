library(shiny)
library(plotly)

# definicja interfejsu 
shinyUI(fluidPage(
  
  # 1. Nazwa aplikacji  
  titlePanel("Uladzislau Darhevich - PiWD - Projekt zaliczeniowy"),
  
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
                     label = "Wybór 2 waluty",
                     choices = c("THB", "USD", "AUD", "HKD","CAD","NZD",
                                 "SGD","EUR","HUF","CHF","GBP","UAH",
                                 "JPY","CZK","DKK","ISK","NOK","SEK",
                                 "HRK","RON","BGN","TRY","LTL","LVL",
                                 "ILS","CLP","PHP","MXN","ZAR","BRL",
                                 "MYR","RUB","IDR","INR","KRW","CNY","XDR"),
                     multiple=T, options = list(maxItems = 2))
      
    ),
    
    mainPanel(
      
      # 5. Panel zakladek  
      tabsetPanel(type = "tabs",
                  tabPanel("Tabela kursów", DT::dataTableOutput("dataSample"))
      )
    )
  )
  
))