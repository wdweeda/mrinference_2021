# mrinference_2021
Data and scripts for the mrinference winterschool 2021

## setting-up R and Rstudio

Download R (https://cran.r-project.org/) and RStudio (https://rstudio.com/products/rstudio/download/#download), you need the free desktop edition.

Once you have opened RStudio we need to install the following packages:
```
install.packages(c('devtools','neuRosim'))
```
After that you need to install niftiR6 from GitHub
```
devtools::install_github('wdweeda/niftiR6')
```
Note that the code is case sensitive.