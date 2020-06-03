
library(shiny)
library(shinydashboard)
library(plotly)

shinyServer(function(input, output, session) {
    updateSelectInput(session, "baseCntry", selected = "TR")
    output$casesbox <- renderInfoBox({
        valueBox(
            format(countries$totalcases[countries$geoId == input$baseCntry],big.mark=","),
            "Cases", 
            icon = icon("ambulance"),
            color = "red"
        )
    })
    output$deathsbox <- renderInfoBox({
        valueBox(
            format(countries$totaldeaths[countries$geoId == input$baseCntry],big.mark=","), 
            "Deaths", 
            icon = icon("bed"),
            color = "purple"
        )
    })
    output$caseper1000box <- renderInfoBox({
        valueBox(
            format((countries$totalcases[countries$geoId == input$baseCntry] / 
                                   countries$pop[countries$geoId == input$baseCntry]) * 1000,digits=2), 
            "Cases per 1000 person", 
            icon = icon("users"),
            color = "orange"
        )
    })
    output$deathper100casebox <- renderInfoBox({
        valueBox(
            format((countries$totaldeaths[countries$geoId == input$baseCntry] /
                        countries$totalcases[countries$geoId == input$baseCntry])  * 100,digits=2), 
            "Deaths per 100 cases", 
            icon = icon("frown"),
            color = "olive"
        )
    })
    
    output$world <- renderPlotly({print(ggplotly(
            ggplot(covid) +
                geom_point(data = covid %>% filter(cases >= 100 & deaths > 0), 
                           aes(x=cases, y=deaths), alpha=0.5, color="gray54") + 
                geom_point(data=covid %>% filter(geoId == input$baseCntry & cases >= 100 & deaths > 0), 
                           aes(x=cases, y=deaths), color="violetred3", size =2.5) + 
                labs(x = "Logged cases", 
                     y = "Logged deaths",
                     title = "Wordwide daily reported cases and deaths (after 100. case)") +
                theme(text = element_text(size=9)) +
                scale_x_log10(labels = scales::unit_format(accuracy=0.1,unit = "k",scale = 1e-3)) +
                scale_y_log10(labels = scales::unit_format(accuracy=0.1,unit = "k",scale = 1e-3)) +
                geom_smooth(data = covid %>% filter(cases >= 100 & deaths > 0), 
                            aes(x=cases, y=deaths), color="limegreen") +
                geom_smooth(data=covid %>% filter(geoId == input$baseCntry & cases >= 100 & deaths > 0),
                            aes(x=cases, y=deaths),color="mediumblue")))
        
    })
    
    output$top15cases <- renderPlotly({print(ggplotly(
        ggplot(data = covid %>% filter(geoId %in% covid_top_15$geoId),aes(label=geoId)) +
            geom_line(aes(x = day_counter, y = csumcases, group=countriesAndTerritories, alpha=0.5), size = 0.75, color = "gray54") +
            geom_line(data=covid %>% filter(geoId == input$baseCntry), 
                      aes(x = day_counter, y = csumcases), color="red", size=1) +
            labs(x = "Days", 
                 y = "Logged cases", 
                 title = NULL) +
            scale_y_log10(labels = scales::unit_format(accuracy=0.1,unit = "k",scale = 1e-3)) +
            geom_text(data=covid %>% 
                          filter(geoId %in% covid_top_15$geoId | geoId == input$baseCntry) %>% 
                          group_by(geoId) %>% 
                          slice(tail(row_number(), 1)),
                      aes(x = day_counter, y = csumcases, label=geoId),
                      position=position_nudge(0.1), hjust=0, show.legend=FALSE) +
            theme(text = element_text(size=8)) +
            guides(alpha=FALSE)))
    })
    
    output$top15deaths <- renderPlotly({print(ggplotly(
        ggplot(data = covid %>% filter(geoId %in% covid_top_15$geoId),aes(label=geoId)) +
            geom_line(aes(x = day_counter, y = csumdeaths, group=countriesAndTerritories, alpha=0.5), size = 0.75, color = "gray54") +
            geom_line(data=covid %>% filter(geoId == input$baseCntry), 
                      aes(x = day_counter, y = csumdeaths), color="red", size=1) +
            labs(x = "Days", 
                 y = "Logged cases", 
                 title = NULL) +
            scale_y_log10(labels = scales::unit_format(accuracy=0.1,unit = "k",scale = 1e-3)) +
            geom_text(data=covid %>% 
                          filter(geoId %in% covid_top_15$geoId | geoId == input$baseCntry) %>% 
                          group_by(geoId) %>% 
                          slice(tail(row_number(), 1)),
                      aes(x = day_counter, y = csumdeaths, label=geoId),
                      position=position_nudge(0.1), hjust=0, show.legend=FALSE) +
            theme(text = element_text(size=8)) +
            guides(alpha=FALSE)))
    })
    
    output$top15cd <- renderPlotly({print(ggplotly(
        ggplot(data = covid %>% filter(geoId %in% covid_top_15$geoId),aes(label=geoId)) +
            geom_line(aes(x = csumcases, y = csumdeaths, group=countriesAndTerritories, alpha=0.5), size = 0.75, color = "gray54") +
            geom_line(data=covid %>% filter(geoId == input$baseCntry), 
                      aes(x = csumcases, y = csumdeaths), color="red", size=1) +
            labs(x = "Logged cases", 
                 y = "Logged deaths", 
                 title = NULL) +
            scale_x_log10(labels = scales::unit_format(accuracy=0.1,unit = "k",scale = 1e-3)) +
            scale_y_log10(labels = scales::unit_format(accuracy=0.1,unit = "k",scale = 1e-3)) +
            geom_text(data=covid %>% 
                          filter(geoId %in% covid_top_15$geoId | geoId == input$baseCntry) %>% 
                          group_by(geoId) %>% 
                          summarize(cases=sum(cases),deaths=sum(deaths)),
                      aes(x = cases, y = deaths, label=geoId),
                      position=position_nudge(0.1), hjust=0, show.legend=FALSE) +
            theme(text = element_text(size=8)) +
            guides(alpha=FALSE)))
    })
    
    output$top15casesbox <- renderPlotly({print(ggplotly(
        ggplot(data = covid %>% filter((geoId %in% covid_top_15$geoId | geoId == input$baseCntry) & deaths > 0), 
               aes(x=reorder(geoId,cases), y=cases)) +
            geom_boxplot(aes(fill=reorder(countriesAndTerritories, -cases))) +
            theme(legend.title = element_blank()) +
            labs(x = NULL, 
                 y = NULL, 
                 title = "Distribution of logged cases") +
            scale_y_log10(labels = scales::unit_format(accuracy=0.1,unit = "k",scale = 1e-3)) +
            coord_flip()))
    })
    
    output$top15deathssbox <- renderPlotly({print(ggplotly(
        ggplot(data = covid %>% filter((geoId %in% covid_top_15$geoId | geoId == input$baseCntry) & deaths > 0), 
               aes(x=reorder(geoId,deaths), y=deaths)) +
            geom_boxplot(aes(fill=reorder(countriesAndTerritories, -deaths))) +
            theme(legend.title = element_blank()) +
            labs(x = NULL, 
                 y = NULL, 
                 title = "Distribution of logged deaths") +
            scale_y_log10(labels = scales::unit_format(accuracy=0.1,unit = "k",scale = 1e-3)) +
            coord_flip()))
    })
})
