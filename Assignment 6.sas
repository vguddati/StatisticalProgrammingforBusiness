/*Deepika Kolli 4/3/2022 6:00 PM */
Data Cars;
set SASHELP.Cars;
run;
/*PART A*/
proc means data=Cars MEAN;
 var MSRP;
 var MPG_City;
 var MPG_Highway;
 var Cylinders;
 class Make;
 where Make ='BMW' or 
 Make = 'Audi' or
 Make = 'Infiniti';
run;

/* PART B*/
Data Cars1;
set Cars;
where Make = 'Audi';
run;
proc univariate data=Cars1;
var MPG_City;
qqplot MPG_City;
histogram MPG_City;
run;
proc ttest data=Cars1 h0=20 alpha=.05 sides=U;
var MPG_City;
run;

/* PART C*/

proc ttest data=Cars  alpha=.05;
class Make;
where Make in('Audi','BMW'); 
var MPG_Highway;
run;


