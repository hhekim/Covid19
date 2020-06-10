library(shiny)
library(shinydashboard)
library(plotly)

dashboardPage(
    dashboardHeader(title = "covid-19"),
    dashboardSidebar(h4("country stats"),
                     p(HTML(paste0("Data is updated daily from European Centre for 
                       Disease Prevention and Control website (ecdc.europa.eu). 
                       You can find the code at ", a(href="https://github.com/hhekim/Covid19-Country-Stats", "Github")))),
        selectInput(
            inputId = "baseCntry", 
                    label = "Choose a country:",
                    choices = sort(setNames(countries$geoId,countries$countriesAndTerritories)))
    ),
    dashboardBody(fluidRow(
        valueBoxOutput("casesbox", width = 3),
        valueBoxOutput("deathsbox", width = 3),
        valueBoxOutput("caseper1000box", width = 3),
        valueBoxOutput("deathper100casebox", width = 3)
    ),
    fluidRow(
        tabBox(width=12, height = "650px",
            id = "tabset1",
            tabPanel("World", plotlyOutput("world", height = "550px")),
            tabPanel("Top 15 Cases", plotlyOutput("top15cases", height = "550px")),
            tabPanel("Top 15 Deaths", plotlyOutput("top15deaths", height = "550px")),
            tabPanel("Top 15 Case/Deaths", plotlyOutput("top15cd", height = "550px")),
            tabPanel("Top 15 Cases Boxplot", plotlyOutput("top15casesbox", height = "550px")),
            tabPanel("Top 15 Deaths Boxplots", plotlyOutput("top15deathssbox", height = "550px"))
        )
        )
    )
)
