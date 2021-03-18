label STD_CZAS_W = 'Transformed: Czas wspó³pracy';
length STD_CZAS_W 8;
if CZAS_W eq . then STD_CZAS_W = .;
else STD_CZAS_W = (CZAS_W - 101.06480648) / 39.822105929;
