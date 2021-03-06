# Script for bringing in and merging the panel data for eviction and mortality project

library(dplyr)
library(tidyr)
library(readr)
library(readxl)

options( scipen = 5 )
getwd() 

#-----------------------SAIPE DF ----------------------------------------------
incomePoverty <- read_csv("Data/SAIPE median income county.csv")

incomePoverty = incomePoverty %>% 
  select(-"All Ages in Poverty Count", -"State / County Name", -"All Ages SAIPE Poverty Universe") %>% 
  rename(fips = 'County ID', state_id='State', year=Year, 
         povertyRate='All Ages in Poverty Percent', medianIncome='Median Household Income in Dollars') 

#convert the currency character values into numeric values
incomePoverty$medianIncome = as.numeric(gsub('[$,]', '', incomePoverty$medianIncome))

#-----------------------Evictions DF -------------------------------------------

Evictions <- read_csv("Data/eviction_demo_counties.csv")

Evictions = tbl_df(Evictions)

Evictions = Evictions %>% 
  select(-'low-flag', -subbed, -name, -'median-household-income',-'poverty-rate') %>% 
  rename(fips = GEOID, state='parent-location', pctAfAm='pct-af-am', evictionRate='eviction-rate') 

Evictions$fips = as.numeric(Evictions$fips)
  
#-----------------------Heart Disease Related Mortality DF -------------------------------------------

heartDzMortality <- read_csv("Data/hearDzMortByCounty.csv")

heartDzMortality = heartDzMortality %>% 
  select(-Notes, -'Age Adjusted Rate Standard Error', -'Year Code', -'Crude Rate', -Deaths) %>% 
  rename(fips = 'County Code', heartDzMortality='Age Adjusted Rate', county_name=County, year=Year)

#-----------------------All-cause  Related Mortality DF -------------------------------------------

allCauseMortality <- read_csv("Data/AllCause2000_2016ByCounty (1).csv")

allCauseMortality = allCauseMortality %>% 
  select(-Deaths) %>% 
  rename(allCauseMortality=mortality_rate, county_name=County, year=Year)
  
#-----------------------Unemployment DF -------------------------------------------

unemployment <- read_excel("Data/Semi_Fianl_Unemployment rate per county 2000 - 2016.xlsx")

unemployment = unemployment %>% 
  select(-starts_with("Co"), -State, -...37) %>% 
  rename(fips = 'FIPS County Code')

#convert from wide to long format 
unemployment = gather(unemployment, year, unemployment, 2:18 )
unemployment = arrange(unemployment, fips)
unemployment$year = as.numeric(unemployment$year) #convert to numeric so data types match
unemployment$fips = as.numeric(unemployment$fips)

#-----------------------Merge Dataframes -----------------------------------------------

a = inner_join(allCauseMortality, heartDzMortality, by=c('fips','year','county_name','Population'))
b = inner_join(a, Evictions, by=c('fips', 'year'))
c = inner_join(b, unemployment, by=c('fips', 'year') )
evictionData = inner_join(c, incomePoverty, by=c('fips', 'year') )

rm(a, b, c, incomePoverty, allCauseMortality, Evictions, heartDzMortality, unemployment)
save(evictionData, file="eviction-mortality/dataFrame/comdinedData.rda")
write.csv(evictionData, file = "evictionData.csv")





