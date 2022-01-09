#--- clearing working space
rm(list=ls())

#--- setting working directory
# setwd("C:/ABA")

#============================
#--- importing packages
#============================
# install.packages(c("ggplot2", "gridExtra", "corrplot", "stats", "factoextra"))
library(ggplot2) # data visualisation
library(gridExtra) # for arranging plots
library(corrplot) # correlation visualisation
library(stats) # here: segmentation models
library(factoextra) #  cluster analysis & segmentation package

#==========================================================================
#--- USEFUL MATERIALS

# https://uc-r.github.io/kmeans_clustering

#==========================================================================



#===============================
#--- importing dataset
#===============================
df <- read.csv2("Mall_Customers.csv", sep = ',', stringsAsFactors = F)
 
# data preview
head(df)

# table dimension
dim(df)

# basic statistics statystyki
summary(df)

# changing sex to qualitative variable
df$Genre <- as.factor(df$Genre)


#================================
#--- EDA - data visualisation
#================================

# histogramy
plot1 <- ggplot2::ggplot(data=df, aes(x=Age)) +
  geom_histogram(aes(y=..density..), col = "white", fill = "steelblue2") +
    geom_density(color = "dodgerblue4", size = 1.1) +
  labs(title = 'Age distribution',
       x = 'Age') +
  xlim(0,100) +
  theme_light() +
  theme(plot.title = element_text(size=16, hjust=0.5),
        axis.title.x = element_text(size=14, face="italic"),
        axis.title.y = element_text(size=14, face="italic"),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=12),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank()
  )

plot2 <- ggplot2::ggplot(data=df, aes(x=Annual.Income..k..)) +
  geom_histogram(aes(y=..density..), col = "white", fill = "steelblue2") +
  geom_density(color = "dodgerblue4", size = 1.1) +
  labs(title = 'Annual income distribution',
       x = 'Annual income [$K]') +
  xlim(0,max(df$Annual.Income..k..) + 20) +
  theme_light() +
  theme(plot.title = element_text(size=16, hjust=0.5),
        axis.title.x = element_text(size=14, face="italic"),
        axis.title.y = element_text(size=14, face="italic"),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=12),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank()
  )

plot3 <- ggplot2::ggplot(data=df, aes(x=Spending.Score..1.100.)) +
  geom_histogram(aes(y=..density..), col = "white", fill = "steelblue2") +
  geom_density(color = "dodgerblue4", size = 1.1) +
  labs(title = 'Spending score distribution',
       x = 'Spending score [0-100]') +
  xlim(0,max(df$Spending.Score..1.100.) + 20) +
  theme_light() +
  theme(plot.title = element_text(size=16, hjust=0.5),
        axis.title.x = element_text(size=14, face="italic"),
        axis.title.y = element_text(size=14, face="italic"),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=12),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank()
  )

gridExtra::grid.arrange(plot1, plot2, plot3, ncol=3, nrow=1)


# number of observations by sex
ggplot2::ggplot(data=df, aes(x=Genre)) +
  geom_bar(aes(fill=Genre)) +
  coord_flip() +
  labs(title = 'Number of observations by sex',
       x = 'Sex',
       y='Number of observations') +
  ylim(0,120) +
  theme_light() +
  theme(plot.title = element_text(size=16, hjust=0.5),
        axis.title.x = element_text(size=14, face="italic"),
        axis.title.y = element_text(size=14, face="italic"),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=12),
        legend.position = "none",
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank()
  )


# relationship between quantitative variables (age, income, spendings)
f_scatterplot <- function(zbior, x, y){
  
  ggplot2::ggplot(data=zbior, aes(y=zbior[,y], x=zbior[,x])) +
    geom_point(col = "steelblue2") +
    geom_smooth(method=lm, color="steelblue2") +
    labs(y=colnames(zbior[y]),
         x=colnames(zbior[x])) +
    theme_light() +
    theme(plot.title = element_text(size=16, hjust=0.5),
          axis.title.x = element_text(size=14, face="italic"),
          axis.title.y = element_text(size=14, face="italic"),
          axis.text.x = element_text(size=12),
          axis.text.y = element_text(size=12)
    )
  
}

