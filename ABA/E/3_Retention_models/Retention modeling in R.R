#--- clearing working space
rm(list=ls())

#--- setting working directory
setwd("C:/ABA")


#--- importing required packages
# install.packages(c("ggplot2", "dplyr", "broom", "survival", survminer"))
library(ggplot2) # popular data visualisation package
library(dplyr) # popular package for data manipulation
library(broom) # here: used for extracting data from model summary
library(survival) # basic package for survival analysis
library(survminer) # package for summarizing and visualizing the results of survival analysis


#==========================================================================
#--- USEFUL MATERIALS

# https://uc-r.github.io/kmeans_clustering
# https://rstudio-pubs-static.s3.amazonaws.com/222343_7c69170852eb4b50a64ba6a3ccf182ac.html

#==========================================================================


#----------------------------------  RETENTION MODELS  ----------------------------------#


#===============================
#--- Example 3
#===============================


# creating dataset
geo <- data.frame("t" = c(0, 1),
                  "p" = c(0, .2),
                  "St" = c(1, 1-.2),
                  "p2" = c(0, .1),
                  "St2" = c(1, 1-.1))

p <- .2
St <- .8
p2 <- .1
St2 <- .9

for (i in 2:25) {
  
  t = i
  p = p*.8
  St = St - p
  p2 = p2*.9
  St2 = St2 - p2
  
  geo[i+1, ] <- c(t, p, St, p2, St2)
}


# --- retention rate = 80%

# PMF plot
ggplot2::ggplot(data=geo, aes(x=t, y=p)) +
  geom_step() +
  labs(title = 'PMF plot of geometric distributioin',
       x = 'Cancelation Time (t)',
       y= 'Probability P(T=t)') +
  
  theme_classic() +
  theme(plot.title = element_text(size=16, hjust=0.5),
        axis.title.x = element_text(size=14, face="italic"),
        axis.title.y = element_text(size=14, face="italic"),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=12),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank()
  )


# survival function plot
ggplot2::ggplot(data=geo, aes(x=t, y=St)) +
  geom_step() +
  geom_hline(yintercept = .5, linetype = 2) +
  labs(title = 'Survival function plot of geometric distributioin',
       x = 'Cancelation Time (t)',
       y= 'Survival Function S(t)') +
  theme_classic() +
  theme(plot.title = element_text(size=16, hjust=0.5),
        axis.title.x = element_text(size=14, face="italic"),
        axis.title.y = element_text(size=14, face="italic"),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=12),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank()
  )

# --- retention rate = 90%

# PMF plot
ggplot2::ggplot(data=geo, aes(x=t, y=p2)) +
  geom_step() +
  labs(title = 'PMF plot of geometric distributioin',
       x = 'Cancelation Time (t)',
       y= 'Probability P(T=t)') +
  
  theme_classic() +
  theme(plot.title = element_text(size=16, hjust=0.5),
        axis.title.x = element_text(size=14, face="italic"),
        axis.title.y = element_text(size=14, face="italic"),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=12),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank()
  )


# survival function plot
ggplot2::ggplot(data=geo, aes(x=t, y=St2)) +
  geom_step() +
  geom_hline(yintercept = .5, linetype = 2) +
  labs(title = 'Survival function plot of geometric distributioin',
       x = 'Cancelation Time (t)',
       y= 'Survival Function S(t)') +
  theme_classic() +
  theme(plot.title = element_text(size=16, hjust=0.5),
        axis.title.x = element_text(size=14, face="italic"),
        axis.title.y = element_text(size=14, face="italic"),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=12),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank()
  )


#===============================
#--- Example 4
#===============================

# creating dataset

clv <- data.frame("r" = as.numeric(), 
                  "Et" = as.numeric(), 
                  "Eclv" = as.numeric())


for (i in 70:98) {
  
  r = i/100
  Et = 1/(1-r)
  Eclv = round(25*1.01/(1.01-r),2)
  
  clv[i-69, ] <- c(r, Et, Eclv)
  
}

