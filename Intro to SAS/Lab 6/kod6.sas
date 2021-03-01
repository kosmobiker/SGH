libname music 'C:\Users\mwojte\Desktop\sas_db';

data w;
	set music.album;
	artistid = .;
run;

proc sql noprint;
	create table album_artist as
	select a.*, b.name as artist_name
	from w as a left join music.artist as b
	on a.artistid = b.artistid;
quit;

proc sort data=music.album out=albums;
by artistID;
proc sort data=music.artist out=artists;
by artistID;

data left inner right no_key;
	merge albums(in=al) artists(in=art);
	by artistid;
	if al then output left;
	if art then output right;
	if al and art then output inner;
	if al and not art then output no_key;
run;

/*Merge nie obs³uguje ³¹czenia typu wiele do wielu*/

title "Statystki opisowe wed³ug p³ci";
footnote "Zbiór sashelp.class";
proc means data=sashelp.class;
	var age;
	class sex;
run;
title;
footnote;

data klasa_wg;
	set sashelp.class;
	if weight > 90 then waga_class = 2;
	else waga_class = 1;
	if height > 60 then h_class = 2;
	else h_class = 1;
	proc sort;
		by waga_class;
run;
title "Statystki opisowe wed³ug p³ci w grupach wagowych";
footnote "Zbiór sashelp.class";
proc means data=klasa_wg;
	var age;
/*	class sex waga_class;*/
	by waga_class;
run;
title;
footnote;

title "Statystki opisowe wed³ug p³ci";
footnote "Zbiór sashelp.class";
proc means data=sashelp.class n min max mean p25 median p75 skew
lclm uclm cv;
var age;
class sex;
run;
title;
footnote;

proc means noprint data=sashelp.class n min max mean p25 median p75
skew lclm uclm cv;
	var age;
	class sex;
	output out = stats;
run;

proc means noprint data=sashelp.class n min max mean p25 median p75
skew lclm uclm cv;
var age;
class sex;
	output out = stats n=n mean=srednia min=min max=max p25=perc25
	median=med p75=perc75 skew=skos lclm=dol_uf uclm=gora_uf cv=zmien;
run;

proc means noprint data=sashelp.class n min max mean p25 median p75
skew lclm uclm cv;
var age;
class sex;
	output out = stats n= mean= min= max= p25= median= p75= skew=
lclm= uclm= cv= / autoname;
run;

proc means data=klasa_wg;
	var age height;
	class sex;
	by waga_class;
	output out = stats n= mean= median= / autoname;
run;

proc means data=klasa_wg;
	var age height;
	class sex;
	by waga_class;
	output out = stats n(age)= mean(age)= mean(height)=wzrost_srednia
median= / autoname;
run;

proc means noprint nway data=klasa_wg;
var age height;
class sex waga_class;
output out = stats n= mean= median= / autoname;
run;

proc means noprint data=klasa_wg;
	var age height;
	class sex waga_class h_class;
	types()
	sex*waga_class
	waga_class*h_class;
	output out = stats n= mean= median= / autoname;
run;

/*PROC FREQ*/
data example1;
input x y $ z;
cards;
6 A 60
6 A 70
2 A 100
2 B 10
3 B 67
2 C 81
3 C 63
5 C 55
;
run;

proc freq data = example1;
	tables y ;
run;

proc freq data = example1;
	tables y / nocum nopercent;
run;

proc freq data = example1;
	tables y*x / out=zlicz;
run;

proc freq data = example1;
	/*tables y*(x z);*/ tables y*x*z;
run;

proc freq data = example1; table y*x / out=count; run;

proc freq data=zlicz;
	table y*x;
	weight count;
run;

proc freq data = sashelp.heart order=FREQ; table deathcause / 
out=counts; run;

proc freq data = klasa_wg;
	table sex / chisq testp=(45 55);
run;

proc freq data = klasa_wg;
	table sex*h_class / chisq;
run;

ods graphics on;
Proc freq data=example1 order=freq;
	Tables y/ plots=freqplot (type=dot scale=percent);
run;

/*PROC UNIVARIATE*/
proc univariate data=sashelp.shoes;
	var sales;
	class region;
run;

ods select Quantiles;
proc univariate data=sashelp.shoes plot;
var sales;
run;

/*_character_*/
/*_numeric_*/
/*_all_*/

ods output Quantiles = temp;
proc univariate data=sashelp.shoes;
var _numeric_;
/*class region;*/
run;
ods output close;

proc univariate data=sashelp.shoes plot;
	var sales;
/*	histogram / normal;*/
/*	inset mean std / format=6.4;*/
run;

proc univariate data=sashelp.shoes normaltest;
var sales;
qqplot sales / normal(mu=est sigma=est) square;
label sales = "Sprzeda¿";
inset mean std / format=6.4;
run;

%let cond = where age > 15;
%put &cond.;
%put %eval(&ratio. + 5);

%let ratio2 = 5;
%put %eval(&ratio. + &ratio2.);

%put Ratio is &ratio.;

data w;
	set sashelp.class;
	&cond.;
run;

proc means data=sashelp.class nway noprint;
	var age;
	output out=zbior(drop=_:) mean= / autoname;
run;


	proc contents data=sashelp.class noprint out=klasa(keep=name type where=(type=1));
	
	proc sql noprint;
		select name into :vars separated by ','
		from klasa;
	quit;
%put &vars.;
%put &sqlobs.;

options mprint;
%macro licz_srednia(dt=,v=,ot=);

	proc contents data=&dt. noprint out=klasa(keep=name type where=(type=1));
	proc sql noprint;
		select name into :vars separated by ' '
		from klasa;
	quit;

	%do i = 1 %to &sqlobs.;	
		%let x = %scan(&vars.,&i.);
		proc means data=&dt. nway noprint;
			var &x.;
		output out=&ot._&x.(drop=_:) mean= / autoname;
	%end;
%mend;

%licz_srednia(dt=sashelp.class,v=age,ot=sr);
/*%licz_srednia(dt=sashelp.class,v=height,ot=sr_height);*/
/*%licz_srednia(dt=sashelp.class,v=weight,ot=sr_weight);*/
/*%licz_srednia(dt=sashelp.class,v=age,ot=sr_age);*/