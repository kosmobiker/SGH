library(shiny)
library(plotly)

# definicja interfejsu 
shinyUI(fluidPage(
  #Nazwa aplikacji  
  titlePanel("PiWD - Projekt zaliczeniowy"),
  
  sidebarLayout(
    
    sidebarPanel(
      h3("Wybierz rok"),
      #pobieranie danych z sieci 
      
      selectInput("selectFirstYear",
                  label = "Od",
                  choices = as.vector(as.character(2021:2010),mode="list")),
      selectInput("selectLastYear",
                  label = "Do",
                  choices = as.vector(as.character(2021:2010),mode="list")),
                  
      #Przegladarka do pobrania danych 
      selectizeInput(inputId = 'selectCurrency',
                     label = "Dostępne waluty",
                     choices = c("THB", "USD", "AUD", "HKD","CAD","NZD",
                                 "SGD","EUR","HUF","CHF","GBP","UAH",
                                 "JPY","CZK","DKK","ISK","NOK","SEK",
                                 "HRK","RON","BGN","TRY",
                                 "ILS","CLP","PHP","MXN","ZAR","BRL",
                                 "MYR","RUB","IDR","INR","KRW","CNY","XDR"),
                     multiple=T, options = list(maxItems = 2)),
      h4("Naciśnij, żeby zgenerować raport"),
      #кнопка с отчетом
      downloadButton("Report","Chcę raport"),
      img(src = "logo-SGH.png")
    ),
    
    mainPanel(
      h3("Uladzislau Darhevich"),
      h5("ud108519@student.sgh.waw.pl"),
      # 5. Panel zakladek  
      tabsetPanel(type = "tabs",
                  tabPanel("Tabela kursów", DT::dataTableOutput("dataSample")),
                  tabPanel("Mapa z walutami", htmlOutput("map")),
                  tabPanel("Szeregi czasowe kursow", plotlyOutput("Timeseries")),
                  tabPanel("Scatter plot", plotlyOutput("Scatter")),
                  tabPanel("Histogram roznic", plotlyOutput("Histogram")),
                  tabPanel("Model regresji liniowej",verbatimTextOutput("Regression"),
                           verbatimTextOutput("TestRainbow"),plotlyOutput("Trend"))
      )
    )
  )
  
))