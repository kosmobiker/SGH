#--- clearing working space
rm(list=ls())

#--- setting working directory
setwd("C:/ABA")


#--- importing required packages
# install.packages(c("ggplot2", "dplyr", "lubridate", "stats", "lmtest", "DescTools"))
library(ggplot2) # data visualisation
library(dplyr) # popular package for data manipulation
library(lubridate) # here: operating on dates
library(stats) # R statistical functions
library(lmtest) # for model testing
library(DescTools) # Tools for Descriptive Statistics and Exploratory Data Analysis


#==========================================================================
#--- USEFUL MATERIALS

# Malthouse 2009, Chapter 6 - Data-Mining Approaches to Lifetime Value

#==========================================================================


#----------------------------------  DATA-MINING APPROACH  ----------------------------------#


#===============================
#--- Example 1
#===============================


# importing dataset
df <- read.csv2("TRANS.csv", header = T, stringsAsFactors = F, sep = ";")

# changing system settings to convert giftdate
lct <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME", "C")



#---------------------------------------
# Computing RMF

rollup <- df %>%
  dplyr::mutate(data = as.Date(x = giftdate, format = '%d%b%Y'), # converting giftdate
                diff1 = lubridate::time_length(difftime(as.Date(x = '31AUG2004', format = '%d%b%Y'), data), "years"),
                diff2 = lubridate::time_length(difftime(as.Date(x = '31AUG2006', format = '%d%b%Y'), data), "years"),
                amt =  as.numeric(amt)) %>%
  dplyr::arrange(id, data) %>%
  group_by(id) %>%
  
  dplyr::mutate(ltr = ifelse(diff1 < 0, amt, 0),
                
                r4 = ifelse(diff1 >= 0, diff1, 9999),
                r6 = ifelse(diff2 >= 0, diff2, 9999),
                
                f4 = ifelse(diff1 < 0, 0, 1),
                f6 = ifelse(diff2 < 0, 0, 1),
                
                m4 = ifelse(diff1 < 0, 0, amt),
                m6 = ifelse(diff2 < 0, 0, amt),
                
                ) %>%
  
  dplyr::mutate(ltr = cumsum(ltr),
                r4 = ifelse(diff1 >= 0, r4, min(r4)),
                r6 = ifelse(diff2 >= 0, r6, min(r6)),
                f4 = cumsum(f4),
                f6 = cumsum(f6),
                m4 = cumsum(m4),
                m6 = cumsum(m6)) %>%
  
  dplyr::filter(row_number() == n()) %>%
  dplyr::select(id, ltr, r4, f4, m4, r6, f6, m6) %>%
  
  # data for histogram
  dplyr::mutate(logltr = log(ltr+1))



# Histogram of log(ltr+1)
ggplot2::ggplot(data=rollup, aes(x=logltr)) +
  geom_histogram(aes(y=..density..), col = "white", fill = "steelblue2") +
  labs(title = 'Histogram of log(ltr+1)',
       x = 'log(ltr+1)') +
  theme_light() +
  theme(plot.title = element_text(size=16, hjust=0.5),
        axis.title.x = element_text(size=14, face="italic"),
        axis.title.y = element_text(size=14, face="italic"),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=12),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank()
  )


# Histogram for ltr>0
ggplot2::ggplot(data=rollup[which(rollup$ltr>0),], aes(x=logltr)) +
  geom_histogram(aes(y=..density..), col = "white", fill = "steelblue2") +
  labs(title = 'Histogram for ltr>0',
       x = 'log(ltr+1), where ltr>0') +
  theme_light() +
  theme(plot.title = element_text(size=16, hjust=0.5),
        axis.title.x = element_text(size=14, face="italic"),
        axis.title.y = element_text(size=14, face="italic"),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=12),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank()
  )



#===============================
#--- Example 2
#===============================

#---------------------------------------
# Creating variables for the two-step model

