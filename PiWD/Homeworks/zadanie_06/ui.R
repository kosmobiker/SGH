library(shiny)
library(data.table)
library(googleVis)
library(DT)

shinyUI(fluidPage(

    titlePanel("Uladzislau Darhevich - Zadanie 06"),

    sidebarLayout(

        sidebarPanel(
            fileInput("fileInPath", 
                label= h4("Import danych")
            ),

            selectInput("selectYear",
                label = "Rok danych",
                choices = as.vector(as.character(2010:2021),mode="list")
            )
        ),

        mainPanel(
            tabsetPanel(type = "tabs",
                tabPanel("Moja tabela", DT::dataTableOutput("dataSample")),
                tabPanel("Mapa Zachorowań",htmlOutput("view")),
                tabPanel("Liczniki",htmlOutput("gauge"))
            )
        )
    )
))
