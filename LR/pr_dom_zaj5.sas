ods graphics on;
proc import datafile="C:\Users\Vlad\Documents\SGH\data\data_lr\titanic_train.csv" 
			encoding='UTF-8' dbms=csv out=titanic replace;

proc logistic data=titanic plots=(oddsratio roc) outmodel=modelt;
	class pclass sex;
	model survived(event='1') = pclass sex age sibsp / rsquare;
	output out=outt p=p;
run;

%macro residual(model=,dataIn=,type=,y_var=);
	proc logistic inmodel=&model.;
		score data = &dataIn. out = pred;
	run;
	
	data residual;
		set pred;
		%if &type. eq UNSTD %then %do;
			%let tit = niestandaryzowane;
			res = &y_var. - p_1;
		%end;
		%if &type. eq STD %then %do;
			%let tit = standaryzowane;		
			res = (&y_var. - p_1)/sqrt(p_1*p_0);
		%end;
		%if &type. eq LOG %then %do;
			%let tit = logitowe;		
			res = (&y_var. - p_1)/(p_1*p_0);
		%end;
		obs = _N_;
	run;
	
	ods graphics on;
	title "Reszty &tit. modelu regresji logistycznej";
	proc sgscatter data=residual;
		plot res * obs / group=&y_var.;
	run;
	ods graphics off;
	title;
%mend;

%residual(model=modelt, dataIn=titanic,type=UNSTD,y_var=survived);

%include "C:\Users\mwojte\Desktop\GainLift.sas";
%GainLift(response=survived,event=1,p=p,data=outt,graphopts=NOPANEL);

proc logistic inmodel=modelt;
	score data = titanic out = pred;
run;

proc sort data=pred;
	by descending I_Survived;

%macro treshold(dataIn=,t=);

	data t_pred;
		set &dataIn.;
		if p_1 >= &t. then I_survived = '1';
		else I_survived = '0';
	run;
	
	title "Macierz pomy³ek - próg odciêcia: &t.";
	proc freq data=t_pred order=data;
		table I_survived * survived / outpct out=conf_mat;
	run;
	title;
%mend;

%treshold(dataIn=pred,t=0.3);
%treshold(dataIn=pred,t=0.6);
%treshold(dataIn=pred,t=0.9);

ods graphics off;