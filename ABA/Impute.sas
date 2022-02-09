/*import*/
proc import datafile = '/home/u50020908/sasuser.v94/Data/fg01.csv'
	out = house_price
	dbms = CSV
	replace;
run;

proc mi data=house_price nimpute=0 seed=20224 out=stochastic;
    var X2_HouseAge X3_DistanceFromSub y_unitprice;
run;


/*select data*/
proc mi data=house_price nimpute=30 seed=20224 out=stochastic;
    var X2_HouseAge X3_DistanceFromSub y_unitprice;
    monotone reg(y_unitprice = X2_HouseAge X3_DistanceFromSub / details);
run;