rollup2 <- rollup %>% 
  dplyr::select(id, r4, r6) %>%
  tidyr::gather(key = "yr", value = "r", starts_with('r')) %>%
  dplyr::arrange(id) %>%
  dplyr::mutate(yr = recode_factor(yr,
                              "r4" =  "2004",
                              "r6" = "2006")) %>%
  dplyr::left_join(rollup, by = "id") %>%
  dplyr::mutate(logf = log(ifelse(yr == '2004', f4, f6)+1),
                logm = log(ifelse(yr == '2004', m4, m6)+1),
                logtarg = ifelse(yr=="2004", log(ltr+1), NA),
                targbuy = ifelse(yr=="2004", ifelse(ltr>0, 1, 0), NA)) %>%
  dplyr::select(id, ltr, yr, r, logf, logm, logtarg, targbuy) %>%
  dplyr::arrange(id, yr) %>%
  dplyr::ungroup() %>%
  dplyr::mutate(rownum=row_number())



#---------------------------------------
# logistic model

model_logit <- glm(formula = targbuy ~ r + logf + logm,
                          data = rollup2,
                          family = binomial(link = "logit"),
                          na.action = na.omit)

# model summary
summary(model_logit)

# analysing the table  of deviance
stats::anova(model_logit, test="Chisq")

# Likelihood Ratio Test of Nested Models
lmtest::lrtest(model_logit)
lmtest::waldtest(model_logit, test = "F")
lmtest::waldtest(model_logit, test = "Chisq")


# verifying model quality
DescTools::PseudoR2(model_logit, which = c("Nagelkerke", "AIC", "BIC", "logLik"))



#---------------------------------------
# regression model


# see correlation first
cor_data <- rollup2[,5:8] %>% dplyr::filter(targbuy == 1)
stats::cor(cor_data[,1:3], method = 'pearson')


# create model
model_reg <- lm(formula = logtarg ~ r + logf + logm,
                data = rollup2,
                weights = targbuy,
                na.action = na.omit)


#---------------------------------------
# models' predictions

rollup2$phat <- stats::predict(model_logit, type = "response", newdata = rollup2)
rollup2$yhat <- stats::predict(model_reg, type = "response", newdata = rollup2)
rollup2$answer <- rollup2$phat*(exp(rollup2$yhat+0.47246/2)-1)


#---------------------------------------
# calculating summed CLV

rollup2 %>% dplyr::filter(yr=='2006') %>%
  dplyr::summarise(n = n(),
            sum = sum(answer))


#===============================
#--- Example 3
#===============================


answer_data <- rollup2 %>% 
  
  # --> preparing data - assigning observations to groups based on percentiles
  dplyr::mutate(rank = rank(answer)/n(),
         decile = case_when(
                    rank(answer)/n() < .1 ~ 10,
                    rank(answer)/n() >= .1 & rank(answer)/n() < .2  ~ 9,
                    rank(answer)/n() >= .2 & rank(answer)/n() < .3  ~ 8,
                    rank(answer)/n() >= .3 & rank(answer)/n() < .4  ~ 7,
                    rank(answer)/n() >= .4 & rank(answer)/n() < .5  ~ 6,
                    rank(answer)/n() >= .5 & rank(answer)/n() < .6  ~ 5,
                    rank(answer)/n() >= .6 & rank(answer)/n() < .7  ~ 4,
                    rank(answer)/n() >= .7 & rank(answer)/n() < .8  ~ 3,
                    rank(answer)/n() >= .8 & rank(answer)/n() < .9  ~ 2,
                    rank(answer)/n() >= .9 ~ 1)
  ) %>%
  dplyr::group_by(decile) %>%
  
  # --> creating gains table
  
  # actual reveue by decile
  dplyr::summarise(n = n(),
            total = sum(ltr),
            mean = mean(ltr)
    
  ) %>%
  # cumulative revenue
  dplyr::mutate(cumn = cumsum(n),
         cumsum = cumsum(total),
         cummean = cummean(mean))

  
# options(scipen = 999)

