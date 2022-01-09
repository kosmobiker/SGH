/*Advanced Business Analytics - Power od Predictive Modeling 226161-0131*/

/*DATA-MINING APPROACH*/

/*EXAMPLE 1*/
/*Defining SAS data library*/
libname dtmn 'C:/ABA';


/*Computing RMF*/
data rollup;
set dtmn.trans;
by id;
length ltr r4 f4 m4 r6 f6 m6 4;
retain ltr r4 f4 m4 r6 f6 m6;
array x{*} ltr f4 m4 f6 m6;
if first.id then do;
do i=1 to DIM(x);
x{i}=0;
end;
r4=9999;
r6=9999;
end;
/*Computing RMF for 2004*/
diff=("31AUG2004"d-giftdate)/365.25;
if diff < 0 then ltr=sum(amt, ltr);
else do;
if diff<r4 then r6=diff;
f4=f4+1;
m4=sum(amt,m4);
end;
/*Computing RFM for 2006*/
diff=("31AUG2006"d-giftdate)/365.25;
if diff < 0 then ltr=sum(amt, ltr);
else do;
if diff<r6 then r6=diff;
f6=f6+1;
m6=sum(amt,m6);
end;
if last.id then output;
keep id r4 f4 m4 r6 f6 m6 ltr;
run;


/*Data for histogram of log(ltr+1)*/
data hist;
set rollup;
logltr=log(ltr+1);
label logltr="log(ltr+1)";
run;


/*Histogram of log(ltr+1)*/
proc sgplot data=hist noautolegend;
histogram logltr;
run;


/*Histogram for ltr>0*/
proc sgplot data=hist noautolegend;
where ltr>0;
histogram logltr;
xaxis label="log(ltr+1), where ltr>0";
run;



/*EXAMPLE 2*/
/*Creating variables for the two-step model*/
data rollup2;
set rollup;
/*Creating variables for 2004*/
yr=2004;
r=r4;
logf=log(f4+1);
logm=log(m4+1);
logtarg=log(ltr+1);
targbuy=(ltr>0);
output;
/*Creating variables for 2006*/
yr=2006;
r=r6;
logf=log(f6+1);
logm=log(m6+1);
logtarg= .;
targbuy= .;
output;
drop r4 f4 m4 r6 f6 m6;
run;


/*Logistic model*/
proc logistic data=rollup2 descending;
model targbuy=r logf logm;
output out=logitout predicted=phat;
run;


/*Regression model*/
proc reg data=logitout corr;
model logtarg=r logf logm;
output out=regout predicted=yhat;
weight targbuy;
run;


/*Predictions*/
data answer;
set regout;
answer=phat*(exp(yhat+0.47246/2)-1);
run;


/*Calculating summed CLV*/
proc means data=answer n sum;
where yr=2006;
var answer;
run;



/*EXAMPLE 3*/
/*Format for records whether they are from train or test sample*/
proc format;
value train
0 = "test"
1 = "train";
run;


/*Creating two subsets - train and test sample*/
data all_sse;
set rollup2;
if targbuy=1;
train=(ranuni(12345)<0.5);
format train train.;
run;


/*Creating linear model to calculate SSE on train and test sample*/
proc glmselect data=all_sse;
model logtarg = r logf logm / selection=none;
partition rolevar=train(TEST="test");
run;


/*EXAMPLE 4*/
/*Macro programm for creating gains table*/
%macro gains(y, score,data);
proc rank data=&data. out=&data. groups=10 descending;
var &score.;
ranks decile;
run;

proc summary data=&data nway;
class decile;
var &y;
output out=gainout(drop=_type_ _freq_) n=n mean=mean sum=total;
run;

data gainout;
set gainout;
retain cumn cumsum 0;
decile=decile+1;
cumsum=cumsum+total;
cumn=cumn+n;
cummean=cumsum/cumn;
output;
run;

proc print data=gainout noobs;
var decile n total mean cumn cumsum cummean;
sum n total;
format n cumn total cumsum comma8. mean cummean 7.3;
run;
%mend;

/*Creating gains table*/
%gains(ltr, answer, answer);
