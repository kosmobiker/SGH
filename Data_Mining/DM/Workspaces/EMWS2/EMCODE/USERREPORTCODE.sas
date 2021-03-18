proc corr data=&EM_IMPORT_DATA;
/*Var ;*/
run;

proc freq data=&EM_IMPORT_DATA;
table CHURN*L_ROZBOK/chisq;
run;
