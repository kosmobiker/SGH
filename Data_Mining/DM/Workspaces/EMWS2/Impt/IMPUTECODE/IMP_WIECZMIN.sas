label IMP_WIECZMIN = 'Imputed: Wieczór minuty';
length IMP_WIECZMIN 8;
IMP_WIECZMIN = WIECZMIN;
if missing(WIECZMIN) then IMP_WIECZMIN = 200.97545018;
