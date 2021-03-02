rm(list=ls())
df <- read.table(file="../data/data_pwid/TemperaturaZakopane.csv",
                        sep=";",dec=",",
                        header=T
) 

str(df)
