length IMP_POCZTA_G 8;
label IMP_POCZTA_G = 'Imputed: Poczta g³osowa';
IMP_POCZTA_G = POCZTA_G;
if missing(POCZTA_G) then IMP_POCZTA_G = 0;
