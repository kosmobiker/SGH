length IMP_PLAN_M 8;
label IMP_PLAN_M = 'Imputed: Plan mi�dzynarodowy';
IMP_PLAN_M = PLAN_M;
if missing(PLAN_M) then IMP_PLAN_M = 0;
