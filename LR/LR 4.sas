proc import 
		datafile="/shared/home/ud108519@student.sgh.waw.pl/SGH Projekt/heart.csv"
		dbms=csv 
		out=serce 
		replace;

*Model regresji log. wersja minimumn;
proc logistic data=serce;
	model output(event="1") = age sex cp trtbps chol fbs restecg thalachh exng oldpeak slp caa thall;
run;

*Sprawdzanie dominanty;
proc freq data=serce;
	table thall;

*Model regresji z zmiennymi jakościowymi;
proc logistic data=serce;
	class sex(ref="0") cp fbs restecg exng(ref="0") thall(ref="2") / param = reference;
	model output(event="1") = age sex cp trtbps chol fbs restecg thalachh exng oldpeak slp caa thall;
run;

ods graphics on;
proc logistic data=serce plots=oddsratio outmodel=model1;
	class sex(ref="0") cp fbs restecg exng(ref="0") thall(ref="3") / param = reference;
	model output(event="1") = age sex cp trtbps chol fbs restecg thalachh exng oldpeak slp caa thall
	/ selection = stepwise;
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