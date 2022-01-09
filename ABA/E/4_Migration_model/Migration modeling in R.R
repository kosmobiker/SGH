#--- clearing working space
rm(list=ls())

#--- setting working directory
setwd("C:/ABA")


#--- importing required packages
# install.packages(c("dplyr", "lubridate"))
library(dplyr) # popular package for data manipulation
library(lubridate) # here: operating on dates


#==========================================================================
#--- USEFUL MATERIALS

# Malthouse 2009, Chapter 5 - The Migration Model

#==========================================================================


#----------------------------------  MIGRATION MODELS  ----------------------------------#


#===============================
#--- Example 4
#===============================

# Buy, no-buy model results using matrix approach
v <- c(19, -1)
n <- c(1000, 0)
P <- matrix(c(0.2, 0.8, 0.1, 0.9), nrow = 2, ncol = 2, byrow = T)
P2 <- P %*% P
P3 <- P2 %*% P
clv <- solve(diag(2)-P/1.1) %*% v
ce <- n %*% clv

v
n
P
P2
P3
clv
ce


#===============================
#--- Example 5
#===============================

# importing dataset
df <- read.csv2("TRANS.csv", header = T, stringsAsFactors = F, sep = ";")

# changing system settings to convert giftdate
lct <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME", "C")



#---------------------------------------
# computing each customer's recency as of today and whether the customer donated during the next years
rollup <- df %>%
  dplyr::mutate(data = as.Date(x = giftdate, format = '%d%b%Y'), # converting giftdate
                diff = lubridate::time_length(difftime(as.Date(x = '31AUG2005', format = '%d%b%Y'), data), "years"),
                amt =  as.numeric(amt)) %>%
  dplyr::arrange(id, data) %>%
  group_by(id) %>%
  dplyr::mutate(targbuy = ifelse(diff < 0, 1, 0),
                targdol = ifelse(diff < 0, amt, 0),
                freq = ifelse(diff < 0, 0, 1),
                recency = ifelse(diff >= 0, diff, 9999)) %>%
  dplyr::mutate(targdol = cumsum(targdol),
                freq = cumsum(freq),
                recency = ifelse(diff >= 0, recency, min(recency))) %>%
  dplyr::filter(row_number() == n()) %>%
  # setting recency intervals for data summary
  dplyr::mutate(recency_interval = case_when(
    recency < 1 ~ "r<1 yr",
    recency >= 1 & recency < 2 ~ "1<=r<2",
    recency >= 2 & recency < 3 ~ "2<=r<3",
    recency >= 3 ~ "r>=3")) %>%
  dplyr::select(id, targbuy, targdol, recency, recency_interval, freq)
  
# changing recency_interval to factor
rollup$recency_interval <- ordered(as.factor(rollup$recency_interval), c("r<1 yr", "1<=r<2", "2<=r<3", "r>=3"))



# The crosstab of recency and targbuy - probabilities estimate the transition matrix
addmargins(table(rollup$recency_interval, rollup$targbuy), margin = 2)
round(prop.table(table(rollup$recency_interval, rollup$targbuy), margin = 1)*100,2)


# Descriptive statistics for tagdol variable - mean value is necessary for value vecor
rollup %>%
  group_by(targbuy) %>%
  filter(targbuy == 1) %>%
  summarise(n=n(),
            mean = mean(targdol),
            stdv = sd(targdol),
            min = min(targdol),
            max = max(targdol)) %>%
  as.data.frame()




#---------------------------------------
# Re-running above program for finding the inital vector n - change in date from 31AUG2005 to 31AUG2006


# computing each customer's recency as of today and whether the customer donated during the next years
rollup <- df %>%
  dplyr::mutate(data = as.Date(x = giftdate, format = '%d%b%Y'), # converting giftdate
                diff = lubridate::time_length(difftime(as.Date(x = '31AUG2006', format = '%d%b%Y'), data), "years"),
                amt =  as.numeric(amt)) %>%
  dplyr::arrange(id, data) %>%
  group_by(id) %>%
  dplyr::mutate(targbuy = ifelse(diff < 0, 1, 0),
                targdol = ifelse(diff < 0, amt, 0),
                freq = ifelse(diff < 0, 0, 1),
                recency = ifelse(diff >= 0, diff, 9999)) %>%
  dplyr::mutate(targdol = cumsum(targdol),
                freq = cumsum(freq),
                recency = ifelse(diff >= 0, recency, min(recency))) %>%
  dplyr::filter(row_number() == n()) %>%
  # setting recency intervals for data summary
  dplyr::mutate(recency_interval = case_when(
    recency < 1 ~ "r<1 yr",
    recency >= 1 & recency < 2 ~ "1<=r<2",
    recency >= 2 & recency < 3 ~ "2<=r<3",
    recency >= 3 ~ "r>=3")) %>%
  dplyr::select(id, targbuy, targdol, recency, recency_interval, freq)

# changing recency_interval to factor
rollup$recency_interval <- ordered(as.factor(rollup$recency_interval), c("r<1 yr", "1<=r<2", "2<=r<3", "r>=3"))



# The crosstab of recency and targbuy - probabilities estimate the transition matrix
addmargins(table(rollup$recency_interval, rollup$targbuy), margin = 2)
round(prop.table(table(rollup$recency_interval, rollup$targbuy), margin = 1)*100,2)


#---------------------------------------
# Predicting customer equity in two years
n <- c(3886, 1992, 1917, 13371)
v <- c(69.06, 0, 0 ,0)
P <- matrix(c(0.5689,  0.4311,      0,      0,
            0.2456,       0, 0.7544,      0,
            0.0973,       0,      0, 0.9027,
            0.0335,       0,      0, 0.9665),
           byrow = T,
           ncol=4)

P

pred <- (n %*% P %*% v) + (n %*% P %*% P %*% v)
pred


#---------------------------------------
# returning to former settings
Sys.setlocale("LC_TIME", lct)
