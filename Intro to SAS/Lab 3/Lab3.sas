/*Zadanie 1*/
data autos;
	set sashelp.cars;
	where origin='Europe';
run;
proc sort;
by descending MSRP make model;
run;
proc print data=autos;
title 'Europejskie Modele Samochodów';
footnote 'Ceny podane w dolarach amerykańskich';

run;
/*Zadanie 2
'id DriveTrain' dodaje "DriveTrain" jako pierwszą kolumnę zamiast "Obs"*/

/*Zadanie 4*/
data raport;
	set SASHELP.BASEBALL;
	where league = 'National' and (name like "____,%" or name like "%, ___")
							and YrMajor >= 4;
proc sort;
by descending Salary;
run;
proc print data=raport;
title "Chosen players of National League";
footnote '1987 Salary in $ Thousands';
run;
title;
footnote;

/*Zadanie 5*/
data birthday;
birthday = '28JAN1991'd;
today = today();
years = intck('year', birthday, today);
months = intck('month', birthday, today);
days = intck('days', birthday, today);
run;
proc print data=birthday;
	var years months days;
run;

/*Zadanie 6*/

libname sasall '/folders/myfolders/sashelp_all';
data gulf;
set sasall.gulfoil;
where regionname = 'Central' and date between '01Jan2000'd and '31dec2005'd;
month = month(date);
dayofweek = weekday(date);
run;

/*Zadanie 7*/

data leapyear;
format nextday2000 nextday2100 date9.;
nextday2000 = intnx('day', '28FEB2000'd, 1);/*Rok przestępny */
nextday2100 = intnx('day', '28FEB2100'd, 1);/*Rok nie przestępny */
run;