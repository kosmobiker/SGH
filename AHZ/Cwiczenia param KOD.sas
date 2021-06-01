libname b 'C:\Users\Vlad\Documents\SGH\data\data_ahz';
option compress=binary;

*pdst;
ods graphics on;
proc lifereg data=b.dane namelen=32 plots=probplot outest=_est;
model ttd * rc(0,1) = / dist=exponential maxiter=200;
probplot;
inset dist confidence scale shape nobs ;
quit;
ods graphics off;

ods graphics on;
ods output ParameterEstimates=ParameterEstimates Type3Analysis=Type3Analysis;
proc lifereg data=b.dane namelen=32 plots=probplot outest=_est;
model ttd * rc(0,1) = app_number_of_children / dist=exponential maxiter=200;
quit;
ods output close;
ods graphics off;

ods graphics on;
ods output ParameterEstimates=ParameterEstimates Type3Analysis=Type3Analysis;
proc lifereg data=b.dane namelen=32 plots=probplot outest=_est;
class app_number_of_children;
model ttd * rc(0,1) = app_number_of_children / dist=exponential maxiter=200;
output out=_out p=p std=s xbeta=lp;
probplot;
inset dist confidence scale shape nobs ;
quit;
ods output close;
ods graphics off;
proc freq data = b.dane; tables app_number_of_children / missing; run;
proc format;
value nkids 
	0='ref_0'
	1='1'
	2='2'
	3='3'
	other = 'inne';
run;

data w;
set b.dane(keep=ttd rc app_number_of_children);
app_number_of_children_f=put(app_number_of_children,nkids.);
run;

ods graphics on;
ods output ParameterEstimates=ParameterEstimates Type3Analysis=Type3Analysis;
proc lifereg data=w namelen=32 plots=probplot outest=_est order=formatted;
class app_number_of_children_f;
model ttd * rc(0,1) = app_number_of_children_f / dist=exponential maxiter=200;
output out=_out p=p std=s xbeta=lp;
probplot;
inset dist confidence scale shape nobs ;
quit;
ods output close;
ods graphics off;

ods listing close;
ods graphics on;
ods output ParameterEstimates=ParameterEstimates Type3Analysis=Type3Analysis;
proc lifereg data=b.dane order=formatted namelen=32 plots=probplot outest=_est;
class 	app_number_of_children 
		app_char_marital_status ;
model ttd * rc(0,1) = 	app_income
						app_installment
						app_loan_amount
						app_n_installments
						app_spendings 
					    app_number_of_children
						app_char_marital_status 	/ dist=exponential maxiter=200;
output out=_out p=p std=s xbeta=lp;
probplot;
inset dist confidence scale shape nobs ;
effectplot contour (x=app_income y=app_spendings);
effectplot fit (x=app_income);
effectplot slicefit (sliceby=app_number_of_children);
effectplot box (x=app_number_of_children plotby=app_char_marital_status) ;
quit;
ods graphics off;
ods listing;
%lifehaz(outest=_est, out=_out, xbeta=lp);

data w;
set _out(obs=10 keep=cid aid ttd _prob_ p lp s rc app_income app_installment app_loan_amount app_n_installments app_spendings app_number_of_children app_char_marital_status);
run;
%predict(outest=_est, out=w, xbeta=lp, time=20);

ods graphics on;
proc lifereg data=b.dane outest=_est;
model ttd * rc(0,1) = / dist=exponential maxiter=200;
output out=_out p=p std=s xbeta=lp;
quit;
ods graphics off;
%lifehaz(outest=_est, out=_out, xbeta=lp);

ods graphics on;
proc lifereg data=b.dane outest=_est;
model ttd * rc(0,1) = / dist=weibull maxiter=200;
output out=_out p=p std=s xbeta=lp;
quit;
ods graphics off;
%lifehaz(outest=_est, out=_out, xbeta=lp);

data _null_;
diff=2*(-46902.70234+47407.69189);
x=1-probchi(diff,1);
put diff;
put x;
run;

ods listing close;
ods graphics on;
ods output ParameterEstimates=ParameterEstimates Type3Analysis=Type3Analysis;
proc lifereg data=b.dane order=formatted namelen=32 plots=probplot outest=_est;
class 	app_number_of_children 
		app_char_marital_status ;
model ttd * rc(0,1) = 	app_income
						app_installment
						app_loan_amount
						app_n_installments
						app_spendings 
					    app_number_of_children
						app_char_marital_status 	/ dist=exponential maxiter=200;
output out=_out p=p std=s xbeta=lp;
quit;
ods graphics off;
ods listing;

ods listing close;
ods graphics on;
ods output ParameterEstimates=ParameterEstimates Type3Analysis=Type3Analysis;
proc lifereg data=b.dane order=formatted namelen=32 plots=probplot outest=_est;
class 	app_number_of_children 
		app_char_marital_status ;
model ttd * rc(0,1) = 	app_income
						app_installment
						app_loan_amount
						app_n_installments
						app_spendings 
					    app_number_of_children
						app_char_marital_status 	/ dist=weibull maxiter=200;
output out=_out p=p std=s xbeta=lp;
quit;
ods graphics off;
ods listing;
%lifehaz(outest=_est, out=_out, xbeta=lp);







*lognormal;
ods listing close;
ods graphics on;
proc lifereg data=b.dane namelen=32 outest=_est;
class 	app_number_of_children 
		app_char_marital_status ;
model ttd * rc(0,1) = 	app_income
						app_installment
						app_loan_amount
						app_n_installments
						app_spendings 
					    app_number_of_children
						app_char_marital_status 	/ dist=lognormal maxiter=200;
output out=_out p=p std=s xbeta=lp;
quit;
ods graphics off;
ods listing;
