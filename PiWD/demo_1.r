# czyszczenie srodowiska ze wszystkich zmiennych 
rm(list=ls())

getwd()
#setwd()

install.packages("zoo", dependencies = T)
library("ggplot2")

print(cars)

print(head(cars,3))
print(tail(cars,3))
print(class(cars))
print(str(cars))
print(dim(cars))
print(ncol(cars))
print(nrow(cars))
print(colnames(cars))


# zapis do pliku 
write.table(
  cars,
  file="cars.csv",
  sep=";",
  dec=",",
  row.names=F
)

# # CTRL + SHIFT + C - komentowanie wielu linii 
# print(head(cars,3))
# print(tail(cars,3))
# print(class(cars))
# print(dim(cars))
# print(nrow(cars))
# print(ncol(cars))
# print(colnames(cars))
# 
# odpowolywanie po indeksach
print( cars[ , 1 ] )
print( cars[1,  ] )
# 
# # odwolywanie sie po nazwach kolumn
# print( cars$speed )


# odczyt danych z csv
moje_dane <- read.table(file="cars.csv",
                        sep=";",dec=",",
                        header=T
                        ) 
# save(), load()

# listowanie zmiennych ze srodowiska 
print(ls())


mojaPieknaFnkcja <- function(arg_1,arg_2){
  
  for(i in  seq(from=arg_1,to=arg_2,by=13) ){
    if(i<20){
      print(i)
      print("***")
    }else{
      print(i)
      print("###")
    }
    
  }

  return("Ala ma kota")
  
}

mojaPieknaFnkcja(1, 100)



print("Hello PiWD!!!")

hist(rnorm(1000),breaks=100,col="blue")

print("Ala"); print("ma"); print("kota")

N <- 10 
napis <- paste("Ala ma ",N," kotow")

print(napis)


