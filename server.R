
library(shiny)
library(leaflet)
library(plotly)
library(rgeos)

function(input, output, session) {
  
  observeEvent(input$map_shape_click, {
    p <- input$map_shape_click 
    cnty <- p$id
    type <- input$type
    period <- input$period
    
    if(type == "Confirmed"){
      plot_data <- conf_ts%>% 
        filter(Country_Region == cnty, Cases > 0) %>% 
        mutate(Daily_Cases = Cases - lag(Cases, default = Cases[1]))
    }else if(type == "Deaths"){
      plot_data <- deaths_ts%>% 
        filter(Country_Region == cnty, Cases > 0) %>% 
        mutate(Daily_Cases = Cases - lag(Cases, default = Cases[1]))
    }else if(type == "Recovered"){
      plot_data <- recovered_ts%>% 
        filter(Country_Region == cnty, Cases > 0) %>% 
        mutate(Daily_Cases = Cases - lag(Cases, default = Cases[1]))
    }
    
    if(period == "three_months"){
      plot_data <- plot_data %>% 
        slice_tail(n = 90)
    }else if(period == "one_month"){
      plot_data <- plot_data %>% 
        slice_tail(n = 30)
    }else if(period == "fifteen_days"){
      plot_data <- plot_data %>% 
        slice_tail(n = 15)
    }
    
    output$country <- renderPlotly({
      fig <- plot_ly(plot_data, x = ~Date, y = ~Daily_Cases, type = 'scatter', mode = 'lines+markers') %>% 
        layout(xaxis = list(title = cnty, tickformat = "%m/%y"),
               yaxis = list(title = "", tickformat = "s"),
               margin = list(l=0, r=0)) %>% 
        config(displayModeBar = FALSE, displaylogo = FALSE)
      fig
    })
  }) 
  
  output$map <- renderLeaflet({
    col_name <- as.name(input$type)
    pal <- colorBin("YlOrRd", log(world[[col_name]]), right = TRUE)
    leaflet(world) %>% 
      addTiles() %>% 
      addPolygons(stroke = TRUE, weight=1, smoothFactor = 0.3, fillOpacity = 1,
                  fillColor = ~pal(log(world[[col_name]])),
                  label = ~paste0(name, ": ", formatC(world[[col_name]], big.mark = ",")),
                  layerId = ~name) %>% 
      setView(lng = 30, lat = 30, zoom = 03)
  })
}
