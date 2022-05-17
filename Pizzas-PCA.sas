/*Venu Guddati 4/25/2022 11:00 PM */

/*Part 1 a*/
FILENAME CSV "/home/u60865228/Pizza.csv" TERMSTR=CRLF;


PROC IMPORT DATAFILE=CSV
		    OUT=WORK.Pizza
		    DBMS=CSV
		    REPLACE;
RUN;

PROC PRINT DATA=WORK.Pizza; RUN;

/** Unassign the file reference.  **/

FILENAME CSV;

/*Part1 b*/
proc factor data = WORK.Pizza
corr scree ev method = principal;
var mois prot fat ash sodium carb cal ;
run;

/*Part 2a*/
proc factor data = WORK.Pizza
corr scree ev method = principal;
var mois fat ash sodium carb cal ;
run;


