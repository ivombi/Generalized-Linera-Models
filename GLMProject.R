#Setting working directory
setwd("D:\\Msc. Biostatistics\\Level One\\Second Semester\\General Linear Model\\HomeWork")

#Importing data set
eg<-read.table(file.choose(),header=T,sep = "")
head(eg)
eg$response_new <-0 #Creating a new variable to hold binary response(malform and dead= 1 and normal=0)
dim(eg)

#Creating new variable
eg$response_new[eg$response==3]=1
eg$response_new[eg$response==2]=1

#Creating dummies for each dose level. dose o is reference category

eg$d2<-as.numeric(eg$dose==0.75)
eg$d3<-as.numeric(eg$dose==1.5)
eg$d4<-as.numeric(eg$dose==3)


#logistic regression
logitfit <-glm(eg$response_new~d2+d3+d4,family = binomial(link = "logit"),data = eg)
summary(logitfit)


#Quasi-Likelihood
quasifit <-glm(eg$response_new~d2+d3+d4,family = quasibinomial(link = "logit"),data = eg)
summary(quasifit)

#NOTES
#Slight difference in standard error because of the correction of standard error

#Generalised estimating equation GEE
install.packages("gee")
library(gee) #loading the package

#assuming working correlation structure to be independenc
geefit1 <-gee(factor(eg$response_new)~d2+d3+d4,family = binomial(link = "logit"),id=eg$id,corstr = "independence",data = eg)
summary(geefit1)


#assuming working correlation structure to be exchangeable
geefit2 <-gee(factor(eg$response_new)~factor(eg$dose),family = binomial(link = "logit"),id=eg$id,corstr = "exchangeable")
summary(geefit2)

#assuming working correlation structure to be 
geefit2 <-gee(eg$response_new~d2+d3+d4,family = binomial(link = "logit"),id=eg$id,corstr = "exchangeable",data = eg)
summary(geefit2)

#NOTES
#Unstructured and exchangeable both produce thesame robust std error
#Robust std error for unstructured or exchangeable is larger than that of independence

#Full-Likelihood
install.packages("gamlss")
library(gamlss)
bbfitn<-gamlss(eg$response_new~eg$d2+eg$d3+eg$d4,sigma.formula = ~1,family = BB,data = eg)
summary(bbfitn)

x=bbfitn$sigma.coefficients
rho = exp(x)/(exp(x)+1)
rho
#Generalised Linear Mixed Model(GLMM)
install.packages("lme4")
library(lme4)
glmmfit1 <- glmer(eg$response_new~eg$d2+eg$d3+eg$d4+(1|eg$id),family=binomial(link = "logit"))
summary(glmmfit1)



#Baseline-Category Logits Model
install.packages("VGAM")
library(VGAM)
attach(eg)

basefit <-vglm(response~d2 + d3 + d4,multinomial(refLevel = 3),eg)
summary(basefit) # see sas version for aic 

#adjacent logit model #see sas version
#a)Assuming equal slopes
adjacentfit<-vglm(response~d2+d3+d4,acat(parallel=TRUE),eg)
summary(adjacentfit)

#b)Unequal slopes
adjacentfit<-vglm(response~d2+d3+d4,acat,eg)
summary(adjacentfit)

#Cummulative Link Models
#Proportional odds model.Assuming common slopes
pofit<-vglm(response~d2+d3+d4,propodds(reverse = F),eg)
summary(pofit)

#Cluster Multinomial models
#Proportional odds model extended with GEE

install.packages("multgee")
library(multgee)
po.gee.fit1 = ordLORgee(eg$response~d2+d3+d4,id=id,LORstr = "independence",data=eg)
summary(po.gee.fit1)

po.gee.fit2 = ordLORgee(eg$response~factor(dose),id=id,LORstr = "category.exch",data=eg)
summary(po.gee.fit2)
?ordLORgee

#Random effect model(GLMM)
install.packages("ordinal")
library(ordinal)
po.glmm <-clmm(ordered(eg$response)~eg$d2+eg$d3+eg$d4+(1|eg$id),link="logit",nAGQ = 40)
summary(po.glmm) 
