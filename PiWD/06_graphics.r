x11()
plot( 0, type="n", xlim=c(0,5), ylim=c(0,5) )
A <- matrix( c( c(1,2,3,4), c(2,1,2,4)), ncol=2 )
B <- matrix( c( c(1,2,3,4), c(1,3,3,2)), ncol=2 )
lines( A, col="red" )
points( A, col="blue", pch=15 )
lines( B, col="green" )
points( B, col="purple", pch=17 )

legend( "topleft", 
        legend=c(
          "Red line, blue points",
          "Green line, purple points"
        ),
        col=c("red","green"), 
        lwd=c(1,1), 
        lty=c(1,2), 
        pch=c(NA,NA) 
        )

legend( x="topleft", 
        legend=c("Red line, blue points","Green line, purple points"),
        col=c("blue","purple"), lwd=1, lty=c(0,0), 
        pch=c(15,17) )

legend( x=2,y=3, 
        legend=c("Red line, blue points","Green line, purple points"),
        col=c("red","green"), lwd=1, lty=c(1,2), 
        pch=c(NA,NA) )


