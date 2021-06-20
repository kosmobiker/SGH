libname a "C:\Users\Vlad\Documents\SGH\data\data_ahz";


ods graphics on;
proc lifetest data=a.lung method=KM alpha=0.05 plots=(survival hazard);
	time dur * surv(0);
	id id;
run;
ods graphics off;

ods graphics on;
proc lifetest data=a.lung method=LIFE alpha=0.05 plots=(survival hazard);
	time dur * surv(0);
	id id;
run;
ods graphics off;

ods graphics on;
proc lifetest data=a.lung method=BRESLOW alpha=0.05 plots=(survival hazard);
	time dur * surv(0);
	id id;
run;
ods graphics off;


ods graphics on;
proc lifetest data=a.lung notable method=KM alpha=0.05 notable
              plots=( survival(cl cb atrisk strata=overlay test) hazard);
	time dur * surv(0);
	id id;
	strata instit / test=(logrank wilcoxon peto);
run;
ods graphics off;

ods graphics on;
proc lifereg data=a.lung plots=probplot;
	model dur * surv(0) = / dist=exponential;
	probplot; 
	inset dist confidence scale shape nobs ;
quit;
ods graphics off;

ods graphics on;
ods output ParameterEstimates=ParameterEstimates Type3Analysis=Type3Analysis;
proc lifereg data=a.lung plots=probplot;
	class instit treat detect stage cell tumor lymph distant operated;  
	model dur * surv(0) = instit treat detect stage cell tumor lymph distant operated/ dist=exponential;
	probplot; 
	inset dist confidence scale shape nobs ;
quit;
ods graphics off;
