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
  mutate(c_date = as.Date(cdate, format = "%m/%d/%Y")) -> test
         
test %>% 
  mutate(cdate_mo = month(c_date), cdate_day = day(c_date)) -> test 

