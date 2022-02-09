/*import*/
proc import datafile = '/home/u50020908/sasuser.v94/Data/r01.csv'
	out = df
	dbms = CSV
	replace;
run;

proc corr data=df noprob outp=OutCorr /** store results **/
          nomiss /** listwise deletion of missing values **/
          cov;   /**  include covariances **/
var y1 y4 y6;
run;

proc corr data=df cov plots(only)=(matrix);

    var y1 y4 y6;
					ods output Cov=CovP PearsonCorr=CorrP;
run;