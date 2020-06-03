library(dplyr)
library(ggplot2)

covid <- read.csv("https://opendata.ecdc.europa.eu/covid19/casedistribution/csv",
                  na.strings = "",
                  fileEncoding = "UTF-8-BOM")

covid<- covid %>% 
  mutate(dateRep=as.Date(dateRep,"%d/%m/%Y")) %>% 
  group_by(countriesAndTerritories) %>% 
  arrange(countriesAndTerritories,dateRep) %>% 
  mutate(csumcases = cumsum(cases), csumdeaths = cumsum(deaths)) %>% 
  filter(csumdeaths > 0) %>% 
  arrange(dateRep) %>% 
  group_by(geoId) %>% 
  mutate(day_counter = row_number())

countries <- covid %>% 
  group_by(geoId,countriesAndTerritories) %>%
  summarise(totalcases=sum(cases),totaldeaths=sum(deaths),pop=mean(popData2018)) %>% 
  filter(totalcases > 1000 & totaldeaths > 0)

covid_top_15 <- covid %>% 
  group_by(geoId) %>% 
  summarise(cscases = sum(cases), csdeaths = sum(deaths)) %>% 
  arrange(desc(cscases)) %>% 
  slice(1:15)