gridExtra::grid.arrange(ncol=3, nrow=3,
                        f_scatterplot(zbior=df, x=3, y=3), f_scatterplot(zbior=df, x=4, y=3), f_scatterplot(zbior=df, x=5, y=3),
                        f_scatterplot(zbior=df, x=3, y=4), f_scatterplot(zbior=df, x=4, y=4), f_scatterplot(zbior=df, x=5, y=4),
                        f_scatterplot(zbior=df, x=3, y=5), f_scatterplot(zbior=df, x=4, y=5), f_scatterplot(zbior=df, x=5, y=5)
                        )

cor_df <- cor(df[,3:5])
cor_df_p <-cor.mtest(df[,3:5], conf.level = 0.95)

# correlation between quantitative variables
corrplot(cor_df, method = 'square', p.mat = cor_df_p$p, addCoef.col ='black', number.cex = 0.8, order = 'AOE')



f_scatterplot_gender <- function(zbior, x, y){
  
  ggplot2::ggplot(data=zbior, aes(y=zbior[,y], x=zbior[,x])) +
    geom_point(aes(col=Genre)) +
    labs(y=colnames(zbior[y]),
         x=colnames(zbior[x])) +
    theme_light() +
    theme(plot.title = element_text(size=16, hjust=0.5),
          axis.title.x = element_text(size=14, face="italic"),
          axis.title.y = element_text(size=14, face="italic"),
          axis.text.x = element_text(size=12),
          axis.text.y = element_text(size=12)
    )
  
}


gridExtra::grid.arrange(ncol=3, nrow=3,
                        f_scatterplot_gender(zbior=df, x=3, y=3), f_scatterplot_gender(zbior=df, x=4, y=3), f_scatterplot_gender(zbior=df, x=5, y=3),
                        f_scatterplot_gender(zbior=df, x=3, y=4), f_scatterplot_gender(zbior=df, x=4, y=4), f_scatterplot_gender(zbior=df, x=5, y=4),
                        f_scatterplot_gender(zbior=df, x=3, y=5), f_scatterplot_gender(zbior=df, x=4, y=5), f_scatterplot_gender(zbior=df, x=5, y=5)
)


# distribution of quantitative variables by sex
f_boxplot_gender <- function(zbior, y){
  
  ggplot2::ggplot(data=zbior, aes(y=zbior[,y], x=zbior[,2])) +
    geom_violin(aes(fill=Genre), trim=F, alpha = 0.5) +
    geom_jitter(height = 0, width = 0.1, aes(col=Genre)) +
    labs(y=colnames(zbior[y]),
         x=colnames(zbior[2])) +
    coord_flip() +
    theme_light() +
    theme(plot.title = element_text(size=16, hjust=0.5),
          axis.title.x = element_text(size=14, face="italic"),
          axis.title.y = element_text(size=14, face="italic"),
          axis.text.x = element_text(size=12),
          axis.text.y = element_text(size=12),
          legend.position = "none"
    )
  
}

gridExtra::grid.arrange(ncol=3, nrow=1,
                        f_boxplot_gender(zbior=df, y=3), f_boxplot_gender(zbior=df, y=4), f_boxplot_gender(zbior=df, y=5)
)


#=================================================================
#--- Segmentation using k-means method - by age and income
#=================================================================

# choosing wybranie wektora o analizy skupie?

X1 <- df[, c("Age", "Spending.Score..1.100.")]

# relationship between variables (reminder)
f_scatterplot(zbior = X1, x = 1, y =2)


#--- ELBOW METHOD - stepsi:
# 1. Calculate the clustering algorithm (e.g. k-means) for different k values ??????- e.g. for k from 1 to 10 clusters
# 2. For each k, calculate the total within-cluster sum of square / sum of squared errors (SSE)
# 3. Plot SSE curve showing SSE for different number of clusters k.
# 4. The location of a bend (knee) in the plot is generally considered as an indicator of the appropriate number of clusters.


# evaluating approperiate number of clusters
factoextra::fviz_nbclust( # distance calculated by default using the Euclidean method
  x = X1,
  method = "wss", # SSE - elbow method
  FUNcluster = kmeans)  +
  geom_vline(xintercept = 4, linetype = 2)

model_seg <- stats::kmeans(x = X1, 
                           centers = 4,
                           iter.max = 4,
                           nstart = 10 # 10 different initial configurations
                           )

# model summary
str(model_seg)
model_seg

# segmentation visualisation
factoextra::fviz_cluster(object = model_seg, 
                         data = X1, 
                         geom = "point", 
                         stand = F, # is standardization to be performed?
                         show.clust.cent = T # are cluster centers to be shown in the plot?
                         ) +
  theme_light()
