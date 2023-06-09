library(rvest)
library(xml2)
library(dplyr)
library(lubridate)
library(ggplot2)
library(GGally)
library(jsonlite)
library(leaflet)
library(mgcv)
library(APCtools)

# Read 2020 bike data
# Download zip file and unzip into csv
zip20link <- "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/7e876c24-177c-4605-9cef-e50dd74c617f/resource/e534141d-92c6-4dd7-8ba1-bb061674d943/download/bikeshare-ridership-2020.zip"
temp <- tempfile()
options(timeout = max(1000, getOption("timeout")))
download.file(zip20link, temp)
zip20 <- unzip(temp)
unlink(temp)

# Read all csv
bikes20_1 <- read.csv(zip20[1])
bikes20_2 <- read.csv(zip20[2])
bikes20_3 <- read.csv(zip20[3])
bikes20_4 <- read.csv(zip20[4])
bikes20_5 <- read.csv(zip20[5])
bikes20_6 <- read.csv(zip20[6])
bikes20_7 <- read.csv(zip20[7])
bikes20_8 <- read.csv(zip20[8])
bikes20_9 <- read.csv(zip20[9])
bikes20_10 <- read.csv(zip20[10])
bikes20_11 <- read.csv(zip20[11])
bikes20_12 <- read.csv(zip20[12])

# Change mismatching variable types 
bikes20_10$Start.Station.Id <- suppressWarnings(as.numeric(bikes20_10$Start.Station.Id))
bikes20_10$Bike.Id <- suppressWarnings(as.numeric(bikes20_10$Bike.Id))
bikes20_12$Bike.Id <- suppressWarnings(as.numeric(bikes20_12$Bike.Id))

bikes20 <- bind_rows(bikes20_1, bikes20_2, bikes20_3, bikes20_4, bikes20_5, bikes20_6,
                     bikes20_7, bikes20_8, bikes20_9, bikes20_10, bikes20_11, bikes20_12)



# Read 2021 bike data
# Download zip file and unzip into csv
zip21link <- "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/7e876c24-177c-4605-9cef-e50dd74c617f/resource/ddc039f6-07fa-47a3-a707-0121ade3b307/download/bikeshare-ridership-2021.zip"
temp <- tempfile()
download.file(zip21link, temp)
zip21 <- unzip(temp)
unlink(temp)

# Read all csv
bikes21_1 <- read.csv(zip21[1])
bikes21_2 <- read.csv(zip21[2])
bikes21_3 <- read.csv(zip21[3])
bikes21_4 <- read.csv(zip21[4])
bikes21_5 <- read.csv(zip21[5])
bikes21_6 <- read.csv(zip21[6])
bikes21_7 <- read.csv(zip21[7])
bikes21_8 <- read.csv(zip21[8])
bikes21_9 <- read.csv(zip21[9])
bikes21_10 <- read.csv(zip21[10])
bikes21_11 <- read.csv(zip21[11])
bikes21_12 <- read.csv(zip21[12])

# Change mismatching variable types
bikes21_1$Bike.Id <- suppressWarnings(as.numeric(bikes21_1$Bike.Id))

bikes21 <- bind_rows(bikes21_1, bikes21_2, bikes21_3, bikes21_4, bikes21_5, bikes21_6, 
                      bikes21_7, bikes21_8, bikes21_9, bikes21_10, bikes21_11, bikes21_12)


# read 2022 bike data

# Read 2022 bike data
# Download zip file and unzip into csv
zip22link <- "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/7e876c24-177c-4605-9cef-e50dd74c617f/resource/db10a7b1-2702-481c-b7f0-0c67070104bb/download/bikeshare-ridership-2022.zip"
temp <- tempfile()
download.file(zip22link, temp)
zip22 <- unzip(temp)
unlink(temp)

# Read all csv
bikes22_1 <- read.csv(zip22[1])
bikes22_2 <- read.csv(zip22[2])
bikes22_3 <- read.csv(zip22[3])
bikes22_4 <- read.csv(zip22[4])
bikes22_5 <- read.csv(zip22[5])
bikes22_6 <- read.csv(zip22[6])
bikes22_7 <- read.csv(zip22[7])
bikes22_8 <- read.csv(zip22[8])
bikes22_9 <- read.csv(zip22[9])
bikes22_10 <- read.csv(zip22[10])
bikes22_11 <- read.csv(unzip(zip22[11]))
bikes22_12 <- read.csv(zip22[12])

