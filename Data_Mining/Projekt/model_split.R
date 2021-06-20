rm(list=ls())

library('caret')
library('gdata')

#upload data
data <- read.csv(
        file='../../data/data_dm_project/bank-additional-full.csv',
        sep=";",
        stringsAsFactors = F)


set.seed(12345)

data <- unknownToNA(data, unknown='unknown')

#split into two parts 75/25 
#part_1 - train (60%) and validate (15%), part_2 - test (20%) and holdout(5%)
ind = createDataPartition(data$y,
                          times = 1,
                          p = 0.95,
                          list = F)
part_1 =data[ind, ]
part_2 = data[-ind, ]

ind2 = createDataPartition(part_1$y,
                           times = 1,
                           p = 0.8,
                           list = F)
train_data =part_1[ind2, ]
validate_data = part_1[-ind2, ]

ind3 = createDataPartition(part_2$y,
                           times = 1,
                           p = 0.8,
                           list = F)
test_data =part_2[ind3, ]
holdout_data = part_2[-ind3, ]

#check
dim(train_data)[1] + dim(validate_data)[1] + dim(test_data)[1] + dim(holdout_data)[1] == dim(data)[1]
#distribution of the target variable
table(data$y)/dim(data)[1]
table(train_data$y)/dim(train_data)[1]
table(validate_data$y)/dim(validate_data)[1]
table(test_data$y)/dim(test_data)[1]
table(holdout_data$y)/dim(holdout_data)[1]

#create files
write.csv(part_1, 'data_95_withNA.csv')
write.csv(part_2, 'data_5_withNA.csv')
write.csv(test_data, 'test_data.csv')
write.csv(holdout_data, 'holdout_data.csv')

