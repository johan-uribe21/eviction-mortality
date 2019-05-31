# Script for bring in and merging the panel data for eviction and mortality project

library(dplyr)
library(survey)
library(readr)
library(tidyr)
library(readxl)

options( scipen = 5 )
options( survey.replicates.mse = TRUE )

getwd() #checks your current working directory. 

#--------------------------Import Data----------------------------------------------

allCauseMortality <- read_csv("Data/AllCause2000_2016ByCounty (1).csv")



unemployment <- read_excel("Data/Semi_Fianl_Unemployment rate per county 2000 - 2016.xlsx")

#-----------------------Evictions DF -------------------------------------------
Evictions <- read_csv("Data/eviction_demo_counties.csv")

Evictions = tbl_df(Evictions)

Evictions = Evictions %>% 
  select(-'low-flag', -subbed) %>% 
  rename(fips = GEOID, state=parent-location ) 
  
  
#-----------------------Evictions DF -------------------------------------------
heartDzMortality <- read_csv("Data/hearDzMortByCounty.csv")
  
  
  
  
  
  
  
  


  

