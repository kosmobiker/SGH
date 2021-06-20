libname a "C:\Users\Vlad\Documents\SGH\data\data_lr";

DATA df; 
 set  a.gosp; 
RUN;

ods graphics on;
proc logistic data=df plots=roc;
    class forma(ref='osoba fizyczna')  sekcja_gosp(ref='USLUGI') typ(ref='MIKRO') 
							q_start aktywnosc y_start(ref='2006') / param = reference;
    model aktywnosc(event='zlikwidowane') = forma sekcja_gosp typ q_start y_start / rsquare aggregate scale=none;
run;
ods graphics off;
