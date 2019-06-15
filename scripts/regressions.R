# Script for bring in and merging the panel data for eviction and mortality project

library(dplyr)
library(ggplot2)
library(ggrepel)
library(plm)
library(stargazer)

options( scipen = 5 )
options( survey.replicates.mse = TRUE )

getwd() 
load("eviction-mortality/dataFrame/comdinedData.rda")

# filter out the duplicate rows. Just a few
evictionData  <- distinct(evictionData, fips, year, .keep_all=TRUE)

fe1 <- plm(allCauseMortality ~ log(population) + pctAfAm + evictionRate + unemployment + medianIncome,
           data = evictionData, model = "within", index=c("fips","year"), effect="individual")

fe1.sum = summary(fe1)

fe2 <- plm(allCauseMortality ~ log(population) + pctAfAm+ evictionRate + unemployment + medianIncome,
           data = evictionData, model = "within", index=c("fips","year"), effect="individual")
fe2.sum = summary(fe2)

fe.log <- plm(log(allCauseMortality) ~ log(population) + pctAfAm +evictionRate+  
                log(unemployment) + log(medianIncome)+log(povertyRate),
           data = evictionData, model = "within", index=c("fips","year"), effect="individual")

fe.log.sum = summary(fe.log)


fe.log2 <- plm(log(allCauseMortality) ~ log(population) + pctAfAm +evictionRate+  
                 log(unemployment) + log(medianIncome)+log(povertyRate),
              data = evictionData, model = "within", index=c("fips","year"), effect="twoways")

#fe.log2.sum = summary(fe.log2)

fe.log.iv <- plm(log(allCauseMortality) ~ log(population) + 
                    pctAfAm +evictionRate+  log(unemployment) + 
                    log(medianIncome)+log(povertyRate)
                  | . -evictionRate + lag(evictionRate,1),
                  data = evictionData, model = "within", index=c("fips","year"), effect="individual")
 
fe.log2.iv <- plm(log(allCauseMortality) ~ log(population) + 
                   pctAfAm +evictionRate+  log(unemployment) + 
                   log(medianIncome)+log(povertyRate)
                 | . -evictionRate + lag(evictionRate,1),
                 data = evictionData, model = "within", index=c("fips","year"), effect="twoways")





stargazer(fe1, fe.log, fe.log2,fe.log.iv, fe.log2.iv,
           type="html", 
           out="figures/AllCauseRegs.doc",
           title="All Cause Mortality Covariates",
          column.labels = c("baseline",
                            "log indiv FE",
                            "log 2way FE",
                            "log indiv FE IV",
                            "log 2way FE IV",
                            "preventable cancer p4"))
           


#********** Heart Disease Related Mortality Regressions ***********************


fe1 <- plm(heartDzMortality ~ log(population) + pctAfAm + evictionRate + unemployment + medianIncome,
           data = evictionData, model = "within", index=c("fips","year"), effect="individual")


fe2 <- plm(heartDzMortality ~ log(population) + pctAfAm+ evictionRate + unemployment + medianIncome,
           data = evictionData, model = "within", index=c("fips","year"), effect="individual")


fe.log <- plm(log(heartDzMortality) ~ log(population) + pctAfAm +evictionRate+  
                log(unemployment) + log(medianIncome)+log(povertyRate),
              data = evictionData, model = "within", index=c("fips","year"), effect="individual")


fe.log2 <- plm(log(heartDzMortality) ~ log(population) + pctAfAm +evictionRate+  
                 log(unemployment) + log(medianIncome)+log(povertyRate),
               data = evictionData, model = "within", index=c("fips","year"), effect="twoways")



fe.log.iv <- plm(log(heartDzMortality) ~ log(population) + 
                   pctAfAm +evictionRate+  log(unemployment) + 
                   log(medianIncome)+log(povertyRate)
                 | . -evictionRate + lag(evictionRate,1),
                 data = evictionData, model = "within", index=c("fips","year"), effect="individual")

fe.log2.iv <- plm(log(heartDzMortality) ~ log(population) + 
                    pctAfAm +evictionRate+  log(unemployment) + 
                    log(medianIncome)+log(povertyRate)
                  | . -evictionRate + lag(evictionRate,1),
                  data = evictionData, model = "within", index=c("fips","year"), effect="twoways")

stargazer(fe1, fe.log, fe.log2,fe.log.iv, fe.log2.iv,
          type="html", 
          out="figures/heartDzRegs.doc",
          title="Heart Disease Related Mortality Covariates",
          column.labels = c("baseline",
                            "log indiv FE",
                            "log 2way FE",
                            "log indiv FE IV",
                            "log 2way FE IV",
                            "preventable cancer p4"))


#Decriptives Statistics -------------------------------------

desc<-evictionData %>% 
  select(heartDzMortality, allCauseMortality, population, pctAfAm, 
         evictionRate, unemployment, medianIncome, povertyRate) %>% 
  filter(complete.cases(.)) 

stargazer(as.data.frame(desc),
          type="html",
          title="Descriptive Statistics",
          summary=TRUE,
          nobs=FALSE,
          median=TRUE,
          iqr =TRUE,
          digits=2,
          #column.labels = c("year","white",'black'),
          #rownames = FALSE,
          out="figures/descriptives.doc")

stargazer(desc[2], type="html" )
#Check for multicollinearity----------------------
library(GGally)
library(mctest)

mc<- mortality.df %>% 
  select(c(5,15,16,28,38,40))

mc %>% names()
mc %>% ggpairs()

omcdiag(mc, mortality.df$black.allCause)

imcdiag(mc, mortality.df$black.allCause)
#no colliniearity detected by F-tests
