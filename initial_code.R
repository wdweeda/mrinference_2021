#load packages
library(neuRosim)

#load data object
load('fmri_data_hrf.RData')

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

#make regressor with convolution
conv_condA = specifydesign(onsets = condA[,1], 
                           durations = condA[,2], 
                           effectsize = condA[,3], 
                           totaltime = length(s1left)*2, 
                           TR = 2, 
                           conv = 'double-gamma')

#perform GLM analysis
conv_out = lm(s1left ~ 1 + conv_condA)

#add a green (col=3) line to the plot for the convolved regressor
lines(predict(conv_out),col=3)
