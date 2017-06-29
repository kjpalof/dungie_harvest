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
dunge %>% select(year = YEAR, SEASON, TICKET = TICKET_NO, cdate = CATCH_DATE, STAT_WEEK, selld = SELL_DATE, 
                 numbers = NUMBERS, pounds = POUNDS) -> dunge1


### stat week -----
dunge1 %>% 
  group_by(SEASON, STAT_WEEK) %>% 
  summarise (numbers = sum(numbers), pounds = sum(pounds)) ->sum_stat_week

#### total season ----
dunge1 %>% 
  group_by(SEASON) %>% 
  summarise(totalN = sum(numbers), totalP =sum(pounds)) -> total_season


#### by day ----
dunge1 %>% 
  group_by(SEASON, selld) %>% 
  summarise (numbers = sum(numbers), pounds = sum(pounds)) -> sum_by_day

### not sure -----
sum_by_day %>% 
  left_join(total_season) -> dunge2

dunge2 %>% 
  mutate(per_total_N = numbers/ totalN, per_total_P = pounds/totalP) ->dunge3


dunge3

