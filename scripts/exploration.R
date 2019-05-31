# Script for bring in and merging the panel data for eviction and mortality project

library(dplyr)
library(tidyr)
library(readr)
library(readxl)


options( scipen = 5 )
options( survey.replicates.mse = TRUE )

getwd() 


load("eviction-mortality/dataFrame/comdinedData.rda")
#-----------------------Initial tables -------------------------------------------



