/*import danych*/
/*proc import out = imported datafile= "/shared/home/ud108519@student.sgh.waw.pl/SGH Projekt/life_expectancy.csv" */
proc import out = imported datafile= "C:\Users\Vlad\Documents\SGH\data\data_lr\life_expectancy.csv"
            dbms=csv replace;
     getnames=yes;

/*statystyki zmiennej life_expectancy/ adult_mortality*/
proc means data = imported mean std min max q1 median q3 kurtosis maxdec = 1;
	var life_expectancy adult_mortality;
run;

/*przetworzenie danych*/
data d;
	set imported;
	if status = 'Developing' then status_bin = 0;
	else status_bin = 1;
	if life_expectancy < 65.7 then life_expectancy_cat = 0;
	if life_expectancy >= 65.7 and life_expectancy <= 77.0 then life_expectancy_cat = 1;
	if life_expectancy > 77.0 then life_expectancy_cat = 2;
	if adult_mortality < 138.0 then adult_mortality_bin = 0;
	else adult_mortality_bin = 1;
	drop year status life_expectancy adult_mortality;
run;

/*Tabela kontyngencji dla kazdej kategorii z osobna:*/
proc freq data=d;
	table life_expectancy_cat*status_bin / nocum nocol norow nopercent;
run;


/*proc format;
    value life_expectancy_cat
    0 = "low"
    1 = "medium"
    2 = "high"
    3 = "medium / high"
    4 = "low / medium";
run;*/

* Y <= 1 vs Y > 1;

data d2;
    set d;
    if life_expectancy_cat in (1 2) then life_expectancy_cat = 3;
run;

title 'Tabela Y <= 1 vs Y > 1'; 
proc freq data=d2;
    table life_expectancy_cat*status_bin/ nocum norow nopercent oddsratio ;
run;
title;

* Y <= 2 vs Y > 2;

data d3;
    set d;
    if life_expectancy_cat in (0 1) then life_expectancy_cat = 4;
run;

title 'Table Y <= 2 vs Y > 2';
proc freq data=d3 order=data;
    table life_expectancy_cat*status_bin/ nocum norow nopercent oddsratio ;
run;
title;

ods graphics on;
proc logistic data=d plots(only) = (effect(clbar) oddsratio);
	class status_bin(param=ref ref='1');
	model life_expectancy_cat = status_bin / expb;
	output out=out p=p;
run;
ods graphics off;

proc sql noprint;
	create table dis_p as
	select distinct status_bin, _level_, p
	from out;
quit;

/*model regresji logistycznej o postaci wielomianu*/
title 'Tabela kontyngencji wszystkie poziomy life_expectancy_cat';
proc freq data=d;
	tables life_expectancy_cat*adult_mortality_bin / relrisk nopercent norow nocol;
run;
title;

title 'medium vs low';
proc freq data=d;
	tables life_expectancy_cat*adult_mortality_bin / relrisk nopercent norow nocol;
	where life_expectancy_cat ne 2;
run;
title;

title 'high vs low';
proc freq data=d;
	tables life_expectancy_cat*adult_mortality_bin / relrisk nopercent norow nocol;
	where life_expectancy_cat ne 1;
run;
title;


title "Multinomial model - logistic model";
proc logistic data=d covout outest=cov;
	class adult_mortality_bin (param=ref ref='1');
	model life_expectancy_cat = adult_mortality_bin/ link=glogit expb waldcl;
run;

proc logistic data=d;
	model life_expectancy_cat  = hepatitis_b / link=glogit;
	output out=out1 predicted=p;
run;

proc sgplot data=out1;
	scatter x=hepatitis_b y=p / group=_LEVEL_;
run;
title;