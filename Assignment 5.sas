/*Deepika Kolli 3/21/2022 3:00 PM */
Data Shoes;
set SASHELP.Shoes;
run;
/*proc print data=Shoes;
run;*/
/*part 1*/

title'Total Average sales of Boot, Sandals and Slippers';
Proc SGPLOT data=Shoes;
vbar Product/ response=Sales stat=mean 
fillattrs=(color=cyan)
           barwidth = .5 			          
 categoryorder= respdesc; 
where Product='Boot' or Product='Sandal' or Product='Slipper' ;
run;

/*part 2*/
title'Distribution of Sales in Asia';
Proc Boxplot data=Shoes;
plot (Sales )* Region / boxstyle=schematic outbox=summary; 
where Region='Asia';
run;

proc print data=summary;
run;

/*part 3*/
title'Percentage composition of Products';
proc Gchart data=Shoes;                                               
        pie3d Product /type=pct 
                explode='Slipper'
        		slice=arrow;
run;       
quit;                                                                   





