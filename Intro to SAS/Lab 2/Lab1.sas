data heart_bmi;
	set sashelp.heart;
	height_m = height * 0.0254;
	weight_kg = weight * 0.45;
	BMI = weight_kg /(height_m**2);
run;

proc univariate data=heart_bmi;
	var BMI;
	histogram bmi / kernel normal;
	inset normal mean(8.2) median(8.2) kernel/ position = ne;
run;