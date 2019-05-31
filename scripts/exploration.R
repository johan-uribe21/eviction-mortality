# Script for bring in and merging the panel data for eviction and mortality project

library(dplyr)
library(ggplot2)
library(ggrepel)

options( scipen = 5 )
options( survey.replicates.mse = TRUE )

getwd() 
load("eviction-mortality/dataFrame/comdinedData.rda")

#-----------------------Initial Scaterplots -------------------------------------------

ggplot(evictionData, aes(y=evictions, x=heartDzMortality)) +
  geom_point(shape=1, size=3) +    # Use hollow circles
  geom_smooth()+   # Add linear regression line
  theme(text = element_text(size=20))

ggplot(evictionData, aes(x=allCauseMortality, y=evictions)) +
  geom_point(shape=1, size=3) +    # Use hollow circles
  geom_smooth(method="auto", se=TRUE)+   # Add linear regression line
  theme(text = element_text(size=20))

ggplot(evictionData, aes(y=evictions, x=unemployment)) +
  geom_point(shape=1, size=3) +    # Use hollow circles
  geom_smooth(method="lm", se=TRUE)+   # Add linear regression line
  theme(text = element_text(size=20))

ggplot(evictionData, aes(y=evictions, x=medianIncome)) +
  geom_point(shape=1, size=3) +    # Use hollow circles
  geom_smooth(method="auto", se=TRUE)+   # Add linear regression line
  theme(text = element_text(size=20))











