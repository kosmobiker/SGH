/*import*/
proc import datafile = '/home/u50020908/sasuser.v94/Data/beeps2005.csv'
	out = work.beeps
	dbms = CSV
	replace;
run;
/*select data*/
proc sql;
	create table df as
	select idstd as id, case 
							when a1 = 50 then 'Belarus'
							when a1 = 54 then 'Ukraine'
							when a1 = 59 then 'Poland'
							when a1 = 70 then 'Estonia'
							when a1 = 72 then 'Czechia'
							when a1 = 73 then 'Hungary'
							when a1 = 74 then 'Latvia'
							when a1 = 75 then 'Lithuania'
							when a1 = 76 then 'Slovakia'
						end as country,
						case
							when s5b >= 50 then 1
							when s5b < 50 then 0
						end as foreign_capital,
				q43a as taxes,
				q57a as total_profit,
				log(q43a) as log_taxes,
				log(q57a) as log_total_profit,
						case
							when q43a IS NULL then 0
							when q43a IS NOT NULL then 1
						end as missing_taxes,
						case
							when q57a IS NULL then 0
							when q57a IS NOT NULL then 1
						end as missing_total_profit						
	from work.beeps
	where a1 in (50, 54, 59, 70, 72, 73, 74, 75, 76);
quit;

/*printing into rtf-file */
ods rtf file="/home/u50020908/sasuser.v94/SGH/temp/report.rtf" style=htmlblue;
/*number of missing values for variables*/
proc freq data=df;
	tables country foreign_capital missing_taxes missing_total_profit;
run;

/*Initial model - complete case analysis*/
proc mixed data=df;
	class country foreign_capital;
	model log_total_profit = log_taxes country log_taxes*foreign_capital foreign_capital/ solution covb;
	lsmeans foreign_capital / diff=all adjust=tukey;
	ods output SOLUTIONF=parms01 CovB=mixovb LSMEANS=lsm01 DIFFS=lsmdiffs01;
run;


proc means data=df n mean stderr lclm uclm alpha=0.05 min max;
	var total_profit taxes;
run;

/*Imputation step*/
proc mi data=df out=df1 nimpute=100 noprint seed=1234;
	var log_total_profit log_taxes foreign_capital;
	mcmc initial=em;
run;

/*model after proc mi - complete case analysis*/
proc mixed data=df1;
	class country foreign_capital;
	model log_total_profit = log_taxes country foreign_capital/ solution covb;
	lsmeans foreign_capital / diff=all adjust=tukey;
	by _imputation_;
	ods output  SOLUTIONF=parms01 CovB=mixovb LSMEANS=lsm01 DIFFS=lsmdiffs01;
run;

/*Summary step*/
/*Summarizing model estimates*/
proc mianalyze parms=parms01 ;
   class country foreign_capital;
   modeleffects country foreign_capital;
run;

/*Summarizing Least Square Means*/
proc mianalyze parms=lsm01;
	class foreign_capital;
	modeleffects foreign_capital;
	ods output parameterestimates=lsm02;
run;

/*Summarizing Least Square Means Differences*/
proc mianalyze parms=lsmdiffs01;
	class foreign_capital;
	modeleffects foreign_capital;
	ods output parameterestimates=lsmdiffs02;
run;
ods rtf close;