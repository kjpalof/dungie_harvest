# K.Palof 6-29-17
# Purpose of this script: to examine Dungeness harvest % by week in the fishery the last 5 years to look at current year (2017) closing early
#

### Load packages ----
library(tidyverse)
library(reshape2)

#### Load data ----
dunge <- read.csv("./data/Dungeness_12_16.csv") # tanner crab survey data
glimpse(dunge)



### reduce data ----
dunge %>% select(year = YEAR, TICKET = TICKET_NO, cdate = CATCH_DATE, STAT_WEEK, selld = SELL_DATE, 
                 numbers = NUMBERS, pounds = POUNDS) -> dunge1


### stat week -----



#### by day ----