# short summary
clv %>% dplyr::filter(((100*r) %% 5 == 0) | r == .98)


# survival function plot
ggplot2::ggplot(data=clv, aes(x=r, y=Eclv)) +
  geom_line() +
  labs(title = 'Retention rate change impact',
       x = 'Retention Rate (r)',
       y= 'E(clv) [$]') +
  theme_classic() +
  theme(plot.title = element_text(size=16, hjust=0.5),
        axis.title.x = element_text(size=14, face="italic"),
        axis.title.y = element_text(size=14, face="italic"),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=12),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank()
  )


#===============================
#--- Example 5
#===============================

# creating dataset
service1yr <- data_frame(bigT   = c(2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 1, 3, 4, 5,  6,  7,  8,  9, 10, 11,  12), 
                         cancel = c(1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1, 0, 0, 0, 0,  0,  0,  0,  0,  0,  0,   0), 
                         count  = c(4, 16, 20, 37, 28, 61, 24, 19, 13, 10, 13, 3, 2, 1, 7, 33, 49, 63, 30, 16, 34, 188))


# descriptive statistics
summary(service1yr)

service1yr %>% summarise(weighted_sum_cancel = sum(cancel*count),
                         weighted_sum_bigT = sum(bigT*count))

# estimating retention rate

# cancels - Number Cancels
# flips - Opportunities to Cancel
# Rhat - Retention Rate (r)
# ET - E(T)
# median - Median(T)

service1yr %>% 
  dplyr::summarise(cancels = sum(cancel*count),
                         flips = sum(bigT*count),
                         Rhat = 1 - sum(cancel*count)/sum(bigT*count)) %>%
  dplyr::mutate(ET = 1/(1-Rhat),
                median = 1+log(.5)/log(Rhat))
  

#===============================
#--- Example 7
#===============================

# importing dataset
service5yr <- read.csv2(file = "SERVICE5YR.csv", sep = ";", header = T)

head(service5yr, 10)



# Estimation with with Kaplan-Meier method*/
model <- survival::survfit(Surv(bigT, cancel) ~ 1,
                           data = service5yr, 
                           weights = count)

# model summary
model
summary(model)

survminer::ggsurvplot(model,
           conf.int = TRUE, # show confidence intervals
           surv.median.line = "hv", # how to show lifetime median (here: horizontal & vertical lines)
           ggtheme = theme_bw())



# Comparing estimates from SRM and GRM

model_data <- data_frame(bigT = model$time, survival = model$surv)
model_data <- model_data %>% 
  dplyr::mutate(rhat = 1 - 44367/1073935,
                clv = survival*23.20/(1.01^(bigT-1))) %>%
  dplyr::mutate(survSRM = (rhat)^(bigT-1),
                clvSRM = 23.20*(rhat/1.01)^(bigT-1)) %>%
  dplyr::select(bigT, survival, survSRM, clv, clvSRM)

model_data


#===============================
#--- Example 8
#===============================

# Estimating Kaplan-Meier model with stratification
model2 <- survival::survfit(Surv(bigT, cancel) ~ startlen,
                           data = service5yr, 
                           weights = count)

model2
summary(model2)

# extended plot
ggsurvplot(model2,
           pval = TRUE, # p-value of test for homogeneity 
           pval.method = TRUE, # show name of the homogeneity test method
           conf.int = TRUE, # show confidence intervals
           linetype = "strata", # plot by strata
           surv.median.line = "hv", # how to show lifetime median (here: horizontal & vertical lines)
           ggtheme = theme_bw())


# Comparing estimates in strata
model2_data <- model2 %>%
  broom::tidy() 

model2_data %>%
  dplyr::rename(bigT = time,
                survival = estimate) %>%
  dplyr::mutate(clv = survival*23.20/(1.01^(bigT-1))) %>%
  dplyr::select(bigT, survival, clv, strata) %>%
  dplyr::group_by(strata) %>%
  dplyr::summarise(expected_income = sum(clv))