# Southeast Alaska Dungeness harvest - updated through 2017
# 
# K.Palof   ADF&G
# katie.palof@alaska.gov
# 2018-4-10

# This code will establish the percentage of harvest by week in the Dungeness crab fishery.  
# Specifically looking at determining what percentage of harvest is taken in the last 3 weeks of the fishery
#     since in 2017 the fishery was closed 3 weeks early due to conservation concerns.

# All catch values are in pounds unless otherwise noted.


# load ----
library(tidyverse)
library(reshape2)
library(xlsx)
library(extrafont)
library(lubridate)
options(scipen=9999) # remove scientific notation

loadfonts(device="win")
windowsFonts(Times=windowsFont("TT Times New Roman"))
theme_set(theme_bw(base_size=12,base_family='Times New Roman')+ 
            theme(panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank()))


#### Load data ----
dunge <- read.csv("./data/Dungeness_12_16.csv") # tanner crab survey data
glimpse(dunge)

### reduce data ----
dunge %>% select(year = YEAR, SEASON, TICKET = TICKET_NO, cdate = CATCH_DATE, STAT_WEEK, selld = SELL_DATE, 
                 numbers = NUMBERS, pounds = POUNDS) -> dunge1

# need to convert dates as factors to dates so I can add a day of the season or day of the year.
dunge1 %>% 
  mutate(c_date = as.Date(cdate, format = "%m/%d/%Y"), 
         cdate_mo = month(c_date), cdate_day = day(c_date)) -> dunge_data

### seasons -------         
# Summer season: June 15th - Aug 15th, fall season Oct. 1 to Nov.30th
# need to create a key for season weeks / so far only summer / add fall
week <- c(rep(1, 7), rep(2,7), rep(3,7), rep(4,7), rep(5,7), rep(6,7), rep(7,7), rep(8,7), rep(9,6)) # 9 weeks in summer season
month <- c(rep(6, 16), rep(7, 31), rep(8,15))
day <- c(seq(from = 15, to =30), seq(1:31), seq(1:15))
#summer
season_week <- data.frame(week, month, day)

# fall
week <- c(rep(10, 7), rep(12,7), rep(13,7), rep(14,7), rep(15,7), rep(16,7), rep(17,7), rep(18,7), rep(19,5)) # 9 weeks in summer season
month <- c(rep(10, 31), rep(11, 30))
day <- c(seq(from = 1, to =31), seq(1:30))

season_week_fall <- data.frame(week, month, day)

# summer and fall - until Nov. 30th together
season_week %>% 
  bind_rows(season_week_fall) -> season_week_all

season_week_all %>% 
  mutate(cdate_mo = month, cdate_day = day) -> season_week_all
  
## data and seasons combo -----
# bind season week to test to get a variable for week of the season in each year
dunge_data %>% 
  left_join(season_week_all) ->dunge_data


## annual weekly catch ----
dunge_data %>% 
  group_by(year, week) %>% 
  summarise(numbers = sum(numbers), pounds = sum(pounds)) ->dunge_week