bikes22 <- bind_rows(bikes22_1, bikes22_2, bikes22_3, bikes22_4, bikes22_5, bikes22_6,
                     bikes22_7, bikes22_8, bikes22_9, bikes22_10, bikes22_11, bikes22_12)

# combine bike data
bikedata <- bind_rows(bikes20, bikes21, bikes22)


# Read Bike station data
bikestation_url <- "https://tor.publicbikesystem.net/ube/gbfs/v1/en/station_information"
bikestation <- as.data.frame(fromJSON(bikestation_url, flatten = TRUE))


# Read 2020 weather data
weatherdata <- data.frame()
for (i in 1:12){

weather20url <- paste(paste("https://climate.weather.gc.ca/climate_data/daily_data_e.html?hlyRange=2002-06-04%7C2023-03-03&dlyRange=2002-06-04%7C2023-03-02&mlyRange=2003-07-01%7C2006-12-01&StationID=31688&Prov=ON&urlExtension=_e.html&searchType=stnName&optLimit=yearRange&StartYear=2020&EndYear=2023&selRowPerPage=25&Line=1&searchMethod=contains&txtStationName=Toronto&timeframe=2&Day=3&Year=2020&Month=", i, sep = ""), "#", sep = "")

# Downloading the website
weather <- xml2::read_html(weather20url)

# Finding the table
weather <- xml2::xml_find_first(weather, "/html/body/main/div[5]/table")

# Convert to r dataframe
weather <- rvest::html_table(weather)

# Add month and year variable
weather <- weather %>% mutate(month = i)
weather <- weather %>% mutate(year = 2020)

weatherdata <- bind_rows(weatherdata, weather)
}


# Read 2021 weather data
for (i in 1:12){

weather21url <- paste(paste("https://climate.weather.gc.ca/climate_data/daily_data_e.html?hlyRange=2002-06-04%7C2023-03-03&dlyRange=2002-06-04%7C2023-03-02&mlyRange=2003-07-01%7C2006-12-01&StationID=31688&Prov=ON&urlExtension=_e.html&searchType=stnName&optLimit=yearRange&StartYear=2020&EndYear=2023&selRowPerPage=25&Line=1&searchMethod=contains&txtStationName=Toronto&timeframe=2&Day=3&Year=2021&Month=", i, sep = ""), "#", sep = "")

# Downloading the website
weather <- xml2::read_html(weather21url)

# Finding the table
weather <- xml2::xml_find_first(weather, "/html/body/main/div[5]/table")

# Convert to r dataframe
weather <- rvest::html_table(weather)

# Add month and year variable
weather <- weather %>% mutate(month = i)
weather <- weather %>% mutate(year = 2021)

weatherdata <- bind_rows(weatherdata, weather)
}


# Read 2022 weather data
for (i in 1:12){

weather22url <- paste(paste("https://climate.weather.gc.ca/climate_data/daily_data_e.html?hlyRange=2002-06-04%7C2023-03-03&dlyRange=2002-06-04%7C2023-03-02&mlyRange=2003-07-01%7C2006-12-01&StationID=31688&Prov=ON&urlExtension=_e.html&searchType=stnName&optLimit=yearRange&StartYear=2020&EndYear=2023&selRowPerPage=25&Line=1&searchMethod=contains&txtStationName=Toronto&timeframe=2&Day=3&Year=2022&Month=", i, sep = ""), "#", sep = "")

# Downloading the website
weather <- xml2::read_html(weather22url)

# Finding the table
weather <- xml2::xml_find_first(weather, "/html/body/main/div[5]/table")

# Convert to r dataframe
weather <- rvest::html_table(weather)

# Add month and year variable
weather <- weather %>% mutate(month = i)
weather <- weather %>% mutate(year = 2022)

weatherdata <- bind_rows(weatherdata, weather)
}



