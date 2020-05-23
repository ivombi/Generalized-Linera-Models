*Creating Byssinosis data set;

data byssinosis;
input smoke dusty diseased count;
cards;
0 1 1 81
0 1 0 364
0 0 1 37
0 0 0 2696
1 1 1 18
1 1 0 196
1 0 1 24
1 0 0 1988
run;

*Testing if smoke is a confounder;

*smoke vs dust;
proc freq data= byssinosis;
tables smoke*dusty/relrisk;
weight count;
run; *Results gives an OR of 0.6532 which indicates a dependency between smoke and dust;

*smoke vs disease;
proc freq data= byssinosis;
tables smoke*diseased/relrisk;
weight count;
run; *Results gives an OR of 0.4987 which indicates a dependency between smoke and diseased.The odds of not been diseased for those 
not smoking is 0.4987 lower than those who smoke. Indirectly Those who smoke have a higher chance of been diseased ;

*Interpretation: smoke is a confounder because it is associtated with dust and diseased;

*Also we can test for confounding by comparing marginal vs partial OR;
*Partial OR;
proc freq data = byssinosis;
tables smoke*dusty*diseased/relrisk;
weight count;
run; * results: OR for dusty vs diseased for smoke yes is 7.6071 and for smoke No is 16.2144

*Marginal OR;
proc freq data = byssinosis;
tables dusty*diseased/relrisk;
weight count;
run; *Results: OR for dusty and diseased without controlling for smoke is 13.5748;

*Conclusion: Marginal and partial show different results, so smoke is a confounding factor. We can't coallapse over smoke;

*Cochran-Mantel-Haenszel Test for conditional Independence;
*Ho:OR's for partial tables equals 1;
proc freq data = byssinosis;
weight count;
tables smoke*dusty*diseased/cmhl chisq;
run; *results: a value of Nonzero correlation of 356.3004 whiich is highly significant suggest rejecting the null Ho for all 
partial OR's = 1


*Question Two;
*Testing for Homogeneity of odds ration ie Ho: Conditional odds ratio are thesame;
*Brelow-Day  test for homogeneity gives a value of 4.0368 with a boarder line decision p-value .0445. so we can't reject Ho

*OR for dusty vs diseased for smoke yes is 7.6071(4.0576, 14.2618 ) and for smoke No is 16.2144(10.8253, 24.2864 ). 
Intervals overlap. so we can't reject Ho at this time. OR are thesame


*Question Three;
*so there is a common odd ratio. This value is estimated by the Mantel_Haenszel estimator which gives 13.3505(9.5546 18.6545)
which is almost similar with logit method with value 12.9956 and interval (9.2512 18.2554)








