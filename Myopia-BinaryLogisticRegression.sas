/*Venu Guddati 4/11/2022 10:00 PM */

/** FOR CSV Files uploaded from Windows **/

FILENAME CSV "/home/u60865228/Myopic Data.csv" TERMSTR=CRLF;

/** Import the CSV file.  **/

PROC IMPORT DATAFILE=CSV
		    OUT=WORK.Myopic
		    DBMS=CSV
		    REPLACE;
RUN;

/** Print the results. **/

PROC PRINT DATA=WORK.Myopic; RUN;

/** Unassign the file reference.  **/

FILENAME CSV;

/* PART 1*/
Proc logistic data=work.Myopic;
model myopic (event='1')= Gender ReadHR SportHR StudyHR COMPHR MOMMY DADMY TVHR;
run;

Proc logistic data=work.Myopic DESC;
model myopic = ReadHR SportHR  MOMMY DADMY COMPHR TVHR StudyHR;
run;

/* PART 2 */
Proc reg data=work.Myopic;
model myopic= ReadHR SportHR  MOMMY DADMY COMPHR TVHR StudyHR /vif;
run;

data out1;
set work.Myopic;
ln_readhr=log(ReadHR);
ln_SportHR=log(SportHR);
ln_StudyHR=log(StudyHR);
ln_COMPHR=log(COMPHR);
ln_TVHR=log(TVHR);
run;

/*PROC PRINT DATA=out1; RUN;*/
proc logistic data=out1;
model myopic=ReadHR SportHR DADMY MOMMY StudyHR COMPHR TVHR ReadHR*ln_readhr SportHR*ln_SportHR  COMPHR*ln_COMPHR
TVHR*ln_TVHR StudyHR*ln_StudyHR ;

Proc logistic data=work.Myopic;
model myopic (event='1')= ReadHR SportHR  MOMMY DADMY COMPHR TVHR StudyHR /lackfit ;
run;

/*PART 3 */
Data New;
Input ReadHR DADMY ;
datalines;
5 1 
;
Run;

Data new2;
	set new work.Myopic;
Run;

proc logistic data=new2 descending;
	model myopic= ReadHR DADMY /lackfit; 
	output out=PredProbs predicted=phat; /*creates an output data set called PredProbs*/
	                                     /*Includes a variable called phat 
	                                       which is a probabiliity*/
Run;

/* Print out the Predicted Values of all observations */
proc print Data=PredProbs;
run;



