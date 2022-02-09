/*import*/
proc import datafile = '/home/u50020908/sasuser.v94/Data/SERVICE5YR.csv'
	out = retention
	dbms=dlm
   	replace;
   	delimiter=';';
run;

/*lifetable*/
proc lifetest data=retention method=lt intervals=0 to 60 by 1 outsurv=out1 plots=(s,h,p);
time bigT*cancel(0);
freq count;
run;


/*K-M*/
proc lifetest data=retention outsurv=out2;
time bigT*cancel(0);
freq count;
run;


/*SRM vs GRM*/
data res;
	set out2;
	by bigT;
	if bigT>0 and FIRST.bigT;
	rhat=1-44367/1073935;
clv=survival*25/(1.05**(bigT-1));
survSRM=(rhat)**(bigT-1);
clvSRM=25*(rhat/1.05)**(bigT-1);
run;

proc print data=res noobs;
	var bigT survival survSRM clv clvSRM;
	sum clv clvSRM;
format clv clvSRM DOLLAR8.2;
run;

