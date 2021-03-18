label IMP_M_ROZM = 'Imputed: Miedzynarodowe rozmowy';
length IMP_M_ROZM 8;
IMP_M_ROZM = M_ROZM;
if missing(M_ROZM) then IMP_M_ROZM = 4.48046875;
