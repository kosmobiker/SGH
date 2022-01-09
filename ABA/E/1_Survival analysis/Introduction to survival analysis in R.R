#--- clearing working space
rm(list=ls())

#--- setting working directory
setwd("C:/ABA")


#--- importing required packages
# install.packages(c("ggplot2", "ggfortify", "survival", "survminer"))
library(ggplot2) # popular data visualisation package
library(ggfortify) # add-on to ggplot2 package allowing to generate plots from survival package
library(survival) # basic package for survival analysis
library(survminer) # package for summarizing and visualizing the results of survival analysis


#==========================================================================
#--- USEFUL MATERIALS

# https://rviews.rstudio.com/2017/09/25/survival-analysis-with-r/
# https://www.routledge.com/Joint-Models-for-Longitudinal-and-Time-to-Event-Data-With-Applications/Rizopoulos/p/book/9781439872864

#==========================================================================


#--- dataset

data(cancer, package="survival") # dataset import
head(lung, 10) # preview of the first 10 observations

#--- dataset description
?lung

# inst:	Institution code
# time:	Survival time in days
# status:	censoring status 1=censored, 2=dead
# age:	Age in years
# sex:	Male=1 Female=2
# ph.ecog:	ECOG performance score as rated by the physician. 0=asymptomatic, 1= symptomatic but completely ambulatory, 2= in bed <50% of the day, 3= in bed > 50% of the day but not bedbound, 4 = bedbound
# ph.karno:	Karnofsky performance score (bad=0-good=100) rated by physician
# pat.karno:	Karnofsky performance score as rated by patient
# meal.cal:	Calories consumed at meals
# wt.loss:	Weight loss in last six months


#--- basic statistics
summary(lung)

#--- survival time histogram
ggplot(data=lung) +
  geom_histogram(aes(x=time), binwidth = 14, col = "white", fill = "dodgerblue4") +
  labs(title = 'Survival time histogram of lung cancer patients',
       x = 'Time [days]',
       y= 'Number of patients') +
  theme_light() +
  theme(plot.title = element_text(size=16, hjust=0.5),
        axis.title.x = element_text(size=14, face="italic"),
        axis.title.y = element_text(size=14, face="italic"),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=12),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank()
  )


#--- survival time boxplot by sex
ggplot(data=lung) +
  geom_boxplot(aes( y = time)) +
  facet_grid(.~sex) +
  labs(title = "Distribution of lung cancer patients' survival time sex'",
       y= "Survival time [days]") +
  theme_light() +
  theme(plot.title = element_text(size=16, hjust=0.5),
        axis.title.x = element_blank(),
        axis.title.y = element_text(size=14, face="italic"),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size=12),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank()
  )




#==============   SURVIVAL ANALYSIS   ==============#

#--- data preparation
Surv(lung$time, lung$status) # "+" stands for censored observation (right censoring)

#--- estimation of survival function using Kaplan-Meier method
model_km <- survfit(Surv(time, status) ~ 1, data = lung) # 1 - censored case

#--- model results
summary(model_km) 
summary(model_km)$table

#--- survival function plot
ggplot2::autoplot(model_km) + 
  theme_classic()
# median lifetime is the time corresponding to the survival function = 0.5


#--- stratification by sex
model_km_strata <- survfit(Surv(time, status) ~ sex, data = lung)

#--- survival function plot by sex
ggplot2::autoplot(model_km_strata) + 
  theme_classic()


# extended plot
ggsurvplot(model_km_strata,
           pval = TRUE, # p-value of test for homogeneity 
           pval.method = TRUE, # show name of the homogeneity test method
           conf.int = TRUE, # show confidence intervals
           linetype = "strata", # plot by strata
           surv.median.line = "hv", # how to show lifetime median (here: horizontal & vertical lines)
           ggtheme = theme_bw(),
           palette = c("#E7B800", "#2E9FDF"))


# verification of differences between groups - log-rank test
survdiff(Surv(time, status) ~ sex, data = lung)
