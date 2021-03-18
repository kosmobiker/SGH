label IMP_NOCROZ = 'Imputed: Noc rozmowy';
length IMP_NOCROZ 8;
IMP_NOCROZ = NOCROZ;
if missing(NOCROZ) then IMP_NOCROZ = 100.11207933;
