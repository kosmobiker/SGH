label IMP_DZIENMIN = 'Imputed: Dzieñ minuty';
length IMP_DZIENMIN 8;
IMP_DZIENMIN = DZIENMIN;
if missing(DZIENMIN) then IMP_DZIENMIN = 179.76166316;
