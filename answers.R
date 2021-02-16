# homework answers
library(neuRosim)

#load data object
load('fmri_data_hrf.RData')

#### EXAMPLE 1 ####
#make regressor without convolution
reg_condA = specifydesign(onsets = condA[,1], 
                          durations = condA[,2], 
                          effectsize = condA[,3], 
                          totaltime = length(s1left)*2, 
                          TR = 2)

#perform GLM analysis
out = lm(s1left ~ 1 + reg_condA)

#plot data and add a red (col=2) line for the regressor
plot(s1left,type='l')
lines(predict(out),col=2)

conv_condA = specifydesign(onsets = condA[,1], 
                          durations = condA[,2], 
                          effectsize = condA[,3], 
                          totaltime = length(s1left)*2, 
                          TR = 2,conv = 'double-gamma')


conv_out = lm(s1left ~ 1 + conv_condA)
plot(s1left,type='l')
lines(predict(conv_out),col=2)

#ANSWER 1
outR = lm(s1right ~ 1 + conv_condA)

plot(s1right,type='l')
lines(predict(outR),col=2)

summary(conv_out)
summary(outR)

reg_condA_gamma = specifydesign(onsets = condA[,1], 
                          durations = condA[,2], 
                          effectsize = condA[,3], 
                          totaltime = length(s1left)*2, 
                          TR = 2,conv = 'gamma')

reg_condA_bal = specifydesign(onsets = condA[,1], 
                                durations = condA[,2], 
                                effectsize = condA[,3], 
                                totaltime = length(s1left)*2, 
                                TR = 2,conv = 'Balloon')


out_gamma = lm(s1right ~ 1 + reg_condA_gamma)
out_bal = lm(s1right ~ 1 + reg_condA_bal)

plot(s1right,type='l')
lines(predict(outR),col=2)
lines(predict(out_gamma),col=3)
lines(predict(out_bal),col=4)

#### EXAMPLE 2a ####
conv_condB = specifydesign(onsets = condB[,1], durations = condB[,2], effectsize = condB[,3], totaltime = length(s1left)*2, TR = 2, conv = 'double-gamma')

plot(conv_condA,type='l',col=2)
lines(conv_condB,col=3)

conv_outAB = lm(s1left ~ 1 + conv_condA + conv_condB)
plot(s1left,type='l')
lines(predict(conv_outAB),col=2)
lines(predict(conv_out),col=3)


#ANSWER 2a
summary(conv_out)
summary(conv_outAB)

reg_condB = specifydesign(onsets = condB[,1], 
                          durations = condB[,2], 
                          effectsize = condB[,3], 
                          totaltime = length(s1left)*2, 
                          TR = 2)

cor(reg_condA,reg_condB)
cor(conv_condA,conv_condB)

#### EXAMPLE 2b ####
dv_conv_condA = c(diff(conv_condA),0)
dv_conv_condB = c(diff(conv_condB),0)

dv_conv_outAB = lm(s1left ~ 1 + conv_condA + dv_conv_condA + conv_condB + dv_conv_condB)

plot(s1left,type='l')
lines(predict(conv_outAB),col=2)
lines(predict(dv_conv_outAB),col=3)

#ANSWER 2b
dv_ABs3l = lm(s3left ~ 1 + conv_condA + dv_conv_condA + conv_condB + dv_conv_condB)
dv_ABs3r = lm(s3right ~ 1 + conv_condA + dv_conv_condA + conv_condB + dv_conv_condB)
nd_ABs3l = lm(s3left ~ 1 + conv_condA + conv_condB)
nd_ABs3r = lm(s3right ~ 1 + conv_condA + conv_condB)

plot(s3left,type='l')
lines(predict(nd_ABs3l),col=2)
lines(predict(dv_ABs3l),col=3)

plot(s3right,type='l')
lines(predict(nd_ABs3r),col=2)
lines(predict(dv_ABs3r),col=3)

summary(nd_ABs3l)
summary(dv_ABs3l)

summary(nd_ABs3r)
summary(dv_ABs3r)

#### EXAMPLE 3 ####
plot(s2left,type='l')

conv_motionAB = lm(s2left ~ 1 + conv_condA + dv_conv_condA + conv_condB + dv_conv_condB)
summary(conv_motionAB)
lines(predict(conv_motionAB),col=2)

mot = matrix(0,nrow=length(s2left),ncol=4)
mot[224,1] = 1
mot[225,2] = 1
mot[226,3] = 1
mot[227,4] = 1


conv_motionAB_plus = lm(s2left ~ 1 + conv_condA + dv_conv_condA + conv_condB + dv_conv_condB + mot)
summary(conv_motionAB_plus)
lines(predict(conv_motionAB_plus),col=3)
lines(predict(conv_motionAB),col=2)

#ANSWER 3
summary(conv_motionAB)
summary(conv_motionAB_plus)

conv_motionAB_r = lm(s2right ~ 1 + conv_condA + dv_conv_condA + conv_condB + dv_conv_condB)
conv_motionAB_plus_r = lm(s2right ~ 1 + conv_condA + dv_conv_condA + conv_condB + dv_conv_condB + mot)

plot(s2right,type='l')
lines(predict(conv_motionAB_plus_r),col=3)
lines(predict(conv_motionAB_r),col=2)

summary(conv_motionAB_r)
summary(conv_motionAB_plus_r)

#### EXAMPLE 4 ####
source('fir.R')
firA <- FIR(onset = condA[,1], tslength = length(s4left), hrflen = 20, window = 2, TR =2)

hrfA <- lm(s4left ~ 1 + firA)
summary(hrfA)

plot(s4left,type='l')
lines(predict(hrfA),col=2)

convs4 <- lm(s4left ~ 1 + conv_condA)
lines(predict(convs4),col=3)

normhrf <- coef(hrfA)[-1]/max(coef(hrfA)[-1])
plot(normhrf,type='l')

lines(neuRosim::specifydesign(0,8,20,2,1,conv='double-gamma'),col=2)

firAB <- FIR(onset = sort(c(condA[,1],condB[,1])), tslength = length(s4left), hrflen = 20, window = 2, TR =2)

hrfAB <- lm(s4left ~ 1 + firAB)
summary(hrfAB)

normhrfAB <- coef(hrfAB)[-1]/max(coef(hrfAB)[-1])
plot(normhrfAB,type='l')
lines(normhrf,col=2)

summary(hrfAB)

plot(s4left,type='l')
lines(predict(hrfAB),col=2)
lines(predict(convs4),col=3)

firB <- FIR(onset = condB[,1], tslength = length(s4left), hrflen = 20, window = 2, TR =2)

hrfABplus <- lm(s4left ~ 1 + firA + firB)
summary(hrfABplus)

normhrfA <- coef(hrfABplus)[-1][1:10]/max(coef(hrfABplus)[-1][1:10])
normhrfB <- coef(hrfABplus)[-1][11:20]/max(coef(hrfABplus)[-1][11:20])

layout(matrix(1:2,ncol=2))
plot(normhrfA,type='l')
plot(normhrfB,type='l')
layout(1)

#ANSWER 4
hrfAB_right <- lm(s4right ~ 1 + firAB)
summary(hrfAB_right)

normhrfAB_right <- coef(hrfAB_right)[-1]/max(coef(hrfAB_right)[-1])
plot(normhrfAB_right,type='l')
lines(normhrfAB,col=2)

hrfAB_s3 <- lm(s3left ~ 1 + firAB)
plot(s3left,type='l')
lines(predict(dv_ABs3l),col=2)
lines(predict(hrfAB_s3),col=3)

summary(dv_ABs3l)
summary(hrfAB_s3)


