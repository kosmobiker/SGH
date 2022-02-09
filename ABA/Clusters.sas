/*import*/
proc import datafile = '/home/u50020908/sasuser.v94/Data/Mall_Customers.csv'
	out = mallcust
	dbms = CSV
	replace;
run;

/*select data*/
proc sql;
	create table df as
	select 	case 
				when Genre = 'Male' then 0
				when Genre = 'Female' then 1
			end as genre,
			Age as age,
			'Annual Income (k$)'n as annual_income,
			'Spending Score (1-100)'n as spend_score					
	from mallcust
quit;


/* Perfoming Cluster Analysis */
ods graphics on / DISCRETEMAX=200;
proc cluster data = df method = centroid ccc print=20 outtree=out;
var age spend_score;
run;
ods graphics off;

proc tree noprint ncl=4 out=out1;
copy age spend_score;
run;

/* Scaterplot */
proc sgscatter  DATA=out1;
   PLOT spend_score * age
   / datalabel = CLUSTER group = CLUSTER;
run;