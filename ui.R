library(shiny)
library(shinydashboard)
library(plotly)

dashboardPage(
    dashboardHeader(title = "covid-19"),
    dashboardSidebar(h4("country stats"),
                     p("Data is updated daily from European Centre for 
                       Disease Prevention and Control website (ecdc.europa.eu)."),
        selectInput(
            inputId = "baseCntry", 
                    label = "Choose a country:",
                    choices = sort(setNames(countries$countriesAndTerritories, countries$geoId)))
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