# Create Bike Dates
# Create date variable using the trip start time
bikedata$Start.Date.Time <- as.POSIXct(bikedata$Start.Time, format="%m/%d/%Y %H:%M")
bikedata$Date <- as.Date(bikedata$Start.Date.Time)

# Count ridership by start station
count_station  <- bikedata %>% 
  dplyr::select(Start.Station.Id, Date) %>%
  group_by(Start.Station.Id, Date) %>%
  summarise(n = n())


# Wrangle Bike Station Data
bikestation <- bikestation %>%
  dplyr::select(data.stations.station_id, 
                data.stations.name,
                data.stations.lat,
                data.stations.lon)


# Rename Bike Station Data
bikestation <- bikestation %>% rename(
    Station_id = "data.stations.station_id",
    Station_name = "data.stations.name",
    Latitude = "data.stations.lat",
    Longitude = "data.stations.lon")



weatherdata <- weatherdata %>% filter(DAY != "Avg",
                              DAY != "Xtrm",
                              DAY != "Sum",
                              DAY != "Summary, average and extreme values are based on the data above.",
                              DAY != "LegendMM")

# Add 0 for Snow when there is no entry

weatherdata$"Snow on Grnd Definitioncm" <- ifelse(weatherdata$"Snow on Grnd Definitioncm" == "", "0", weatherdata$"Snow on Grnd Definitioncm")


# Create date for weather data
weatherdata$Date <- paste(weatherdata$year, weatherdata$month, weatherdata$DAY, sep = "-")
weatherdata$Date <- ymd(weatherdata$Date)


# Drop unnecessary columns
weatherdata <- weatherdata %>%
  dplyr::select(Date, "Max Temp Definition°C", "Min Temp Definition°C", "Mean Temp Definition°C",
                "Total Precip Definitionmm", "Snow on Grnd Definitioncm" )


# Rename columns
weatherdata <- weatherdata %>%
  rename(
    Max_temp = "Max Temp Definition°C",
    Min_temp = "Min Temp Definition°C",
    Mean_temp = "Mean Temp Definition°C",
    Precipitation = "Total Precip Definitionmm",
    Snow = "Snow on Grnd Definitioncm")

# Convert columns from char to numeric
weatherdata <- weatherdata %>%
  mutate(
    Max_temp = suppressWarnings(as.numeric(Max_temp)),
    Min_temp = suppressWarnings(as.numeric(Min_temp)),
    Mean_temp = suppressWarnings(as.numeric(Mean_temp)),
    Precipitation = suppressWarnings(as.numeric(Precipitation)),
    Snow = suppressWarnings(as.numeric(Snow)))


df <- merge(count_station, weatherdata, by = "Date")
df <- df %>% 
  rename(
    Rental_count = n)



# Weekday and weekend variables
df$Weekday <- weekdays(df$Date)
df$Weekday_num <- ifelse(df$Weekday == "Monday", 1, 
                               ifelse(df$Weekday == "Tuesday", 2,
                                      ifelse(df$Weekday == "Wednesday", 3,
                                             ifelse(df$Weekday == "Thursday", 4,
                                                    ifelse(df$Weekday == "Friday", 5,
                                                           ifelse(df$Weekday == "Saturday", 6, 
                                                                  7))))))
                                                        
df$is_weekday <- ifelse(df$Weekday_num < 6, 1, 0)



df <- tidyr::drop_na(df)



 df <- df %>% rename(
   Station_id = "Start.Station.Id"
 )

df <- merge(bikestation, df, by = "Station_id")


# Create copy of df grouped by station
df_station <- df


# Create df not grouped by station
df <- df_station %>% 
  group_by(Date, 
           Max_temp, 
           Mean_temp, 
           Min_temp, 
           Precipitation, 
           Snow, 
           Weekday, 
           Weekday_num, 
           is_weekday) %>%
  summarise(Rental_count = sum(Rental_count), .groups = "drop") %>%
  as.data.frame


# Create df for most and least popular
df_most <- df_station %>%
  filter(Station_id == 7076)

df_least <- df_station %>%
  filter(Station_id == 7758)


# Data for median station
df_med <- df_station %>%
  filter(Station_id == 7685)



