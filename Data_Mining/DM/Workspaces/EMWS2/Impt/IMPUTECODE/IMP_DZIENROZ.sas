label IMP_DZIENROZ = 'Imputed: Dzie� rozmowy';
length IMP_DZIENROZ 8;
IMP_DZIENROZ = DZIENROZ;
if missing(DZIENROZ) then IMP_DZIENROZ = 100.44084084;
