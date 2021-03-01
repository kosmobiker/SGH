libname data '/folders/myfolders/sasuser/Projekt';

data data.test_train;
	set data.abt_sam_beh_train(keep=period act_state_6: app_: act_cus:);
	year = substr(period, 1, 4);
run;

data data.test_valid;
	set data.abt_sam_beh_valid(keep=period act_state_6: app_: act_cus:);
	year = substr(period, 1, 4);
run;

%macro miss_report(din, fout);
proc format;
value nm   .  = '0' other = '1';
value $ch ' ' = '0' other = '1';
run;

ods listing close;
ods output onewayfreqs=tables;
proc freq data=&din;
tables _all_ / missing;
format _numeric_ nm. _character_ $ch.;
run;
ods output close;
ods listing;

data report;
length var $32;
do until (last.table);   
	set tables;   
	by table notsorted;   
	array names(*) f_: ;   
	select (names(_n_));     
		when ('0') do; 
			miss = frequency; 
			p_miss = percent; 
		end;     
		when ('1') do; 
			ok   = frequency; 
			p_ok   = percent; 
		end;   
	end;
end;
miss   = coalesce(miss,0);
ok     = coalesce(ok,0);
p_miss = coalesce(p_miss,0);
p_ok   = coalesce(p_ok,0);
var    = scan(table,-1);

keep var miss ok p_:;
format miss ok comma7. p_: 5.1;
label
miss   = 'N_MISSING'
ok     = 'N_OK'
p_miss = '%_MISSING'
p_ok   = '%_OK'
var    = 'VARIABLE';
run;

ods listing close;
ods html file="&fout" style=barrettsblue;
proc print data=report label noobs;
   	id var;     
	var miss p_miss ok p_ok;
run;
ods html close;
ods listing;
%mend;

%miss_report(data.test_train, /folders/myfolders/sasuser/missing_values_report_train.html);
%miss_report(data.test_valid, /folders/myfolders/sasuser/missing_values_report_valid.html);

ODS HTML body="/folders/myfolders/sasuser/Deleted_Variables.HTML" style=barrettsblue; 
run;
title1 'Deleted variables';
title2 'Next variables will be deleted bacause the % of missing values >= 50';
proc sql;
select var into :droplist separated by ' '
from report where p_miss ge 50;
quit;
run; 
ods html close;

data cleaned;
set data.test_valid(drop=&droplist);
if cmiss(of _all_) ge 10 then delete;
if missing(cats(of _all_))then delete;
run;

proc mi data=cleaned ROUND=1 NIMPUTE=1 out=ready;
ods select misspattern;
run;

%macro time_stab(din, fout);
proc means data=&din noprint;
by year;
output out=output_means(drop=_type_ _freq_) nmiss=/autoname;
run;

data time_report;
	set output_means;
	total_number = sum(of _numeric_);
run;

proc transpose data=time_report name=varName out=out_report;
id year;
run;

ods listing close;
ods html file="&fout" style=barrettsblue;
proc print data=out_report label noobs;
var _all_;
run;
ods html close;
ods listing;
%mend;

%time_stab(data.test_train, /folders/myfolders/sasuser/time_train.html);
%time_stab(data.test_valid, /folders/myfolders/sasuser/time_valid.html);



