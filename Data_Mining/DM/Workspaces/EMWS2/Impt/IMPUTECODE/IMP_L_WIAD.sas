label IMP_L_WIAD = 'Imputed: Liczba wiadomoœci';
length IMP_L_WIAD 8;
IMP_L_WIAD = L_WIAD;
if missing(L_WIAD) then IMP_L_WIAD = 8.1038727109;
