#--- clearing working space
rm(list=ls())

#--- setting working directory
setwd("C:/ABA")

#============================
#--- loading packages
#============================
# install.packages(c("ggplot2", "ggfortify", factoextra", "readxl", "dplyr", "survival", "survminer", "flexsurv"))
library(ggplot2) # data visualisation
library(ggfortify) # for autoplots
library(factoextra) # cluster analysis & segmentation package
library(readxl) # for importing excel files
library(dplyr) # data manipulation
library(survival) # basic package for survival analysis
library(survminer) # for summarizing and visualizing the results of survival analysis
library(flexsurv) # for parametric survival analysis


#==========================================================================
#--- PRZYDATNE MATERIA£Y

# https://rviews.rstudio.com/2017/09/25/survival-analysis-with-r/
# https://uc-r.github.io/kmeans_clustering

#==========================================================================


#===============================================================
# Evaluating apropriate number of clusters with k-means method
#===============================================================
set.seed(12345)
x=matrix(rnorm(100*2),100,2)

x[1:100,]

plot(x,pch=19)

which=sample(1:3,100,replace=TRUE)

xmean=matrix(rnorm(3*2,sd=4),3,2)

xclusterd=x+xmean[which,]
plot(xclusterd,col=which,pch=19)


#-----------------------------------
#--- Elbow method
#-----------------------------------

factoextra::fviz_nbclust( # distance calculated by default using the Euclidean method
  x = xclusterd,
  method = "wss", # total within sum of square
  FUNcluster = kmeans)  +
  ggplot2::geom_vline(xintercept = 3, linetype = 2)


#-----------------------------------
#--- Silhouette method
#-----------------------------------


#--- METHOD DESCRIPTION

# The Silhouette Coefficient is calculated using the mean intra-cluster distance (a) and the mean nearest-cluster distance (b) for each sample.
# The Silhouette Coefficient for a sample is (b - a) / max(a, b). To clarify, b is the distance between a sample and the nearest cluster 
# that the sample is not a part of. Note that Silhouette Coefficient is only defined if number of labels is 2 <= n_labels <= n_samples - 1.
 
# This function returns the mean Silhouette Coefficient over all samples. To obtain the values for each sample, use silhouette_samples.

# The best value is 1 and the worst value is -1. Values near 0 indicate overlapping clusters. 
# Negative values generally indicate that a sample has been assigned to the wrong cluster, as a different cluster is more similar.


#--- APPLICATION

factoextra::fviz_nbclust(
  x = xclusterd,
  method = "silhouette", # Silhouette method
  FUNcluster = kmeans)  +
  ggplot2::geom_vline(xintercept = 3, linetype = 2)


#-----------------------------------
#--- Gap Statistics method
#-----------------------------------

#--- METHOD DESCRIPTION
# Gap statistics measures how different the total within intra-cluster variation can be between observed data and reference data with a random uniform distribution. 
# A large gap statistics means the clustering structure is very far away from the random uniform distribution of points.

# The basic idea of the Gap Statistics is to choose the number of K, where the biggest jump in within-cluster distance occurred, 
# based on the overall behavior of uniformly drawn samples.


#--- APPLICATION

factoextra::fviz_nbclust( # dystans obliczany domyœlnie metod¹ euklidesow¹
  x = xclusterd,
  method = "gap_stat", # Gap Statistics
  FUNcluster = kmeans)  +
  ggplot2::geom_vline(xintercept = 3, linetype = 2)


#=====================================
# RFM Segmentation
#=====================================

#-----------------------------------------

# RFM is a abbreviation for Recency, Frequency i Monetary and it's helpful when assesing customer value for the business pomaga on oceniæ wartoœæ danego klienta dla danego biznesu.
  # Recency - how much time has passed since the last user conversion?
  # Frequency - how often does the user convert (buy a product)?
  # Monetary value - what is the value of the customer so far?

# The value of the RFM index for store customers will be higher when:
  # -> less time has passed since the last purchase,
  # -> more often a person buys in a store,
  # -> more the given customer has spent in the store.

#-----------------------------------------

#--- dataset import
src <- 'https://archive.ics.uci.edu/ml/machine-learning-databases/00352/Online%20Retail.xlsx'
lcl <- sub(x = basename(src), pattern = '%20', replacement = '_')
download.file(url = src, destfile = lcl, mode = "wb")

df = readxl::read_excel(lcl)


head(df, 10)

maxDate <-  max(df$InvoiceDate) + 1*24*60*60

df_agg <- df %>%
  dplyr::mutate(TotalSum = Quantity*UnitPrice) %>%
  dplyr::group_by(CustomerID) %>%
  dplyr::summarise(InvoiceDate = floor(maxDate - max(InvoiceDate)),
                   InvoiceNo = n(),
                   TotalSum = sum(TotalSum)) %>%
  dplyr::rename(Recency = InvoiceDate,
                Frequency = InvoiceNo,
                MonetaryValue = TotalSum)

