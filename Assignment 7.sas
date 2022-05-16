/*Deepika Kolli 4/4/2022 7:00 PM */
Data Baseball;
set SASHELP.Baseball;
run;

proc print data=Baseball;
run;
/*PART A*/
/*calculating the coefficient of correlation(r) to determine the patterns of variation of two or more variables*/
proc corr data=Baseball;
 var salary nhits nruns nouts CrRuns CrHits CrAtBat YrMajor nAtBat nAssts;
 run;
 /* simple linear regression model*/
proc reg data=Baseball;
 model salary=CrRuns;
 run;
/* applied log transformation as the data violated normality and homoscedasticity*/
proc reg data=Baseball;
 model logsalary=CrRuns;
 run;
 
 /*PART B*/

proc reg data=Baseball;
 model logsalary=nhits nruns nouts CrRuns CrHits CrAtBat YrMajor nAtBat nAssts/ selection = stepwise;
 run;
 
 proc reg data=Baseball;
 model logsalary=nhits CrRuns YrMajor nouts/vif ;
 run;