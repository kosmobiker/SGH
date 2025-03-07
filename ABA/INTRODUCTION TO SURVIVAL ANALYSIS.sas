/* INTRODUCTION TO SURVIVAL ANALYSIS */



/* Exploratory analysis */

title 'Bone Marrow Transplant Data';
proc contents data=sashelp.BMT varnum;
ods select position;
run;

title 'The First Ten Observations Out of 137';
proc print data=sashelp.BMT(obs=10);
run;

title 'The Risk Group and Status Variables';
proc freq data=sashelp.BMT;
tables group status;
run;



/* Nonparametric models */

/* The Life-Table method */

proc lifetest data=sashelp.bmt method=lt plots=(s,h,p);
time T*status(0);
run;


/* The Kaplan-Meier method */

proc lifetest data=sashelp.bmt plots=(s,h,p);
time T*status(0);
run;



/* Stratification */

proc lifetest data=sashelp.bmt;
time T*status(0);
strata group;
run;