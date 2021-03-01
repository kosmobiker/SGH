/*Zadanie 2*/
data LOGNOR1000;
	do i = 1 to 1000;
	log_val = rand('Lognormal', 0.5, 0.1);
	nor_val = exp(log_val);
	output;
	end;
run;
ods graphics on;
proc univariate data=LOGNOR1000 NORMAL;
var nor_val;
histogram nor_val / Normal;
qqplot nor_val / Normal;
run;
/*Hipoteza zerowa - nor_val ma rozkład normalny. 
Shapiro-Wilk Pr < W ==> Przyjmujemy hipotezę zerową*/

/*Zadanie 3*/
FILENAME REFFILE '/folders/myfolders/sasuser/Lab4/senate.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.SENATE;
	GETNAMES=YES;
RUN;

/*Zadanie 4*/
data SENATE_RESULTS;
	set work.senate;
	SURNAME = upcase(scan(candidate, 2));
	NAME = propcase(scan(candidate, 1));
	STATE_PARTY = lowcase(state||'_'||party);
	abb_COUNTY = tranwrd(county,"County","C");
run;

/*Zadanie 5*/
data SENATE_SORTED;
	set senate_results;
	keep SURNAME NAME STATE_PARTY abb_COUNTY TOTAL_VOTES;
proc sort data=SENATE_SORTED;
by SURNAME NAME;
run;
proc sort data=SENATE_SORTED;
by descending TOTAL_VOTES;
run;

/*Zadanie 7*/
data SENATE_LIST(keep=PARTY CANDIDATE);
	format PARTY CANDIDATE;
	set work.senate;
run;
proc sort data=SENATE_LIST out=SENATE_LIST nodupkey;
by PARTY CANDIDATE;
run;

/*Zadanie 9*/
data SALARY1;
length lname id sex $20. salary age 8.;
input lname $ id $ sex $ salary $ age;
cards;
Smith 1028 M . .
Williams 1337 F 3500 49
Brun 1829 . 14800 56
Agassi 1553 F 11800 65
Vernon 1626 M 129000 60
;
run;

/*Zadanie 10*/
data zbiór;
	do i = 1 to 100;
	char = put(i, z3.);
	date = put(i, ddmmyy10.);
	usd = put(i + rand("Integer",1000,9999), DOLLAR10.2);
	num_usd = input(usd, DOLLAR10.2);
	octal = put(i, OCTAL3.);
	output;
	end;
run;

/*Proszę o zrobienie zadań: 2, 3, 4, 7, 9, 10, 11, 12, 13, 14*/

/*Zadanie 11*/
data zb_1;
input x y$;
cards;
1.1 A
1.2 B
1.3 C
1.4 D
;
run;
data zb_2;
input x y$;
cards;
2.1 A
2.2 B
2.3 C
2.4 D
;
run;
data zb_3;
input t y$;
cards;
2.1 A
2.2 B
2.3 C
2.4 D
;
run;
data zb_1_2;
	set zb_1 zb_2;
run;

/*Zadanie 12*/
data zb_1_3;
	set zb_1 zb_3;
run;

/*Zadanie 13*/
libname sasall '/folders/myfolders/sashelp_all';
data PRZEGRYZKI PRZEGRYZKI0;
length kategoria $20.;
set sasall.SNACKS;
if index(Product,"chips") > 0 then do; kategoria = 'czipsy';
end;
else if index(Product,"sticks") > 0  then do; kategoria = 'patyczki';
end;
else if index(Product,"popcorn") > 0 then do; kategoria = 'popcorn';
end;
else do; kategoria = 'inne';
end;
usd = put(Price, DOLLAR10.2);
if Price < 2 AND kategoria = 'inne' then spec_gr = "Y";
if QtySold > 0 then output PRZEGRYZKI;
if QtySold <= 0 then output PRZEGRYZKI0;
run;
/*Zadanie 14*/

data URO10(keep= birthday10 x);
birthday = '28JAN1991'd;
birthday10 = '28JAN2001'd;
x = 2;
procent = 0.0009;
n = 0;
do while (n <= (birthday10 - birthday));
n = n + 1;
x = x *(1 + procent);
end;
format birthday10 ddmmyy10.;
output;
run;
data URO20(keep= birthday20 x);
birthday = '28JAN1991'd;
birthday20 = '28JAN2011'd;
x = 2;
procent = 0.0009;
n = 0;
do while (n <= (birthday20 - birthday));
n = n + 1;
x = x *(1 + procent);
end;
format birthday20 ddmmyy10.;
output;
run;
data DZIS(keep= today x);
birthday = '28JAN1991'd;
today = today();
x = 2;
procent = 0.0009;
n = 0;
do until (n = (today - birthday) + 1);
n = n + 1;
x = x *(1 + procent);
end;
output;
format today ddmmyy10.;
run;