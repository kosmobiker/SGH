/*Zadanie 1*/

LIBNAME Lab2 '/folders/myfolders/sasuser/lab2';
LIBNAME Lab2 list;
/*Ile jest plików w wypakowanym folderze? 3
Ile zbiorów danych widocznych jest w bibliotece SAS? 2(BSBALL i KLASA)*/

/*Zadanie 2*/

PROC IMPORT datafile='/folders/myfolders/sasuser/lab2/gas.xls'
out=lab2.gas
dbms=xls
replace;
getnames=yes;
run;

/*Zadanie 3-4*/
LIBNAME covid '/folders/myfolders/sasuser/lab2/covid';
LIBNAME covid list;
PROC IMPORT datafile='/folders/myfolders/sasuser/lab2/covid/worldometer_data.csv'
out=covid.worldometer
dbms=csv
replace;
getnames=yes;
run;

/*Zadanie 5*/
PROC EXPORT data=sashelp.air
dbms=xls
outfile='/folders/myfolders/sasuser/air.xls';

/*Zadanie 6-7*/
PROC EXPORT data=covid.CNT_WISE
dbms=csv
outfile='/folders/myfolders/sasuser/lab2/cnt.csv';
LIBNAME SASHELP list;
LIBNAME Lab2 list;
LIBNAME covid list;

/*Zadanie 10*/
data RATIO;
	set covid.cnt_wise;
	NEW_REC_DT = NEW_RECOVER/NEW_DEATH;
	chk = _ERROR_;
run;

/*Zadanie 11*/
data all;
	set covid.worldometer;
	CONTINENT = 'World';
	output;
	
proc means data=all sum;
class continent;
var totcase;
run;
/*Co przedstawia tabela wygenerowana przez procedurę means? - Tabela zawiera dane o 
liczbie zachorowań (TOTALCASE) i liczbie obserwacyj (N Obs) na każdym kontynencie
 (CONTINENT) */

/*Zadanie 12*/

data petla4;
	do i = 1 to 100;
		X = ranuni(1);
		Y = abs(X)*100 - rand('integer', 0, 100);
		output;
	end;
run;

/*Zadanie 13*/

data family;
	length imie pokr $12.;
	length rok_ur 3.;
		imie = 'Piotr';
		rok_ur = '1980';
		pokr = 'ojciec';
	output;
		imie = 'Anna';
		rok_ur = '1980';
		pokr = 'matka';
	output;
		imie = 'Paweł';
		rok_ur = '2010';
		pokr = 'dziecko';
	output;
run;

/*Zadanie 14*/

data air;
	set sashelp.air;
	retain sum_air 0;
	sum_air = sum_air + air;
run;

/*Zadanie 15*/

data MACRS15;
	set sashelp.MACRS15;
	retain cum_rate 0;
	cum_rate = cum_rate + rate;
run;

/*Zadanie 16*/
/* SAS Studio nie zawiera zbior AIRLINE
data NEW_AIRLINE;
	set SASHELP.AIRLINE;
	keep date;
	where AIR >= 150
run;
*/

/*Zadanie 17*/

data NEW_BMIMEN;
	set sashelp.bmimen;
	keep AGE;
	where AGE >= 25 AND BMI < 17;
run;

/*Zadanie 18*/

data NEW_CARS(keep=Make Model Type);
	set SASHELP.CARS(keep=Make Model Type Cylinders Horsepower 
					WHERE=(Type='Sedan' AND Cylinders = 6 AND Horsepower >= 220));
run;

/*Zadanie 19*/
/*
data NEW_AIRLINE;
	set SASHELP.AIRLINE;
PROC SQL;	
	select date;
	where AIR >= 150;
quit;
run;*/

data NEW_BMIMEN;
	set sashelp.bmimen;
PROC SQL;
	select *
	from sashelp.bmimen
	where Age >= 25 AND BMI < 17;
quit;
run;

data NEW_CARS;
	set SASHELP.CARS;
PROC SQL;
	select Make, Model, Type
	from SASHELP.CARS
	where Type='Sedan' and Cylinders = 6 AND Horsepower >= 220;
quit;
run;


