*Solution for Homework one GLM;
*Question One;
*Creating the Race and opinion after life data set;

DATA afterlife;
input race $ believe $ count;
cards;
white yes 621
white no 239
black yes 89
black no 42
;
run;

*Printing data set;
proc print data = afterlife;

*Calculating risk difference or difference in proportion;
proc freq data = afterlife order=data ;
tables race*believe/riskdiff alpha= 0.1 ;
weight count;
run;


*Calculating Relative Risk ratio;
proc freq data = afterlife order=data;
tables race*believe/relrisk alpha= 0.1;
weight count;
run;

*Calculating chisqaure;
proc freq data = afterlife;
tables race*believe/expected chisq measures;
weight count;
run;

*Exercise Two;

*Creating the data set;

data breast_cancer;
input test $ score detect $ count;
cards;
never 0 notlikely 13
never 0 somewhatlikey 77
never 0 verylikely 144
overoneyearago 1 notlikely 4
overoneyearago 1 somewhatlikey 16
overoneyearago 1 verylikely 54
withinpasttwoyear 2 notlikely 1
withinpasttwoyear 2 somewhatlikey 12
withinpasttwoyear 2 verylikely 91
;
run;

proc print data = breast_cancer;

*Calculating chis square and likelihood ratio ;
proc freq data = breast_cancer;
tables test*detect/expected chisq;
weight count;
run;

*Calculating M2 test ;

proc freq data = breast_cancer;
tables test*detect/expected chisq cmh measures scorout;
weight count;
run;


*Exercise Three;
*Creating Data set;
* Scores are coded as 1 2 3 4 5 ;
data maternalalcohol;
input  malform alcohol counts;
cards;
0 1 17066
0 2 14464
0 3 788
0 4 126
0 5 37
1 1 28 
1 2 38
1 3 5 
1 4 1 
1 5 1 
;
run;
proc print data = maternalalcohol;
run;


proc corr data = maternalalcohol;
var alcohol malform;
freq counts;
run; *Correlation of 0.0003;

proc freq data = maternalalcohol; 
tables alcohol*malform/chisq cmh1 measures scorout;
weight counts;
run; *Results shows that Likelihood Ratio Chi-Square with 4df, value of  12.0708 and p value of 0.0168 
While Mantel-Haenszel Chi-Square with 1df, value of  12.8416 and p value of 0.0003. Both test having almost equal values. 
Manner in which score was coded didn't really affect values
Correlation of 0.0003 between variables was significant; 

* Scores are coded as 0,0.5,1.5,4,8 ;
data maternalalcohol2;
input  malform alcohol counts;
cards;
0 0 17066
0 0.5 14464
0 1.5 788
0 4 126
0 8 37
1 0 28 
1 0.5 38
1 1.5 5 
1 4 1 
1 8 1 
;
run;
proc print data = maternalalcohol2;
run;

proc corr data = maternalalcohol2;
var alcohol malform;
freq counts;
run;*Correlation is 0.0244. Higher than previous method of scoring; 


proc freq data = maternalalcohol2;
tables alcohol*malform/chisq cmh1 measures scorout;
exact MHCHI;
weight counts;
run; 

*Exercise 4;
*Creating data set;

data sports;
input injury surgery count;
cards;
0 2 3
0 1 2
1 2 7
1 1 1
;
run;
proc corr data = sports;
var injury surgery;
freq count;
run;

proc freq data = sports;
tables injury*surgery/exact ci;
weight count;
run; * Results didnot show any relationship between injury and surgery 

proc freq data = sports;
tables injury*surgery/relrisk;
weight count;
run;

