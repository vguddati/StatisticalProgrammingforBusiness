/*Deepika Kolli 4/16/2022 6:00 PM */

data FireFighter;
Length Rank $ 11; 
Input Rank $ @12 BasePay comma11. @24 OT comma15.;
datalines;
FIREFIGHTER    $78,554     $17,640 
FIREFIGHTER    $78,526     $18,111 
CAPTAIN    $110,006     $20,955 
FIREFIGHTER    $80,466     $28,833 
ENGINEER    $85,256     $19,865 
ENGINEER    $93,521     $29,621 
FIREFIGHTER    $78,505     $23,786 
ENGINEER    $94,040     $27,945 
FIREFIGHTER    $82,845     $26,886 
ENGINEER    $87,852     $21,589 
ENGINEER    $88,963     $29,529 
FIREFIGHTER    $78,562     $29,632 
FIREFIGHTER    $78,549     $17,862 
CAPTAIN    $107,686     $27,838 
FIREFIGHTER    $78,530     $26,711 
ENGINEER    $85,318     $22,702 
ENGINEER    $87,833     $24,297 
FIREFIGHTER    $78,390     $28,634 
CAPTAIN    $110,525     $18,607 
CAPTAIN    $107,242     $23,892 
FIREFIGHTER    $78,494     $29,549 
FIREFIGHTER    $78,493     $20,961 
CAPTAIN    $110,456     $15,222 
ENGINEER    $93,703     $21,775 
FIREFIGHTER    $84,347     $20,577 
CAPTAIN    $109,896     $18,172 
ENGINEER    $92,641     $20,557 
FIREFIGHTER    $78,392     $26,611 
FIREFIGHTER    $78,509     $16,329 
FIREFIGHTER    $82,033     $23,983
CAPTAIN    $107,527    $27,828 
CAPTAIN    $117,656     $29,836 
ENGINEER    $93,521     $26,651 
ENGINEER    $93,521     $28,421 
ENGINEER    $93,521     $26,431 
CAPTAIN    $119,333     $25,938 
CAPTAIN    $120,686     $26,138 
CAPTAIN    $110,898     $28,832  
;
run;

proc print data=FireFighter;
run;
/*PART 1*/
Data FireFighter1;
	Set FireFighter;
	If OT >25000 then OverTimePay = 'High';
	/*Using an ELSE statement -- only evaluates if the statement above is false*/
	Else If OT<25000 then OverTimePay = 'Low';
	
Run;

proc print data=FireFighter;
run;
/* One Way Chi Square Test of Proportion */
Proc freq data=FireFighter1;
Tables OverTimePay / TestP=(0.40 0.60);
run;

/*PART 2*/

/* Two Way Chi Square  Test of Independence */
Proc freq data=FireFighter1;
Tables OverTimePay*Rank / chisq
plots=(freqplot(twoway=groupvertical scale=percent));
run;

/*PART 3*/
/*Basic Anova procedure*/
proc ANOVA data=FireFighter1;
Class Rank;
model OT = Rank;
means Rank / tukey lines;
run;

proc glm data=FireFighter1;
Class Rank;
model BasePay = Rank/ ss3; /*Only produces table for type 3 SS*/
means Rank / tukey lines cldiff;  /*pariwise comparison of group means*/
run;



