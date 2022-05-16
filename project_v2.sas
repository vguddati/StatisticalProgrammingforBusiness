

FILENAME CSV "/home/u60865228/state_cross_test.csv" TERMSTR=CRLF;

/** Import the CSV file.  **/

PROC IMPORT DATAFILE=CSV
		    OUT=crossing
		    DBMS=CSV
		    REPLACE;
RUN;

/** Print the results. **/

PROC PRINT DATA=crossing; RUN;

/** Unassign the file reference.  **/

FILENAME CSV;

proc freq data= crossing;
tables   
TspeedLMT Lanes Gate HgwySpeedLMT  trainsperday;
run;

Proc logistic data=crossing;
class LandType Signaled Signs HWYPaved Angle HgwyRoad;
model accidents (event="yes") = LandType Signaled Signs HWYPaved Angle HgwyRoad trainsperday
TspeedLMT Totaltracks Lanes Gate HgwySpeedLMT AADTC;  
run;

Proc logistic data=crossing;
class Signs HgwyRoad Signaled HWYPaved;
model accidents (event="yes") =  Signs HgwyRoad 
TspeedLMT Lanes Gate HgwySpeedLMT Signaled trainsperday HWYPaved ; 
run;
Proc logistic data=crossing;
class Signs HgwyRoad Signaled HWYPaved;
model accidents (event="yes") =  Signs HgwyRoad 
TspeedLMT Lanes Gate HgwySpeedLMT Signaled trainsperday HWYPaved/corrb ; 
run;

ods output sgplot=boxplot_data;
proc sgplot data=crossing;
    vbox Gate ;
run;


data out1;
set crossing;
ln_TspeedLMT=log(TspeedLMT);
ln_Lanes=log(Lanes);
ln_HgwySpeedLMT=log(HgwySpeedLMT);
ln_trainsperday=log(trainsperday);
run;
Proc logistic data=out1;
class LandType Signaled Signs HWYPaved Angle HgwyRoad;
model accidents (event="yes") = LandType Signaled Signs HWYPaved Angle HgwyRoad trainsperday
TspeedLMT Totaltracks Lanes Gate HgwySpeedLMT AADTC TspeedLMT*ln_TspeedLMT ln_Lanes*Lanes ln_HgwySpeedLMT*HgwySpeedLMT 
ln_trainsperday*trainsperday; 
run;


Proc logistic data=crossing;
class Signs HgwyRoad;
model accidents (event="yes") =  Signs HgwyRoad 
TspeedLMT Lanes Gate HgwySpeedLMT trainsperday /lackfit ; 
run;

Proc logistic data=crossing;
class LandType Signaled Signs HWYPaved Angle HgwyRoad;
model accidents (event="yes") = LandType Signaled Signs HWYPaved Angle HgwyRoad trainsperday
TspeedLMT Totaltracks Lanes Gate HgwySpeedLMT AADTC/lackfit;  
run;
/* multicollinearity*/
Proc logistic data=crossing;
class LandType Signaled Signs HWYPaved Angle HgwyRoad;
model accidents (event="yes") = LandType Signaled Signs HWYPaved Angle HgwyRoad trainsperday
TspeedLMT Totaltracks Lanes Gate HgwySpeedLMT AADTC/corrb;  
run;

data crossing;
set crossing;
n=ranuni(100); 
run;

data training testing; 
set crossing nobs=nobs; 
if n<=.70*nobs then output training; 
else output testing; 
run;

proc reg data=work.heartout;
model TenYearCHD =  male age education currentSmoker cigsPerDay BPMeds prevalentStroke prevalentHyp diabetes 
                    totChol sysBP diaBP BMI heartRate glucose/ vif tol; 
                    /* all values are less than 10, tol is not less than 0.1 */
run;

Proc logistic data=training;
class LandType Signaled Signs HWYPaved Angle HgwyRoad;
model accidents (event="yes") = LandType Signaled Signs HWYPaved Angle HgwyRoad trainsperday
TspeedLMT Totaltracks Lanes Gate HgwySpeedLMT AADTC/ rsquare lackfit;
output out = PredProbs predicted=phat;
Score data=testing out = Logit_File;
run;

proc print Data=PredProbs;
run;

proc logistic data=Crossing;
   model accidents (event="yes") =trainsperday Gate;
   store logiModel;
run;
 
title "Probability of accidents";
proc plm source=logiModel;
   effectplot fit( x= trainsperday plotby=Gate=0);
run;

proc logistic data=Crossing;
class HgwyRoad;
   model accidents (event="yes") =TspeedLMT HgwyRoad;
   store logiModel;
run;
 
title "Probability of accidents";
proc plm source=logiModel;
   effectplot fit( x= TspeedLMT plotby=HgwyRoad);
run;

ods graphics/noborder;

ods layout start rows=2 columns=2;


ods region row=1 column=1;
proc sgplot data=crossing;
    vbar HgwyRoad/ group=accidents groupdisplay=cluster;
    yaxis grid;
title "Distribution (count) of accidents by highway road type";
run;
title;