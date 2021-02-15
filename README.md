# MRInference Winter School, February 15-19 2021
Data and scripts for the MRInference winterschool 2021 LAB session, Monday Februart 15, 14:00 - 16:00.


# Lab Session Monday

During the theoretical part I showed you examples of how the GLM is used to analyse fMRI data, and what the choices and options are in doing these analyses. During this Lab Session we will explore some of these choices on real data. As these analyses are always performed voxel-by-voxel, we will mainly analyse single-voxel data.

## Setting-up R and Rstudio

Download R (https://cran.r-project.org/) and RStudio (https://rstudio.com/products/rstudio/download/#download), you need the free desktop edition.

Once you have opened RStudio we need to install the following packages by copying the code below in the Console window:
```
install.packages('neuRosim')
```
Note that the code is case sensitive.

### Downloading and reading in the data

I've created a dataset based on a real experiment where participants listened to vocal and non-vocal sounds. Full data is available here (https://openneuro.org/datasets/ds000158/versions/1.0.0). I've created bilateral 7x7x7 voxels ROIs in the auditory cortex of pre-processed data of 4 participants and averaged the time-series within these cubes. The resulting data can be downloaded above and read in to R using (make sure the current working directory is set to the directory where you downloaded the data, via `setwd` or using Session > Set Working Directory > Choose directory):
```
load('fmri_data_hrf.RData')
```

## Example 1: Making a regressor
In the R environment there are now 8 objects containing a time-series: `s1left, s1right, s2left, s2right, ...` etc. These are the time-series that we can now do our 'lower-level' or HRF modelling on. To view a time-series we can create a plot.
```
plot(s1left,type='l')
```

Note that the time-series is indicating the value of the BOLD signal every 2 seconds, since the aqcuisition of a single volume takes 2 seconds (TR=2). Now we need to make our regressors for our design matrix X. For this we need the onset times, durations, and weights of the stimuli of the different conditions. They are stored in the objects `condA` and `condB`. To view them type:
```
condA
```

The first column contains the timing in seconds, the second contains the duration of the stimuli in seconds, and the third column indicates the weight (or multiplication factor) of the stimuli. We can use the function `specifydesign` from the `neuRosim` package for this. It takes the timings, durations and weights (called effect sizes in the function) and creates a (convolved) regressor. First lets create an unconvolved regressor
```
reg_condA = specifydesign(onsets = condA[,1], durations = condA[,2], effectsize = condA[,3], totaltime = length(s1left)*2, TR = 2)
```

The `totaltime` value is the total time of the time-series in seconds, hence it is the length of the time-series times the TR of 2 seconds. `reg_condA` now contains the timings and duration of the first condition. We can plot this as well:
```
plot(reg_condA,type='l')
```

We can now try and run a simple regression on subject 1's left cortex data.
```
out = lm(s1left ~ 1 + reg_condA)
```

Type `out` to see the outcome of the regression and `summary(out)` for a complete summary with tests.
```
plot(s1left,type='l')
lines(predict(out),col=2)
```

The regressor does not seem to fit the data very well yet. But, of course, we have not convolved the data with our HRF. Let's do that now.
```
conv_condA = specifydesign(onsets = condA[,1], durations = condA[,2], effectsize = condA[,3], totaltime = length(s1left)*2, TR = 2, conv = 'double-gamma')
```
(You can ignore the warning). We've now created a new regressor named `conv_condA`. Let's see how it looks by typing `plot(conv_condA,type='l')`. This is the reg_condA vector but now convolved with the HRF. Let's run our regression again as well, but now with the new regressor.
```
conv_out = lm(s1left ~ 1 + conv_condA)
```

For a summary type `summary(conv_out)`. Now the regressor seems to fit much better! Let's check this visually.
```
plot(s1left,type='l')
lines(predict(conv_out),col=2)
```

And this is basically what happens under the hood when doing fMRI analysis. For the next section we'll expand our design matrix by incorporating different regressors to see what kind of analyses can be done (and how flexible the GLM is in doing these analyses).

Quick summary:
* `s1left` is an object containing the data
* `condA` is a data.frame with the stimulus timings, durations, and weights in each column
* `reg_condA` is a regressor without convolution output by the `specifydesign` function to be used in the design matrix
* `conv_condA` is a regressor where the timings are convolved with the HRF
* `conv_out` is the output of the regression analysis using the function `lm`

It might be useful to collect the code in a script. Make a new script by clicking File > New File > R script. In this script (basically just a text file with a .R extension) you can copy paste the relevant code. You can subsequently copy and paste this code in the R console (or source the entire script so it will run all lines at once).

Example code for the first analysis can be found in `intial_code.R` on github.

### Questions
1. The analysis above is performed for `s1left` try and perform this analysis for `s1right` with the convolved regressor.
2. Can you spot differences in model fit?
3. Are there differences in terms of regression coefficients?
4. Try and see whether you can run an analysis with a different HRF model. In `specifydesign` the option `conv = ` allows for different inputs (try and run `?specifydesign` in the command line to see them). Now it is set to `double-gamma`, the other options are `balloon` and `gamma`. Can you see differences in outcome when you use a different HRF? 

## Example 2: Extending the model

We have just performed the analysis that is the backbone of almost all task-based fMRI studies! This is what happens for every voxel time-series. This first analysis fitted a simple regression model, where we modeled only one condition. In the actual experiment there are two conditions. So let us extend the regression model with this second condition.

```
conv_condB = specifydesign(onsets = condB[,1], durations = condB[,2], effectsize = condB[,3], totaltime = length(s1left)*2, TR = 2, conv = 'double-gamma')
```

This is the convolved regressor for the second condition. Let's plot the two regressors to see how they look.
```
plot(conv_condA,type='l',col=2)
lines(conv_condB,col=3)
```

As you can see the different colors indicate the different regressors. The different conditions are dispersed randomly and there is enough overlap between regressors. We can now run a GLM with both these regressors. We can incorporate them in the `lm` statement using a `+` sign. In the `lm` command we use formula notation: $y = ax + b_{1}x + b_2{x}$ is written as `y ~ 1 + conv_condA + conv_condB` (y equals and intercept + regressor 1 + regressor 2). Run and plot.

```
conv_outAB = lm(s1left ~ 1 + conv_condA + conv_condB)
plot(s1left,type='l')
lines(predict(conv_outAB),col=2)
```
This seems to fit the data better than our first model. Let's add this line for reference.
```
lines(predict(conv_out),col=3)
```
As can be seen the red line captures data much better than the green line alone, also, the model fit of the model with two regressors is much better.

### Questions
1. Compare the estimate for condition A in the summary of `conv_out` and `conv_outAB`, are there differences in terms of the strength of these coefficients? Can you explain?
2. Create a regressor without convolution for condition B. And calculate a correlation with this regressor and the unconvolved regressor of `reg_condA`. (Hint use the function `cor(reg_condA, reg_condB)`)
3. Now correlate the convolved regressors. What is the correlation now?

## Example 3: Solving model mismatch

In the above analyses we've assumed a fixed shape of the HRF, while this leads to efficient estimation, any differences in the actual BOLD signal are not taken into account. For example, the peak of the HRF might be later than is assumed in the fixed HRF model. To correct for this we can extend the model using additional regressors. One of the most widely used addition regressors is the 'temporal derivative', which allows for the peak of the HRF to be shifted in time (earlier and later). The derivative is a function of the slope of the HRF and can be calculated using the `diff` function in R (we approximate the slope of the HRF by making a function of the difference between adjacent time-points, we add a 0 at the end to make the vector of the correct length again).
```
dv_conv_condA = c(diff(conv_condA),0)
dv_conv_condB = c(diff(conv_condB),0)
```

Let's now run the model on our data again with our added derivative regressors.
```
dv_conv_outAB = lm(s1left ~ 1 + conv_condA + dv_conv_condA + conv_condB + dv_conv_condB)
```
And plot both the model with and without derivatives.
```
plot(s1left,type='l')
lines(predict(conv_outAB),col=2)
lines(predict(dv_conv_outAB),col=3)
```
As you can see, the addition of these temporal derivatives seem to improve the model even further.

### Questions
1. Run a model with two regressors, one with derivatives and one without derivatives on the data from subject 3 (`s3left` and `s3right` seperately). Do you notice any differences in model fit between the models with and without derivatives, and between the outcomes of `s3left` and `s3right`.
2. What could have happened with subject 3's time-series?
