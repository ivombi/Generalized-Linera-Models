
*Author:Kubam Ivo
Purpose:GLM Project
Date: 1/4/2019;
data eg;
infile "D:\\Msc. Biostatistics\\Level One\\Second Semester\\General Linear Model\\Data Set\\EG.dat" firstobs=2;
input id dose response;
if response = 2 or response = 3 then response_new = 1; *Creating a new variable to hold binary response:dead or malform = 1 and normal = 0;
else response_new = 0; 
*creating dummies for dose;
d2=0;d3=0;d4=0;
if dose = 0.75 then d2 = 1; if dose = 1.5 then d3=1;if dose=3 then d4=1;

run;
proc print data = eg;
run;

*Binary Cluster data models;
*Quasi_Likelihood;
/*Logistic Regression*/
proc logistic;
model response_new = d2 d3 d4/scale=none;
run;

/*Quasi beta-binomial type*/
proc logistic;
model response_new = d2 d3 d4/ aggregate = (id) scale=williams; *assuming unequal group size which is the case in the data set;
run;
/*QL with Pearson based inflated variance*/
proc logistic;
model response_new = d2 d3 d4/ aggregate = (id) scale=pearson; *assuming equal group size which is not the case in the data set;
run;

/*GEE*/
proc genmod data = eg;
class id;
model response_new = d2 d3 d4 /dist=bin link=logit ;
repeated subject = id/type = exchangeable;
run;
/*Baseline Logit, no clustering*/
proc logistic data = eg;
model response(ref='3')= d2 d3 d4/link=glogit aggregate=(d2 d3 d4) scale =none;
run;

/*Adjacent logit model with equal slopes, no clustering*/
proc logistic data = eg;
model response = d2 d3 d4/link=alogit aggregate=(d2 d3 d4) scale = none;
run;

/*Adjacent logit model with unequal slopes,no clustering*/
proc logistic data = eg;
model response = d2 d3 d4/link=alogit unequalslopes=(d2 d3 d4) aggregate=(d2 d3 d4) scale = none;
run;

/*Cummulative-link models*/
/*Proportional odds model, no clustering*/
proc logistic data = eg;
model response = d2 d3 d4 /aggregate link=logit scale=none;
run;

/*cummulative-probits model, no clustering*/
proc logistic data = eg;
model response = d2 d3 d4 /aggregate link=probit scale=none;
run;

/*cummulative-log-log link model, no clustering*/
proc logistic data = eg;
model response = d2 d3 d4 /aggregate link=cloglog scale=none;
run;

/*Proportional odds model extended with GEE,clustering considered*/
*See R version;
proc genmod data = eg;
class id;
model response = d2 d3 d4/ dist=multinomial link=clogit lrci type3;
repeated subject=id/type=indep; *Independent corr working structured assume;
run;
proc genmod data = eg;
class id;
model response = d2 d3 d4/ dist=multinomial link=clogit lrci type3;
repeated subject=id/type=unstructured; *unstructured corr working structure assume;
run;

/*Proportional odds model extended with GEE,clustering considered*/
*See R version;
*Only the Independent working correlation type is available for multinomial models;


*Random intercept model for the binary outcome;
proc mixed data=eg;
title"Random intercept model";
title2"Binary Outcome";

class id;
model response_new= d2 d3 d4;
random intercept /subject = id solution v g;
*ods listing exclude solutionr;
*ods output solutionr=m.solrwt;
run;

/*GLMM with random intercept approach*/
proc nlmixed ;
eta = alpha + beta2*d2 + beta3*d3 + beta4*d4 + u;
p = exp(eta)/(1+exp(eta));
model response_new ~ binomial(n,p);
random u~normal(0,sigma*sigma) subject=id;
run;