df_agg <- df_agg %>%
  mutate(R = ntile(x = desc(Recency), n = 5),
         F = ntile(x = Frequency, n = 5),
         M = ntile(x = MonetaryValue, n = 5))

ggplot2::ggplot(data = df_agg, aes(x=Recency)) +
  geom_histogram(binwidth = 50) +
  theme_light() +
  theme(plot.title = element_text(size=16, hjust=0.5),
        axis.title.x = element_text(size=14, face="italic"),
        axis.title.y = element_text(size=14, face="italic"),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=12),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank()
  )

options(scipen=999)

ggplot2::ggplot(data = df_agg, aes(x=Frequency)) +
  geom_histogram(binwidth = 1000) +
  theme_light() +
  theme(plot.title = element_text(size=16, hjust=0.5),
        axis.title.x = element_text(size=14, face="italic"),
        axis.title.y = element_text(size=14, face="italic"),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=12),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank()
  )

ggplot2::ggplot(data = df_agg, aes(x=MonetaryValue)) +
  geom_histogram(binwidth = 50000) +
  theme_light() +
  theme(plot.title = element_text(size=16, hjust=0.5),
        axis.title.x = element_text(size=14, face="italic"),
        axis.title.y = element_text(size=14, face="italic"),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=12),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank()
  )


# data normalization

df_normalized <- df_agg %>% 
  dplyr::select(Recency, Frequency, MonetaryValue) %>%
  dplyr::mutate(Recency = scale(Recency),
                Frequency = scale(Frequency),
                MonetaryValue = scale(MonetaryValue))


# evaluation of the appropriate number of clusters
factoextra::fviz_nbclust(
  x = df_normalized,
  method = "wss",  # Silhouette method
  FUNcluster = kmeans)  

factoextra::fviz_nbclust(
  x = df_normalized,
  method = "silhouette",  # Silhouette method
  FUNcluster = kmeans)  


# segmentation with chosen number of clusters
model_seg <- stats::kmeans(x = df_normalized, 
                           centers = 3,
                           iter.max = 4,
                           nstart = 10 # 10 different initial configurations
)

# model summary
str(model_seg)
model_seg

# segmentation visualisation
factoextra::fviz_cluster(object = model_seg, 
                         data = df_normalized, 
                         geom = "point", 
                         stand = T, # is standardization to be performed?
                         show.clust.cent = T # are cluster centers to be shown in the plot?
) +
  theme_light()

# identification of oultier
which(model_seg$cluster == 1)


# --- re-clustering after removing outliers

# data normalization
df_normalized <- df_agg %>% 
  dplyr::slice(-which(model_seg$cluster == 1)) %>%
  dplyr::select(Recency, Frequency, MonetaryValue) %>%
  dplyr::mutate(Recency = scale(Recency),
                Frequency = scale(Frequency),
                MonetaryValue = scale(MonetaryValue))


# evaluating appropriate number of clusters
factoextra::fviz_nbclust(
  x = df_normalized,
  method = "wss",  # Silhouette method
  FUNcluster = kmeans)  

factoextra::fviz_nbclust(
  x = df_normalized,
  method = "silhouette",  # Silhouette method
  FUNcluster = kmeans)  


# segmentation with chosen number of clusters
model_seg <- stats::kmeans(x = df_normalized, 
                           centers = 4,
                           iter.max = 4,
                           nstart = 10 # 10 ró¿nych konfiguracji pocz¹tkowych
)

# model summary
str(model_seg)
model_seg

# segmenattion visualisation
factoextra::fviz_cluster(object = model_seg, 
                         data = df_normalized, 
                         geom = "point", 
                         stand = T, # czy ma byæ wykonana standaryzacja
                         show.clust.cent = T # czy pokazaæ centra klastrów
) +
  theme_light()


#===============================================================
# Survival models - nonparametric (reminer)
#===============================================================

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


#--- sex as qualitative variable
df2 <- lung
df2$sex <- as.factor(df2$sex)

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




#==============   SURVIVAL ANALYSIS - Kaplan-Meier method   ==============#

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



#======================================================
# Survival models - parametric (introduction)
#======================================================

#--- exponential model

model_exp <- flexsurv::flexsurvreg(Surv(time, status) ~ sex, data = df2, 
                                       dist='exp')

model_exp2 <- flexsurv::flexsurvreg(Surv(time, status) ~ sex, data = lung, 
                                   dist='exp')

# survival function plot by sex
ggflexsurvplot(model_exp, fun = "survival")

# cumulated hazard plot by sex
ggflexsurvplot(model_exp, fun = "cumhaz")


# general survival function plot
plot_exp_s <- ggflexsurvplot(model_exp2, fun = "survival")
plot_exp_s


#--- Weibull model
model_weibull <- flexsurv::flexsurvreg(Surv(time, status) ~ sex, data = lung, 
                                       dist='weibull')

# survival function plot
plot_weibull_s <- ggflexsurvplot(model_weibull, fun = "survival")
plot_weibull_s

# both models on one plot
arrange_ggsurvplots(list(plot_exp_s, plot_weibull_s))
