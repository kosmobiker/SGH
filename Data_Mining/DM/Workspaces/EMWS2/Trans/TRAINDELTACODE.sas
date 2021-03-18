
if NAME="STD_CZAS_W" then do;
   COMMENT = "(CZAS_W - 101.06480648) / 39.822105929 ";
ROLE ="INPUT";
REPORT ="N";
LEVEL  ="INTERVAL";
end;
if NAME="CZAS_W" then delete;
