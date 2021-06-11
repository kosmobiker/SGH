proc import 
		datafile="/shared/home/ud108519@student.sgh.waw.pl/SGH Projekt/heart.csv"
		dbms=csv 
		out=serce 
		replace;

proc contents data=serce;
run;

proc freq data=serce; 
	table output; 
run;

title "sex vs output";
proc sgplot data=serce pctlevel=group;
vbar sex / group=output stat=percent missing;
label sex = "1 : men,  0 : women";
run;

title "Analysis of Chest Pain";
proc sgplot data=serce;
vbar cp / datalabel missing;
label cp = "Value 1: typical angina Value 2: atypical angina Value 3: non-anginal pain Value 4: asymptomatic";
run;

/* Checking the missing value and Statistics of the dataset */
proc means data=serce 
	N Nmiss mean std min P1 P5 P10 P25 P50 P75 P90 P95 P99 max;
run;

/* Splitting the dataset into traning and validation using 70:30 ratio */
proc surveyselect data = serce out = train_survey outall
samprate = 0.7 seed = 12345;
strata output;
run;

proc freq data = train_survey;
tables Selected*output;
run;

*Model regresji z zmiennymi jakościowymi;
proc logistic data=serce;
	class sex(ref="0") cp fbs restecg exng(ref="0") thall(ref="2") / param = reference;
	model output(event="1") = age sex cp trtbps chol fbs restecg thalachh exng oldpeak slp caa thall;
run;


ods graphics on;
proc logistic data=serce plots=oddsratio outmodel=model1;
	class sex(ref="0") cp(ref='3') slp(ref='2') fbs restecg exng(ref="0") thall(ref="3") / param = reference;
	model output(event="1") = age sex cp trtbps chol fbs restecg thalachh exng oldpeak slp caa thall
	/ selection = stepwise expb stb lackfit;
run;
ods graphics off;


data w;
	set serce(firstobs=1 obs=1);
run;

data z;
	set w;
	output;
	sex = 0;
	output;
run;

proc logistic inmodel=model1;
	score clm data = z out = pred;
run;

data pred;
set pred;
odds = p_1/(1-p_1);
logit = log(p_1/(1-p_1));
run;

*zad1;
proc logistic data=serce outmodel=model2;
	class sex(ref="0") / param = reference;
	model output(event="1") = age sex chol;
run;

*zad2;
data new_pats;
	age = 80;
	sex = 0;
	chol = 95;
	output;
	age = 55;
	sex = 1;
	chol = 180;
	output;
run;

proc logistic inmodel=model2;
	score clm data = new_pats out = pred;
run;