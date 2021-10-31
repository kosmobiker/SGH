library(tidyverse)
library(ggpubr)
library(SimDesign)


seq_of_probes <- c(100, 500, 1000, 2000, 5000, 10000)
df_res <- data.frame(matrix(ncol = 5, nrow = 0))

for (n in seq_of_probes)
{
  Income  = rgamma(n,2)*1000
  epsilon = rnorm(n, 0, 100)
  a_true = 100
  b_true = 0.1
  Expenditure = a_true + b_true*Income + epsilon
  temp_df <- data.frame(Income, epsilon, Expenditure)
  model <- lm(Expenditure ~ Income, data = temp_df)
  a_pred <- model$coefficients[1][1]
  b_pred <- model$coefficients[2][1]
  df_res <- rbind(df_res, c(n, a_true, a_pred, b_true, b_pred))
}
colnames(df_res) <- c('num', 'a_true', 'a_pred', 'b_true', 'b_pred')
bias_a <- 1/length(df_res$a_pred)*sum(df_res$a_true - df_res$a_pred)
bias_b <- 1/length(df_res$b_pred)*sum(df_res$b_true - df_res$b_pred)
rse_a <-  1/length(df_res$a_pred)*sum(df_res$a_true - df_res$a_pred)^2
rse_b <- 1/length(df_res$b_pred)*sum(df_res$b_true - df_res$b_pred)^2
