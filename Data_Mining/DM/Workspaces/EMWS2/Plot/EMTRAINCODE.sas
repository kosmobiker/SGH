*------------------------------------------------------------* ;
* Plot: DMDBClass Macro ;
*------------------------------------------------------------* ;
%macro DMDBClass;
    CHURN(DESC) CZAS_W(ASC) DZIENMIN(ASC) DZIENOPL(ASC) DZIENROZ(ASC)
   L_ROZBOK(ASC) L_WIAD(ASC) M_MIN(ASC) M_OPL(ASC) M_ROZM(ASC) NOCMIN(ASC)
   NOCOPL(ASC) NOCROZ(ASC) PLAN_M(ASC) POCZTA_G(ASC) WIECZMIN(ASC) WIECZOPL(ASC)
   WIECZROZ(ASC)
%mend DMDBClass;
*------------------------------------------------------------*;
* Plot: Create DMDB;
*------------------------------------------------------------*;
proc dmdb batch data=EMWS2.Ids_DATA
dmdbcat=WORK.Plot_DMDB
maxlevel = 23
nonorm
;
class %DMDBClass;
target
CHURN
;
run;
quit;
*------------------------------------------------------------*;
* Plot: Creating variable by class target charts;
*------------------------------------------------------------*;
goptions ftext="SWISS";
goptions nodisplay device=PNG;
axis1 width=2 offset=(1,1) label=(rotate=90 angle=270) minor=none;
axis2 width=2 minor=none;
pattern1 value=solid;
proc gchart
data=EMWS2.Ids_DATA gout=WORK.PlotGRAPH;
*;
title "CZAS_W by CHURN";
vbar CZAS_W /
name = "CZAS_W         x CHURN          " description = "CZAS_W by CHURN"
FREQ
type=FREQ
subgroup=CHURN
noframe
missing
raxis=axis1 maxis=axis2;
run;
title "DZIENMIN by CHURN";
vbar DZIENMIN /
name = "DZIENMIN       x CHURN          " description = "DZIENMIN by CHURN"
FREQ
type=FREQ
subgroup=CHURN
noframe
missing
raxis=axis1 maxis=axis2;
run;
title "DZIENOPL by CHURN";
vbar DZIENOPL /
name = "DZIENOPL       x CHURN          " description = "DZIENOPL by CHURN"
FREQ
type=FREQ
subgroup=CHURN
noframe
missing
raxis=axis1 maxis=axis2;
run;
title "DZIENROZ by CHURN";
vbar DZIENROZ /
name = "DZIENROZ       x CHURN          " description = "DZIENROZ by CHURN"
FREQ
type=FREQ
subgroup=CHURN
noframe
missing
raxis=axis1 maxis=axis2;
run;
title "L_ROZBOK by CHURN";
vbar L_ROZBOK /
name = "L_ROZBOK       x CHURN          " description = "L_ROZBOK by CHURN"
FREQ
type=FREQ
subgroup=CHURN
noframe
missing
discrete
raxis=axis1 maxis=axis2;
run;
title "L_WIAD by CHURN";
vbar L_WIAD /
name = "L_WIAD         x CHURN          " description = "L_WIAD by CHURN"
FREQ
type=FREQ
subgroup=CHURN
noframe
missing
raxis=axis1 maxis=axis2;
run;
title "M_MIN by CHURN";
vbar M_MIN /
name = "M_MIN          x CHURN          " description = "M_MIN by CHURN"
FREQ
type=FREQ
subgroup=CHURN
noframe
missing
raxis=axis1 maxis=axis2;
run;
title "M_OPL by CHURN";
vbar M_OPL /
name = "M_OPL          x CHURN          " description = "M_OPL by CHURN"
FREQ
type=FREQ
subgroup=CHURN
noframe
missing
raxis=axis1 maxis=axis2;
run;
title "M_ROZM by CHURN";
vbar M_ROZM /
name = "M_ROZM         x CHURN          " description = "M_ROZM by CHURN"
FREQ
type=FREQ
subgroup=CHURN
noframe
missing
raxis=axis1 maxis=axis2;
run;
title "NOCMIN by CHURN";
vbar NOCMIN /
name = "NOCMIN         x CHURN          " description = "NOCMIN by CHURN"
FREQ
type=FREQ
subgroup=CHURN
noframe
missing
raxis=axis1 maxis=axis2;
run;
title "NOCOPL by CHURN";
vbar NOCOPL /
name = "NOCOPL         x CHURN          " description = "NOCOPL by CHURN"
FREQ
type=FREQ
subgroup=CHURN
noframe
missing
raxis=axis1 maxis=axis2;
run;
title "NOCROZ by CHURN";
vbar NOCROZ /
name = "NOCROZ         x CHURN          " description = "NOCROZ by CHURN"
FREQ
type=FREQ
subgroup=CHURN
noframe
missing
raxis=axis1 maxis=axis2;
run;
title "PLAN_M by CHURN";
vbar PLAN_M /
name = "PLAN_M         x CHURN          " description = "PLAN_M by CHURN"
FREQ
type=FREQ
subgroup=CHURN
noframe
missing
discrete
raxis=axis1 maxis=axis2;
run;
title "POCZTA_G by CHURN";
vbar POCZTA_G /
name = "POCZTA_G       x CHURN          " description = "POCZTA_G by CHURN"
FREQ
type=FREQ
subgroup=CHURN
noframe
missing
discrete
raxis=axis1 maxis=axis2;
run;
title "WIECZMIN by CHURN";
vbar WIECZMIN /
name = "WIECZMIN       x CHURN          " description = "WIECZMIN by CHURN"
FREQ
type=FREQ
subgroup=CHURN
noframe
missing
raxis=axis1 maxis=axis2;
run;
title "WIECZOPL by CHURN";
vbar WIECZOPL /
name = "WIECZOPL       x CHURN          " description = "WIECZOPL by CHURN"
FREQ
type=FREQ
subgroup=CHURN
noframe
missing
raxis=axis1 maxis=axis2;
run;
title "WIECZROZ by CHURN";
vbar WIECZROZ /
name = "WIECZROZ       x CHURN          " description = "WIECZROZ by CHURN"
FREQ
type=FREQ
subgroup=CHURN
noframe
missing
raxis=axis1 maxis=axis2;
run;
quit;
title;
goptions display;
*------------------------------------------------------------*;
* Plot: Copying graphs to node folder;
*------------------------------------------------------------*;
filename gsasfile "C:\Users\Vlad\Documents\SGH\Data_Mining\DM\Workspaces\EMWS2\Plot\GRAPH\CZAS_W by CHURN.png";
goptions device= PNG display gaccess= gsasfile gsfmode= replace cback= white;
proc greplay igout=WORK.PLOTGRAPH nofs;
replay CZAS_W;
quit;
goptions device=win;
filename gsasfile;
filename gsasfile "C:\Users\Vlad\Documents\SGH\Data_Mining\DM\Workspaces\EMWS2\Plot\GRAPH\DZIENMIN by CHURN.png";
goptions device= PNG display gaccess= gsasfile gsfmode= replace cback= white;
proc greplay igout=WORK.PLOTGRAPH nofs;
replay DZIENMIN;
quit;
goptions device=win;
filename gsasfile;
filename gsasfile "C:\Users\Vlad\Documents\SGH\Data_Mining\DM\Workspaces\EMWS2\Plot\GRAPH\DZIENOPL by CHURN.png";
goptions device= PNG display gaccess= gsasfile gsfmode= replace cback= white;
proc greplay igout=WORK.PLOTGRAPH nofs;
replay DZIENOPL;
quit;
goptions device=win;
filename gsasfile;
filename gsasfile "C:\Users\Vlad\Documents\SGH\Data_Mining\DM\Workspaces\EMWS2\Plot\GRAPH\DZIENROZ by CHURN.png";
goptions device= PNG display gaccess= gsasfile gsfmode= replace cback= white;
proc greplay igout=WORK.PLOTGRAPH nofs;
replay DZIENROZ;
quit;
goptions device=win;
filename gsasfile;
filename gsasfile "C:\Users\Vlad\Documents\SGH\Data_Mining\DM\Workspaces\EMWS2\Plot\GRAPH\L_ROZBOK by CHURN.png";
goptions device= PNG display gaccess= gsasfile gsfmode= replace cback= white;
proc greplay igout=WORK.PLOTGRAPH nofs;
replay L_ROZBOK;
quit;
goptions device=win;
filename gsasfile;
filename gsasfile "C:\Users\Vlad\Documents\SGH\Data_Mining\DM\Workspaces\EMWS2\Plot\GRAPH\L_WIAD by CHURN.png";
goptions device= PNG display gaccess= gsasfile gsfmode= replace cback= white;
proc greplay igout=WORK.PLOTGRAPH nofs;
replay L_WIAD;
quit;
goptions device=win;
filename gsasfile;
filename gsasfile "C:\Users\Vlad\Documents\SGH\Data_Mining\DM\Workspaces\EMWS2\Plot\GRAPH\M_MIN by CHURN.png";
goptions device= PNG display gaccess= gsasfile gsfmode= replace cback= white;
proc greplay igout=WORK.PLOTGRAPH nofs;
replay M_MIN;
quit;
goptions device=win;
filename gsasfile;
filename gsasfile "C:\Users\Vlad\Documents\SGH\Data_Mining\DM\Workspaces\EMWS2\Plot\GRAPH\M_OPL by CHURN.png";
goptions device= PNG display gaccess= gsasfile gsfmode= replace cback= white;
proc greplay igout=WORK.PLOTGRAPH nofs;
replay M_OPL;
quit;
goptions device=win;
filename gsasfile;
filename gsasfile "C:\Users\Vlad\Documents\SGH\Data_Mining\DM\Workspaces\EMWS2\Plot\GRAPH\M_ROZM by CHURN.png";
goptions device= PNG display gaccess= gsasfile gsfmode= replace cback= white;
proc greplay igout=WORK.PLOTGRAPH nofs;
replay M_ROZM;
quit;
goptions device=win;
filename gsasfile;
filename gsasfile "C:\Users\Vlad\Documents\SGH\Data_Mining\DM\Workspaces\EMWS2\Plot\GRAPH\NOCMIN by CHURN.png";
goptions device= PNG display gaccess= gsasfile gsfmode= replace cback= white;
proc greplay igout=WORK.PLOTGRAPH nofs;
replay NOCMIN;
quit;
goptions device=win;
filename gsasfile;
filename gsasfile "C:\Users\Vlad\Documents\SGH\Data_Mining\DM\Workspaces\EMWS2\Plot\GRAPH\NOCOPL by CHURN.png";
goptions device= PNG display gaccess= gsasfile gsfmode= replace cback= white;
proc greplay igout=WORK.PLOTGRAPH nofs;
replay NOCOPL;
quit;
goptions device=win;
filename gsasfile;
filename gsasfile "C:\Users\Vlad\Documents\SGH\Data_Mining\DM\Workspaces\EMWS2\Plot\GRAPH\NOCROZ by CHURN.png";
goptions device= PNG display gaccess= gsasfile gsfmode= replace cback= white;
proc greplay igout=WORK.PLOTGRAPH nofs;
replay NOCROZ;
quit;
goptions device=win;
filename gsasfile;
filename gsasfile "C:\Users\Vlad\Documents\SGH\Data_Mining\DM\Workspaces\EMWS2\Plot\GRAPH\PLAN_M by CHURN.png";
goptions device= PNG display gaccess= gsasfile gsfmode= replace cback= white;
proc greplay igout=WORK.PLOTGRAPH nofs;
replay PLAN_M;
quit;
goptions device=win;
filename gsasfile;
filename gsasfile "C:\Users\Vlad\Documents\SGH\Data_Mining\DM\Workspaces\EMWS2\Plot\GRAPH\POCZTA_G by CHURN.png";
goptions device= PNG display gaccess= gsasfile gsfmode= replace cback= white;
proc greplay igout=WORK.PLOTGRAPH nofs;
replay POCZTA_G;
quit;
goptions device=win;
filename gsasfile;
filename gsasfile "C:\Users\Vlad\Documents\SGH\Data_Mining\DM\Workspaces\EMWS2\Plot\GRAPH\WIECZMIN by CHURN.png";
goptions device= PNG display gaccess= gsasfile gsfmode= replace cback= white;
proc greplay igout=WORK.PLOTGRAPH nofs;
replay WIECZMIN;
quit;
goptions device=win;
filename gsasfile;
filename gsasfile "C:\Users\Vlad\Documents\SGH\Data_Mining\DM\Workspaces\EMWS2\Plot\GRAPH\WIECZOPL by CHURN.png";
goptions device= PNG display gaccess= gsasfile gsfmode= replace cback= white;
proc greplay igout=WORK.PLOTGRAPH nofs;
replay WIECZOPL;
quit;
goptions device=win;
filename gsasfile;
filename gsasfile "C:\Users\Vlad\Documents\SGH\Data_Mining\DM\Workspaces\EMWS2\Plot\GRAPH\WIECZROZ by CHURN.png";
goptions device= PNG display gaccess= gsasfile gsfmode= replace cback= white;
proc greplay igout=WORK.PLOTGRAPH nofs;
replay WIECZROZ;
quit;
goptions device=win;
filename gsasfile;
