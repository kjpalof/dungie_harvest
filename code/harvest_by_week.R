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
  mutate(per_total_N = numbers/ totalN, per_total_P = pounds/totalP, 
         sell_date = as.Date(selld, format = "%m/%d/%Y"), 
         day = format(sell_date, "%j")) ->dunge3




summmer_season = c()
dunge3 %>% filter(SEASON == 'Apr2012 - Mar13') ->d_12 # 167 to 222
d_12 %>% filter(day >= 167 & day <=222) -> summer_12
write.csv(summer_12, './results/summer_12.csv')

dunge3 %>% filter(SEASON == 'Apr2013 - Mar14') ->d_13 # 166 to 221
d_13 %>% filter(day >= 166 & day <=221) -> summer_13
write.csv(summer_13, './results/summer_13.csv')

dunge3 %>% filter(SEASON == 'Apr2014 - Mar15') ->d_14 # 166 to 221
d_14 %>% filter(day >= 166 & day <=221) -> summer_14
write.csv(summer_14, './results/summer_14.csv')

dunge3 %>% filter(SEASON == 'Apr2015 - Mar16') ->d_15 # 166 to 221
d_15 %>% filter(day >= 166 & day <=221) -> summer_15
write.csv(summer_15, './results/summer_15.csv')

dunge3 %>% filter(SEASON == 'Apr2016 - Mar17') ->d_16 # 167 to 222
d_16 %>% filter(day >= 167 & day <=222) -> summer_16
write.csv(summer_16, './results/summer_16.csv')
