
library(shiny)
library(leaflet)
library(plotly)

vars <- c(
    "Confirmed cases" = "Confirmed",
    "Deaths" = "Deaths",
    "Recovered" = "Recovered"
)

per <- c(
    "All" = "all",
    "3 Months" = "three_months",
    "1 Month" = "one_month",
    "15 Days" = "fifteen_days"
)

navbarPage("CoronaVirus", id="nav", 
           tabPanel("WorldMap",
                    div(class="outer",
                        tags$head(
                            HTML('<meta name="viewport" content="width=1024">'),
                            includeCSS("styles.css")
                        ),
                        leafletOutput("map", width="100%", height="100%"),
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                      width = 350, height = "auto",
                                      
                                      h2("Tap on a country"),
                                      
                                      selectInput("type", "Stat Type", vars),
                                      selectInput("period", "Time Period", per),
                                      plotlyOutput("country", width = 300, height = 400)
                                      ),
                        tags$div(id="cite",
                                 'Data is compiled by ', tags$em('John Hopkins University'), ', parts of the code is taken from ', tags$em('Super-Zip Example'), '.'
                        )
                    )
           ),
           tabPanel("About",
                    div(id = "about_page",
                        fluidRow(
                            h3("Data Source"),
                            tags$p("COVID-19 Data Repository by the Center for Systems Science and Engineering (CSSE) at Johns Hopkins University can be found",
                                   tags$a(tags$i("here"),
                                          href = "https://github.com/CSSEGISandData/COVID-19",
                                          target = "_blank"), 
                                   )
                        ),
                        fluidRow(
                            h3("Code"),
                            tags$li("Source code can be viewed",
                                   tags$a(tags$i("here"),
                                          href = "https://github.com/hhekim/Covid19",
                                          target = "_blank"), 
                            ),
                            tags$li("Some portions of the code is taken from ",
                                    tags$a(tags$i("Superzip Example"),
                                           href = "https://github.com/rstudio/shiny-examples/tree/master/063-superzip-example",
                                           target = "_blank"), 
                            )
                        )
                    )
            )
)


