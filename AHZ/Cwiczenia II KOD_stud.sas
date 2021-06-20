libname b 'C:\Users\Vlad\Documents\SGH\data\data_ahz';

/*METODY NIEPARAMETRYCZNE*/

/*METODA KAPLANA-MEIERA*/
ods graphics on;
proc lifetest data=b.dane(where=(ranuni(123)<0.01 and product='css')) method=KM alpha=0.05 plots=survival;
	time ttd * rc(0,1);
	id aid cid;
run;
ods graphics off;

/*-----*/
ods graphics on;
proc lifetest data=b.dane(where=(ranuni(123)<0.01 and product='css')) method=LIFE alpha=0.05 plots=survival ;
	time ttd * rc(0,1);
	id aid cid;
run;
ods graphics off;

/*-----*/

ods graphics on;
proc lifetest data=b.dane(where=(ranuni(123)<0.01)) method=KM alpha=0.05 notable
              plots=( survival(cl cb=ep atrisk) hazard ls lls p);
	time ttd * rc(0,1);
	id aid cid;
run;
ods graphics off;

/*TEST*/
ods graphics on;
proc lifetest data=b.dane notable method=KM alpha=0.05 notable
              plots=( survival(cl cb atrisk strata=overlay test) hazard ls lls p);
	time ttd * rc(0,1);
	id aid cid;
	strata product / test=(logrank wilcoxon peto);
run;
ods graphics off;

/*TEST 2*/
ods graphics on;
proc lifetest data=b.dane notable method=KM alpha=0.05 notable
              plots=( survival(cl cb atrisk strata=overlay test) hazard ls lls p);
	time ttd * rc(0,1);
	id aid cid;
	strata app_number_of_children / test=(logrank wilcoxon peto) diff=all adjust=tukey;
run;
ods graphics off;
