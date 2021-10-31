set.seed(1234)
RW <- function(N, x0, mu, variance) {
  z<-cumsum(rnorm(n=N, 
                  mean=0, 
                  sd=sqrt(variance)))
  t<-1:N
  x<-x0+t*mu+z
  return(x)
}

P1<-RW(10000, 0, 0.005, 1)
P2<-RW(10000, 0, 0.005, 1)
P3<-RW(10000, 0, 0.005, 1)

df <- data.frame(P1, P2, P3)

img1 <- ggplot(data=df, aes(x=as.numeric(row.names(df)))) + 
      geom_line(aes(y=P1), color='red', size=0.5) + 
      geom_line(aes(y=P2), color='blue', size=0.5) + 
      geom_line(aes(y=P3), color='green', size=0.5) + 
      xlab("X") + ylab("Y")

print(img1)       
