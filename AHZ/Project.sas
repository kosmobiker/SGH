/*import danych*/
proc import out = imported datafile= "C:\Users\Vlad\Documents\SGH\data\data_ahz\whas500.xls" 
            dbms=xls replace;
     		sheet="WHAS500"; 
     		getnames=yes;
run;

/*usuniecie niepotrzebnych kolumn*/
data df;
	set imported(drop=admitdate disdate fdate los dstat);
run;


%let my_nom_var=gender cvd afb	sho chf av3 miord mitype year;
%let my_quant_var=age hr sysbp diasbp bmi;

/*Zakladamy, ze:
zmienna lenfol - czas przezycia
zmienna fstat - zmienna cenzurujaca
*/


/*Podstawowe statystyki niektorych zmiennych*/
ods graphics on;
title "Statystyki zmennej lenfol";
proc means data = df mean std min max q1 median q3 kurtosis maxdec = 1 ;
	var lenfol; 
run ;
proc univariate data = df;
	var lenfol; 
	histogram; 
run ;
title "Statystyki zmennej fstat";
proc means data = df mean std min max missing kurtosis maxdec = 1;
	var fstat; 
run ;
proc sgplot data=df;
	vbar fstat;
run;
title "Statystyki zmennej age";
proc means data = df mean std min max q1 median q3 kurtosis maxdec = 1 ;
	var age; 
run ;
proc univariate data = df;
	var age; 
	histogram; 
run ;
title "Statystyki niektorych innych zmiennych";
proc means data = df mean std min max missing kurtosis maxdec = 1;
	var &my_nom_var; 
run ;
ods graphics off;


/*Modele nieparametryczne*/

/*METODA TRADYCYJNA*/
ods graphics on;
title1 "Modele nieparametryczne";
title2 "Metoda tradycyjna";
title3 "Bez podzialu";
proc lifetest data=df method=life alpha=0.05 plots=(survival hazard ls lls p density); 
	time lenfol * fstat(0);
	id id;
run;
title3 "Podzial ze wzgledu na plec";
proc lifetest data=df method=life alpha=0.05 plots=(survival hazard ls lls p density); 
	time lenfol * fstat(0);
	id id;
	strata gender/ test=(logrank wilcoxon peto);
run;
ods graphics off;


/*METODA KAPLANA-MEIERA*/
ods graphics on;
title1 "Modele nieparametryczne";
title2 "Metoda Kaplana-Meiera";
title3 "Bez podzialu";
proc lifetest data=df method=km alpha=0.05 plots=(survival hazard ls lls p density); 
	time lenfol * fstat(0);
	id id;
run;
title3 "Podzial ze wzgledu na plec";
proc lifetest data=df method=km alpha=0.05 plots=(survival hazard ls lls p density); 
	time lenfol * fstat(0);
	id id;
	strata gender/ test=(logrank wilcoxon peto);
run;
ods graphics off;


/*Modele parametryczne*/
ods graphics on;
title1 "Modele parametryczne";
title2 "Rozklad wykladniczy";
proc lifereg data=df plots=probplot;
	model lenfol * fstat(0) = / dist=exponential;
	probplot; 
	inset dist confidence scale shape nobs; 
run;
title2 "Rozklad  Weibulla";
proc lifereg data=df plots=probplot;
	model lenfol * fstat(0) = / dist=weibull;
	probplot; 
	inset dist confidence scale shape nobs; 
run;
title2 "Rozklad Lognormalny";
proc lifereg data=df plots=probplot;
	model lenfol * fstat(0) = / dist=lognormal;
	probplot; 
	inset dist confidence scale shape nobs; 
run;
title2 "Rozklad Gamma";
proc lifereg data=df plots=probplot;
	model lenfol * fstat(0) = / dist=gamma maxiter=10000;
	probplot; 
	inset dist confidence scale shape nobs; 
run;
title;
ods graphics off;

/*model z rozkladem Lognormalny jest znacznie lepiej dopasowany 
i bardziej precyzyjnie odzwierciedla dane niz pozosale*/

ods graphics on;
title1 "Rozklad Lognormalny ze zmiennymi";
proc lifereg data=df plots=probplot;
	class &my_nom_var;
	model lenfol * fstat(0) = &my_quant_var	&my_nom_var/ dist=lognormal;
	probplot; 
	inset dist confidence scale shape nobs; 
run;
title "Rozklad Lognormalny bez zmiennych";
proc lifereg data=df plots=probplot;	
	model lenfol * fstat(0)=/ dist=lognormal;
	probplot; 
	inset dist confidence scale shape nobs; 
run;
ods graphics off;

ods graphics on;
proc logistic data=df plots=roc;
class gender(ref="0") cvd(ref="0") / param = reference;
model fstat= &my_nom_var &my_quant_var / selection = stepwise rsquare aggregate scale=none;;
run;
ods graphics off;