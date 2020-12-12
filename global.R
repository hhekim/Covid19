library(tidyverse)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(lubridate)
library(RCurl)

x <- Sys.Date() - 1
x <- format(x,"%m-%d-%Y")
url_str <- paste("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/", x, ".csv", sep = "")
jh_url <- getURL(url_str)
if(jh_url == "404: Not Found"){
  x <- Sys.Date() - 2
  x <- format(x,"%m-%d-%Y")
  url_str <- paste("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/", x, ".csv", sep = "")
  jh_url <- getURL(url_str)
}
jh <- read.csv(text = jh_url)
uid_url <- getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/UID_ISO_FIPS_LookUp_Table.csv")
uid_lookup <- read.csv(text = uid_url)
confirmed_ts_url <- getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv")
conf_ts <- read.csv(text = confirmed_ts_url)
deaths_ts_url <- getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv")
deaths_ts <- read.csv(text = deaths_ts_url)
recovered_ts_url <- getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv")
recovered_ts <- read.csv(text = recovered_ts_url)

jh <- jh %>% 
  filter(Active >= 0) %>% 
  group_by(Country_Region) %>% 
  summarise(Lat = first(Lat), Long_ = first(Long_),
            Confirmed = sum(Confirmed), Deaths = sum(Deaths), 
            Recovered = sum(Recovered), Active = sum(Active),
            Incidence_Rate = mean(Incident_Rate, na.rm = TRUE),
            Case.Fatality_Ratio = mean(Case_Fatality_Ratio, na.rm = TRUE),
            .groups = "keep")


world <- ne_countries(scale = 110, returnclass = "sf")
for(i in seq_along(jh$Country_Region)){
  jh$iso3[i] <- head(uid_lookup[uid_lookup$Country_Region == jh$Country_Region[i],]$iso3, n = 1)
}
world <- left_join(world, jh, by=c("iso_a3" = "iso3"))

# Confirmed time series
conf_ts <- conf_ts %>% 
  gather(5:ncol(conf_ts), key = "Date", value = "Cases")
conf_ts <- rename(conf_ts, Country_Region = starts_with("Country"))
conf_ts$Date <- str_replace(conf_ts$Date, "X","")
conf_ts$Date <- parse_date_time(conf_ts$Date, orders = "mdy")
conf_ts <- conf_ts %>% 
  group_by(Country_Region, Date) %>% 
  summarise(Cases = sum(Cases))
conf_ts[conf_ts$Country_Region == "US",]$Country_Region <- "United States"
conf_ts[conf_ts$Country_Region == "Congo (Kinshasa)",]$Country_Region <- "Dem. Rep. Congo"
conf_ts[conf_ts$Country_Region == "Congo (Brazzaville)",]$Country_Region <- "Congo"
conf_ts[conf_ts$Country_Region == "Korea, South",]$Country_Region <- "Korea"

#Deaths time series
deaths_ts <- deaths_ts %>% 
  gather(5:ncol(deaths_ts), key = "Date", value = "Cases")
deaths_ts <- rename(deaths_ts, Country_Region = starts_with("Country"))
deaths_ts$Date <- str_replace(deaths_ts$Date, "X","")
deaths_ts$Date <- parse_date_time(deaths_ts$Date, orders = "mdy")
deaths_ts <- deaths_ts %>% 
  group_by(Country_Region, Date) %>% 
  summarise(Cases = sum(Cases))
deaths_ts[deaths_ts$Country_Region == "US",]$Country_Region <- "United States"
conf_ts[conf_ts$Country_Region == "Congo (Kinshasa)",]$Country_Region <- "Dem. Rep. Congo"
conf_ts[conf_ts$Country_Region == "Congo (Brazzaville)",]$Country_Region <- "Congo"
conf_ts[conf_ts$Country_Region == "Korea, South",]$Country_Region <- "Korea"

#Recovered time series
recovered_ts <- recovered_ts %>% 
  gather(5:ncol(recovered_ts), key = "Date", value = "Cases")
recovered_ts <- rename(recovered_ts, Country_Region = starts_with("Country"))
recovered_ts$Date <- str_replace(recovered_ts$Date, "X","")
recovered_ts$Date <- parse_date_time(recovered_ts$Date, orders = "mdy")
recovered_ts <- recovered_ts %>% 
  group_by(Country_Region, Date) %>% 
  summarise(Cases = sum(Cases))
deaths_ts[deaths_ts$Country_Region == "US",]$Country_Region <- "United States"
conf_ts[conf_ts$Country_Region == "Congo (Kinshasa)",]$Country_Region <- "Dem. Rep. Congo"
conf_ts[conf_ts$Country_Region == "Congo (Brazzaville)",]$Country_Region <- "Congo"
conf_ts[conf_ts$Country_Region == "Korea, South",]$Country_Region <- "Korea"