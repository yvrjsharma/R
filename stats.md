
R Notebook for Probability and statistical Inference
====================================================

Abstract
========

In building a General Linear Statistical Model, we first need to understand and define accurately what is happening inside the data. This report is written to find exactly that. It finds out if there are evidences of relationships in the data and it uses appropriate tests and makes decisions based on their results. A relationship is found to have strength and a direction associated with it. This report further identifies if there are any differential effects for different groups.  
This report will explore two relationships, one between number of absences and final maths grades, other one between maths grades in period one and final maths grades.  
It will also check for differential effects of gender on number of absences, mother’s job on a student’s final maths grades.  
Lastly, it will explore if maths grades in period one and two are similar or not.

In order to find out the relationships and differences, this report conducts statistical analysis on the given dataset. The dataset is taken from the [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/student+performance). For description of the variables present in this dataset, one can also refer this [paper](https://repositorium.sdum.uminho.pt/bitstream/1822/8024/1/student.pdf).

    #Code chunk for setup
    #Install following R libraries if needed, before loading them here 
    #Example - install.packages("userfriendlyscience")
    #Importing libraries 
    library(pastecs) #For creating descriptive statistic summaries
    library(dplyr) #For working on dataframe like objects 
    library(ggplot2) #For creating histograms with more detail than plot
    library(psych) # Some useful descriptive functions
    library(semTools) #For skewness and kurtosis
    library(car) # For Levene's test for homogeneity of variance
    library(coin) #for Wilcoxon test
    library(userfriendlyscience) #This library has a one-way anova function that provides nice summary output
    library(stats) #For statstical functions
    library(FSA) #For running the post-hoc tests
    library(rstatix) #Kruskal wallis effect size
    library(sjstats) #chi-square effect size
    
    
    #Reading data file
    #We are using a .csv file (studentsrenamed.csv) obtained from UCI ML Repository.
    #This data describes student achievement in secondary education of two Portuguese schools. The data attributes include student grades, demographic, social and school related features. Two datasets are merged together from two distinct subjects: Mathematics (columnname.m) and Portuguese language (columnname.p).
    #Getting the current working directory
    getwd()

    [1] "C:/Users/Yuvi/Desktop/MSc DataScience/Sem1/Stats and Probability Inference/Assignment1"

    #Make sure the data file is in the same folder, else qualify the path to the file.
    students <- read.csv("studentsrenamed.csv",fileEncoding="UTF-8-BOM")
    
    #Setting the column names to be that used in the dataset but in lowercase
    colnames(students) <- tolower(colnames(students))
    

1\. Introduction
================

1.1 Background
--------------

A report is constructed which states the various hypothesis that are being tested.

*   One hypothesis to test for Correlation between different variables.
*   One hypothesis to test whether two samples are derived from the same population. Or in other words, if two samples are taken from same population, then test whether they have fairly similar means.
*   One hypothesis to test if there is a significant change in samples collected at different point in time.
*   One hypothesis to test when we have more than two levels of measurement on our independent variable. In other owrds, we test whether the groups are different or similar.

In this report -

*   In section 1.2, the variables of interest are analysed and described. These variables are explained in terms of their statistical measurement types and are described with appropriate descriptive statistics and graphs.
*   While deciding on the choice of a statistical test, all the assumptions and conditions have been met.
*   Outcomes of the tests conducted are reported in paragraphs using full sentences using APA style for reporting statistical results.
*   Effect as well as statistical significance, both have been discussed and commented upon.
*   At the end, findings are appropriately interpreted based on the initial hypothesis.

1.2 Dataset description
-----------------------

### INSPECT mG1

**mG1 or Maths Grade At Period 1**  
It is a scale variable.  
To inspect any scale variable, we need to perform following steps -

*   Generate summary statistics
*   Calculate skewness and kurtosis
*   Calculate standardised scores
*   Generate a histogram with a normal curve on it
*   Generate a Q-Q plot
*   By reviewing the statistics and plots we can decide whether a variable is parametric or non-parametric

Likewise, mG2, mG3, absences.m are also scale variables, and will be inspected similarly.

    
    #Numerical summary and histograms of mG1 
    
    #stat.desc is a function from pastecs - we include the basic switch=F to ensure we don't get scienfitic notation
    pastecs::stat.desc(students$mg1, basic=F)

          median         mean      SE.mean CI.mean.0.95          var      std.dev     coef.var 
      10.5000000   10.8612565    0.1713583    0.3369264   11.2169202    3.3491671    0.3083591 

    #skewness and kurtosis from semTools with standard error
    tpskew<-semTools::skew(students$mg1)
    tpkurt<-semTools::kurtosis(students$mg1)
    
    #We divide the skew statistic by the standard error to get the standardised score
    tpskew[1]/tpskew[2]

    skew (g1) 
     2.205097 

    tpkurt[1]/tpkurt[2]

    Excess Kur (g2) 
          -2.742249 

    #Create standardised scores and sort
    sort(scale(students$mg1))

      [1] -2.34722733 -2.04864564 -1.75006394 -1.75006394 -1.75006394 -1.75006394 -1.75006394 -1.75006394
      [9] -1.75006394 -1.45148224 -1.45148224 -1.45148224 -1.45148224 -1.45148224 -1.45148224 -1.45148224
     [17] -1.45148224 -1.45148224 -1.45148224 -1.45148224 -1.45148224 -1.45148224 -1.45148224 -1.45148224
     [25] -1.45148224 -1.45148224 -1.45148224 -1.45148224 -1.45148224 -1.45148224 -1.45148224 -1.45148224
     [33] -1.45148224 -1.45148224 -1.15290054 -1.15290054 -1.15290054 -1.15290054 -1.15290054 -1.15290054
     [41] -1.15290054 -1.15290054 -1.15290054 -1.15290054 -1.15290054 -1.15290054 -1.15290054 -1.15290054
     [49] -1.15290054 -1.15290054 -1.15290054 -1.15290054 -1.15290054 -1.15290054 -1.15290054 -1.15290054
     [57] -1.15290054 -1.15290054 -1.15290054 -1.15290054 -1.15290054 -1.15290054 -1.15290054 -1.15290054
     [65] -1.15290054 -1.15290054 -1.15290054 -1.15290054 -1.15290054 -0.85431884 -0.85431884 -0.85431884
     [73] -0.85431884 -0.85431884 -0.85431884 -0.85431884 -0.85431884 -0.85431884 -0.85431884 -0.85431884
     [81] -0.85431884 -0.85431884 -0.85431884 -0.85431884 -0.85431884 -0.85431884 -0.85431884 -0.85431884
     [89] -0.85431884 -0.85431884 -0.85431884 -0.85431884 -0.85431884 -0.85431884 -0.85431884 -0.85431884
     [97] -0.85431884 -0.85431884 -0.85431884 -0.85431884 -0.85431884 -0.85431884 -0.85431884 -0.85431884
    [105] -0.85431884 -0.85431884 -0.85431884 -0.85431884 -0.85431884 -0.85431884 -0.55573714 -0.55573714
    [113] -0.55573714 -0.55573714 -0.55573714 -0.55573714 -0.55573714 -0.55573714 -0.55573714 -0.55573714
    [121] -0.55573714 -0.55573714 -0.55573714 -0.55573714 -0.55573714 -0.55573714 -0.55573714 -0.55573714
    [129] -0.55573714 -0.55573714 -0.55573714 -0.55573714 -0.55573714 -0.55573714 -0.55573714 -0.55573714
    [137] -0.55573714 -0.55573714 -0.55573714 -0.55573714 -0.25715544 -0.25715544 -0.25715544 -0.25715544
    [145] -0.25715544 -0.25715544 -0.25715544 -0.25715544 -0.25715544 -0.25715544 -0.25715544 -0.25715544
    [153] -0.25715544 -0.25715544 -0.25715544 -0.25715544 -0.25715544 -0.25715544 -0.25715544 -0.25715544
    [161] -0.25715544 -0.25715544 -0.25715544 -0.25715544 -0.25715544 -0.25715544 -0.25715544 -0.25715544
    [169] -0.25715544 -0.25715544 -0.25715544 -0.25715544 -0.25715544 -0.25715544 -0.25715544 -0.25715544
    [177] -0.25715544 -0.25715544 -0.25715544 -0.25715544 -0.25715544 -0.25715544 -0.25715544 -0.25715544
    [185] -0.25715544 -0.25715544 -0.25715544 -0.25715544 -0.25715544 -0.25715544 -0.25715544  0.04142626
    [193]  0.04142626  0.04142626  0.04142626  0.04142626  0.04142626  0.04142626  0.04142626  0.04142626
    [201]  0.04142626  0.04142626  0.04142626  0.04142626  0.04142626  0.04142626  0.04142626  0.04142626
    [209]  0.04142626  0.04142626  0.04142626  0.04142626  0.04142626  0.04142626  0.04142626  0.04142626
    [217]  0.04142626  0.04142626  0.04142626  0.04142626  0.04142626  0.04142626  0.04142626  0.04142626
    [225]  0.04142626  0.04142626  0.04142626  0.04142626  0.04142626  0.34000796  0.34000796  0.34000796
    [233]  0.34000796  0.34000796  0.34000796  0.34000796  0.34000796  0.34000796  0.34000796  0.34000796
    [241]  0.34000796  0.34000796  0.34000796  0.34000796  0.34000796  0.34000796  0.34000796  0.34000796
    [249]  0.34000796  0.34000796  0.34000796  0.34000796  0.34000796  0.34000796  0.34000796  0.34000796
    [257]  0.34000796  0.34000796  0.34000796  0.34000796  0.34000796  0.34000796  0.63858965  0.63858965
    [265]  0.63858965  0.63858965  0.63858965  0.63858965  0.63858965  0.63858965  0.63858965  0.63858965
    [273]  0.63858965  0.63858965  0.63858965  0.63858965  0.63858965  0.63858965  0.63858965  0.63858965
    [281]  0.63858965  0.63858965  0.63858965  0.63858965  0.63858965  0.63858965  0.63858965  0.63858965
    [289]  0.63858965  0.63858965  0.63858965  0.93717135  0.93717135  0.93717135  0.93717135  0.93717135
    [297]  0.93717135  0.93717135  0.93717135  0.93717135  0.93717135  0.93717135  0.93717135  0.93717135
    [305]  0.93717135  0.93717135  0.93717135  0.93717135  0.93717135  0.93717135  0.93717135  0.93717135
    [313]  0.93717135  0.93717135  0.93717135  0.93717135  0.93717135  0.93717135  1.23575305  1.23575305
    [321]  1.23575305  1.23575305  1.23575305  1.23575305  1.23575305  1.23575305  1.23575305  1.23575305
    [329]  1.23575305  1.23575305  1.23575305  1.23575305  1.23575305  1.23575305  1.23575305  1.23575305
    [337]  1.23575305  1.23575305  1.23575305  1.23575305  1.53433475  1.53433475  1.53433475  1.53433475
    [345]  1.53433475  1.53433475  1.53433475  1.53433475  1.53433475  1.53433475  1.53433475  1.53433475
    [353]  1.53433475  1.53433475  1.53433475  1.53433475  1.53433475  1.53433475  1.53433475  1.53433475
    [361]  1.53433475  1.53433475  1.53433475  1.83291645  1.83291645  1.83291645  1.83291645  1.83291645
    [369]  1.83291645  1.83291645  1.83291645  2.13149815  2.13149815  2.13149815  2.13149815  2.13149815
    [377]  2.13149815  2.13149815  2.13149815  2.43007985  2.43007985  2.43007985

#### Inferences :

*   Since both, Skew and Kurtosis are not falling in the range of -2 and 2 (rounded up 1.96), we will check for standardized scores.
*   Since, our sample size is more than 80 (it is 382), if 95% of our data falls within +/- 3.29 then we can treat the data as normal
*   Entire data lies between +/- 3.39 in our case, so **it is ok to treat mG1 as Normal**

### GRAPH mG1

We can also check for normal distribution, by looking at histogram and Q-Q plots  
**QQ plot** It is a plot between Expected and Observed Z-scores. If it is a normal distribution, more and more points will lie on the reference line.

**Histogram with normal curve** Basically it compares the spacing of our data to what we would expect to see in terms of spacing if our data were approximately normal.  
If our data is approximately normally distributed, only few observations will come in both the tails. More and more observations will come as we move towards the mean(centre) from the either side. The spacing is symmetric about the mean.

    #We will allocate the histogram to a variable to allow us to manipulate it
    gg <- ggplot(students, aes(x=students$mg1))
    
    #Change the label of the x axis
    gg <- gg + labs(x="Maths Grade at Period 1")
    #manage binwidth and colours
    gg <- gg + geom_histogram(binwidth=2, colour="black", aes(y=..density.., fill=..count..))
    gg <- gg + scale_fill_gradient("Count", low="#DCDCDC", high="#7C7C7C")
    #adding a normal curve
    #use stat_function to compute a normalised score for each value of tpcois
    #pass the mean and standard deviation
    #use the na.rm parameter to say how missing values are handled
    gg <- gg + stat_function(fun=dnorm, color="red",args=list(mean=mean(students$mg1, na.rm=TRUE), sd=sd(students$mg1, na.rm=TRUE)))
    #to display the graph request the contents of the variable be shown
    gg

![](/images/plot1.jpg)

    #Create a qqplot
    qqnorm(students$mg1)
    qqline(students$mg1, col=2) #show a line on theplot
    

![](/images/plot2.jpg)

#### Inferences from Graphs :

*   It appears normal from both histogram and QQ Plot

### INSPECT mG2

**Maths Grades in Period 2 - mG2**

    
    #numerical summary and histograms of mG2 
    
    #stat.desc is a function from pastecs - we include the basic switch=F to ensure we don't get scienfitic notation
    pastecs::stat.desc(students$mg2, basic=F)

          median         mean      SE.mean CI.mean.0.95          var      std.dev     coef.var 
      11.0000000   10.7120419    0.1960908    0.3855557   14.6885160    3.8325600    0.3577805 

    #skewness and kurtosis from semTools with standard error
    tpskew<-semTools::skew(students$mg2)
    tpkurt<-semTools::kurtosis(students$mg2)
    
    #We divide the skew statistic by the standard error to get the standardised score
    tpskew[1]/tpskew[2]

    skew (g1) 
    -3.193143 

    tpkurt[1]/tpkurt[2]

    Excess Kur (g2) 
           2.023209 

    #Create standardised scores and sort
    sort(scale(students$mg2))

      [1] -2.79500958 -2.79500958 -2.79500958 -2.79500958 -2.79500958 -2.79500958 -2.79500958 -2.79500958
      [9] -2.79500958 -2.79500958 -2.79500958 -2.79500958 -2.79500958 -1.49039856 -1.49039856 -1.49039856
     [17] -1.49039856 -1.49039856 -1.49039856 -1.49039856 -1.49039856 -1.49039856 -1.49039856 -1.49039856
     [25] -1.49039856 -1.49039856 -1.49039856 -1.49039856 -1.49039856 -1.22947636 -1.22947636 -1.22947636
     [33] -1.22947636 -1.22947636 -1.22947636 -1.22947636 -1.22947636 -1.22947636 -1.22947636 -1.22947636
     [41] -1.22947636 -1.22947636 -1.22947636 -1.22947636 -0.96855415 -0.96855415 -0.96855415 -0.96855415
     [49] -0.96855415 -0.96855415 -0.96855415 -0.96855415 -0.96855415 -0.96855415 -0.96855415 -0.96855415
     [57] -0.96855415 -0.96855415 -0.96855415 -0.96855415 -0.96855415 -0.96855415 -0.96855415 -0.96855415
     [65] -0.70763195 -0.70763195 -0.70763195 -0.70763195 -0.70763195 -0.70763195 -0.70763195 -0.70763195
     [73] -0.70763195 -0.70763195 -0.70763195 -0.70763195 -0.70763195 -0.70763195 -0.70763195 -0.70763195
     [81] -0.70763195 -0.70763195 -0.70763195 -0.70763195 -0.70763195 -0.70763195 -0.70763195 -0.70763195
     [89] -0.70763195 -0.70763195 -0.70763195 -0.70763195 -0.70763195 -0.70763195 -0.70763195 -0.70763195
     [97] -0.44670974 -0.44670974 -0.44670974 -0.44670974 -0.44670974 -0.44670974 -0.44670974 -0.44670974
    [105] -0.44670974 -0.44670974 -0.44670974 -0.44670974 -0.44670974 -0.44670974 -0.44670974 -0.44670974
    [113] -0.44670974 -0.44670974 -0.44670974 -0.44670974 -0.44670974 -0.44670974 -0.44670974 -0.44670974
    [121] -0.44670974 -0.44670974 -0.44670974 -0.44670974 -0.44670974 -0.44670974 -0.44670974 -0.44670974
    [129] -0.44670974 -0.44670974 -0.44670974 -0.44670974 -0.44670974 -0.44670974 -0.44670974 -0.44670974
    [137] -0.44670974 -0.44670974 -0.44670974 -0.44670974 -0.44670974 -0.44670974 -0.44670974 -0.44670974
    [145] -0.18578754 -0.18578754 -0.18578754 -0.18578754 -0.18578754 -0.18578754 -0.18578754 -0.18578754
    [153] -0.18578754 -0.18578754 -0.18578754 -0.18578754 -0.18578754 -0.18578754 -0.18578754 -0.18578754
    [161] -0.18578754 -0.18578754 -0.18578754 -0.18578754 -0.18578754 -0.18578754 -0.18578754 -0.18578754
    [169] -0.18578754 -0.18578754 -0.18578754 -0.18578754 -0.18578754 -0.18578754 -0.18578754 -0.18578754
    [177] -0.18578754 -0.18578754 -0.18578754 -0.18578754 -0.18578754 -0.18578754 -0.18578754 -0.18578754
    [185] -0.18578754 -0.18578754 -0.18578754 -0.18578754  0.07513467  0.07513467  0.07513467  0.07513467
    [193]  0.07513467  0.07513467  0.07513467  0.07513467  0.07513467  0.07513467  0.07513467  0.07513467
    [201]  0.07513467  0.07513467  0.07513467  0.07513467  0.07513467  0.07513467  0.07513467  0.07513467
    [209]  0.07513467  0.07513467  0.07513467  0.07513467  0.07513467  0.07513467  0.07513467  0.07513467
    [217]  0.07513467  0.07513467  0.07513467  0.07513467  0.33605687  0.33605687  0.33605687  0.33605687
    [225]  0.33605687  0.33605687  0.33605687  0.33605687  0.33605687  0.33605687  0.33605687  0.33605687
    [233]  0.33605687  0.33605687  0.33605687  0.33605687  0.33605687  0.33605687  0.33605687  0.33605687
    [241]  0.33605687  0.33605687  0.33605687  0.33605687  0.33605687  0.33605687  0.33605687  0.33605687
    [249]  0.33605687  0.33605687  0.33605687  0.33605687  0.33605687  0.33605687  0.33605687  0.33605687
    [257]  0.33605687  0.59697908  0.59697908  0.59697908  0.59697908  0.59697908  0.59697908  0.59697908
    [265]  0.59697908  0.59697908  0.59697908  0.59697908  0.59697908  0.59697908  0.59697908  0.59697908
    [273]  0.59697908  0.59697908  0.59697908  0.59697908  0.59697908  0.59697908  0.59697908  0.59697908
    [281]  0.59697908  0.59697908  0.59697908  0.59697908  0.59697908  0.59697908  0.59697908  0.59697908
    [289]  0.59697908  0.59697908  0.59697908  0.59697908  0.85790128  0.85790128  0.85790128  0.85790128
    [297]  0.85790128  0.85790128  0.85790128  0.85790128  0.85790128  0.85790128  0.85790128  0.85790128
    [305]  0.85790128  0.85790128  0.85790128  0.85790128  0.85790128  0.85790128  0.85790128  0.85790128
    [313]  0.85790128  1.11882348  1.11882348  1.11882348  1.11882348  1.11882348  1.11882348  1.11882348
    [321]  1.11882348  1.11882348  1.11882348  1.11882348  1.11882348  1.11882348  1.11882348  1.11882348
    [329]  1.11882348  1.11882348  1.11882348  1.11882348  1.11882348  1.11882348  1.11882348  1.11882348
    [337]  1.11882348  1.11882348  1.11882348  1.11882348  1.11882348  1.11882348  1.11882348  1.11882348
    [345]  1.11882348  1.11882348  1.11882348  1.11882348  1.37974569  1.37974569  1.37974569  1.37974569
    [353]  1.37974569  1.37974569  1.37974569  1.37974569  1.37974569  1.37974569  1.37974569  1.37974569
    [361]  1.37974569  1.64066789  1.64066789  1.64066789  1.64066789  1.64066789  1.90159010  1.90159010
    [369]  1.90159010  1.90159010  1.90159010  1.90159010  1.90159010  1.90159010  1.90159010  1.90159010
    [377]  1.90159010  1.90159010  1.90159010  2.16251230  2.16251230  2.16251230

#### Inferences :

*   Since both, Skew and Kurtosis are not falling in the range of -2 and 2 (rounded up 1.96), we will check for standardized scores.
*   Since, our sample size is more than 80 (it is 382), if 95% of our data falls within +/- 3.29 then we can treat the data as normal
*   Entire data lies between +/- 3.39 in our case, so **it is ok to treat mG2 as Normal**

### GRAPH mG2

We can also check for normal distribution, by looking at histogram and Q-Q plots

**QQ plot** It is a plot between Expected and Observed Z-scores. If it is a normal distribution, more and more points will lie on the reference line.

**Histogram with normal curve** Basically it compares the spacing of our data to what we would expect to see in terms of spacing if our data were approximately normal.  
If our data is approximately normally distributed, only few observations will come in both the tails. More and more observations will come as we move towards the mean(centre) from the either side. The spacing is symmetric about the mean.

    #We will allocate the histogram to a variable to allow us to manipulate it
    gg <- ggplot(students, aes(x=students$mg2))
    
    #Change the label of the x axis
    gg <- gg + labs(x="Maths Grade at Period 2")
    #manage binwidth and colours
    gg <- gg + geom_histogram(binwidth=2, colour="black", aes(y=..density.., fill=..count..))
    gg <- gg + scale_fill_gradient("Count", low="#DCDCDC", high="#7C7C7C")
    #adding a normal curve
    #use stat_function to compute a normalised score for each value of tpcois
    #pass the mean and standard deviation
    #use the na.rm parameter to say how missing values are handled
    gg <- gg + stat_function(fun=dnorm, color="red",args=list(mean=mean(students$mg2, na.rm=TRUE), sd=sd(students$mg2, na.rm=TRUE)))
    #to display the graph request the contents of the variable be shown
    gg

![](/images/qq6.jpg)

    #Create a qqplot
    qqnorm(students$mg2)
    qqline(students$mg2, col=2) #show a line on theplot
    

![](/images/qq5.jpg)

#### Inferences from Graphs :

*   It appears normal from both histogram and QQ Plot

### INSPECT mG3

**Final Maths Grades - mG3**

    #numerical summary and histograms of mG3 
    
    #stat.desc is a function from pastecs - we include the basic switch=F to ensure we don't get scienfitic notation
    pastecs::stat.desc(students$mg3, basic=F)

          median         mean      SE.mean CI.mean.0.95          var      std.dev     coef.var 
      11.0000000   10.3874346    0.2398202    0.4715368   21.9702354    4.6872418    0.4512415 

    #skewness and kurtosis from semTools with standard error
    tpskew<-semTools::skew(students$mg3)
    tpkurt<-semTools::kurtosis(students$mg3)
    
    #We divide the skew statistic by the standard error to get the standardised score
    tpskew[1]/tpskew[2]

    skew (g1) 
     -5.63212 

    tpkurt[1]/tpkurt[2]

    Excess Kur (g2) 
           1.108522 

    #Create standardised scores and sort
    sort(scale(students$mg3))

      [1] -2.21610812 -2.21610812 -2.21610812 -2.21610812 -2.21610812 -2.21610812 -2.21610812 -2.21610812
      [9] -2.21610812 -2.21610812 -2.21610812 -2.21610812 -2.21610812 -2.21610812 -2.21610812 -2.21610812
     [17] -2.21610812 -2.21610812 -2.21610812 -2.21610812 -2.21610812 -2.21610812 -2.21610812 -2.21610812
     [25] -2.21610812 -2.21610812 -2.21610812 -2.21610812 -2.21610812 -2.21610812 -2.21610812 -2.21610812
     [33] -2.21610812 -2.21610812 -2.21610812 -2.21610812 -2.21610812 -2.21610812 -2.21610812 -1.36272778
     [41] -1.14938269 -1.14938269 -1.14938269 -1.14938269 -1.14938269 -1.14938269 -1.14938269 -0.93603760
     [49] -0.93603760 -0.93603760 -0.93603760 -0.93603760 -0.93603760 -0.93603760 -0.93603760 -0.93603760
     [57] -0.93603760 -0.93603760 -0.93603760 -0.93603760 -0.93603760 -0.93603760 -0.72269252 -0.72269252
     [65] -0.72269252 -0.72269252 -0.72269252 -0.72269252 -0.72269252 -0.50934743 -0.50934743 -0.50934743
     [73] -0.50934743 -0.50934743 -0.50934743 -0.50934743 -0.50934743 -0.50934743 -0.50934743 -0.50934743
     [81] -0.50934743 -0.50934743 -0.50934743 -0.50934743 -0.50934743 -0.50934743 -0.50934743 -0.50934743
     [89] -0.50934743 -0.50934743 -0.50934743 -0.50934743 -0.50934743 -0.50934743 -0.50934743 -0.50934743
     [97] -0.50934743 -0.50934743 -0.50934743 -0.50934743 -0.29600234 -0.29600234 -0.29600234 -0.29600234
    [105] -0.29600234 -0.29600234 -0.29600234 -0.29600234 -0.29600234 -0.29600234 -0.29600234 -0.29600234
    [113] -0.29600234 -0.29600234 -0.29600234 -0.29600234 -0.29600234 -0.29600234 -0.29600234 -0.29600234
    [121] -0.29600234 -0.29600234 -0.29600234 -0.29600234 -0.29600234 -0.29600234 -0.29600234 -0.08265726
    [129] -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726
    [137] -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726
    [145] -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726
    [153] -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726
    [161] -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726
    [169] -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726
    [177] -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726 -0.08265726  0.13068783
    [185]  0.13068783  0.13068783  0.13068783  0.13068783  0.13068783  0.13068783  0.13068783  0.13068783
    [193]  0.13068783  0.13068783  0.13068783  0.13068783  0.13068783  0.13068783  0.13068783  0.13068783
    [201]  0.13068783  0.13068783  0.13068783  0.13068783  0.13068783  0.13068783  0.13068783  0.13068783
    [209]  0.13068783  0.13068783  0.13068783  0.13068783  0.13068783  0.13068783  0.13068783  0.13068783
    [217]  0.13068783  0.13068783  0.13068783  0.13068783  0.13068783  0.13068783  0.13068783  0.13068783
    [225]  0.13068783  0.13068783  0.34403291  0.34403291  0.34403291  0.34403291  0.34403291  0.34403291
    [233]  0.34403291  0.34403291  0.34403291  0.34403291  0.34403291  0.34403291  0.34403291  0.34403291
    [241]  0.34403291  0.34403291  0.34403291  0.34403291  0.34403291  0.34403291  0.34403291  0.34403291
    [249]  0.34403291  0.34403291  0.34403291  0.34403291  0.34403291  0.34403291  0.34403291  0.34403291
    [257]  0.55737800  0.55737800  0.55737800  0.55737800  0.55737800  0.55737800  0.55737800  0.55737800
    [265]  0.55737800  0.55737800  0.55737800  0.55737800  0.55737800  0.55737800  0.55737800  0.55737800
    [273]  0.55737800  0.55737800  0.55737800  0.55737800  0.55737800  0.55737800  0.55737800  0.55737800
    [281]  0.55737800  0.77072309  0.77072309  0.77072309  0.77072309  0.77072309  0.77072309  0.77072309
    [289]  0.77072309  0.77072309  0.77072309  0.77072309  0.77072309  0.77072309  0.77072309  0.77072309
    [297]  0.77072309  0.77072309  0.77072309  0.77072309  0.77072309  0.77072309  0.77072309  0.77072309
    [305]  0.77072309  0.77072309  0.77072309  0.77072309  0.98406817  0.98406817  0.98406817  0.98406817
    [313]  0.98406817  0.98406817  0.98406817  0.98406817  0.98406817  0.98406817  0.98406817  0.98406817
    [321]  0.98406817  0.98406817  0.98406817  0.98406817  0.98406817  0.98406817  0.98406817  0.98406817
    [329]  0.98406817  0.98406817  0.98406817  0.98406817  0.98406817  0.98406817  0.98406817  0.98406817
    [337]  0.98406817  0.98406817  0.98406817  0.98406817  1.19741326  1.19741326  1.19741326  1.19741326
    [345]  1.19741326  1.19741326  1.19741326  1.19741326  1.19741326  1.19741326  1.19741326  1.19741326
    [353]  1.19741326  1.19741326  1.19741326  1.19741326  1.19741326  1.41075835  1.41075835  1.41075835
    [361]  1.41075835  1.41075835  1.41075835  1.62410343  1.62410343  1.62410343  1.62410343  1.62410343
    [369]  1.62410343  1.62410343  1.62410343  1.62410343  1.62410343  1.62410343  1.62410343  1.62410343
    [377]  1.83744852  1.83744852  1.83744852  1.83744852  1.83744852  2.05079361

#### Inferences :

*   Since both, Skew is not falling in the range of -2 and 2 (rounded up 1.96), we will check for standardized scores.
*   Since, our sample size is more than 80 (it is 382), if 95% of our data falls within +/- 3.29 then we can treat the data as normal
*   Entire data lies between +/- 3.39 in our case, so **it is ok to treat mG3 as Normal**

### GRAPH mG3

We can also check for normal distribution, by looking at histogram and Q-Q plots

**QQ plot** It is a plot between Expected and Observed Z-scores. If it is a normal distribution, more and more points will lie on the reference line.

**Histogram with normal curve** Basically it compares the spacing of our data to what we would expect to see in terms of spacing if our data were approximately normal.  
If our data is approximately normally distributed, only few observations will come in both the tails. More and more observations will come as we move towards the mean(centre) from the either side. The spacing is symmetric about the mean.

    #We will allocate the histogram to a variable to allow us to manipulate it
    gg <- ggplot(students, aes(x=students$mg3))
    
    #Change the label of the x axis
    gg <- gg + labs(x="Final Maths Grade")
    #manage binwidth and colours
    gg <- gg + geom_histogram(binwidth=2, colour="black", aes(y=..density.., fill=..count..))
    gg <- gg + scale_fill_gradient("Count", low="#DCDCDC", high="#7C7C7C")
    #adding a normal curve
    #use stat_function to compute a normalised score for each value of tpcois
    #pass the mean and standard deviation
    #use the na.rm parameter to say how missing values are handled
    gg <- gg + stat_function(fun=dnorm, color="red",args=list(mean=mean(students$mg3, na.rm=TRUE), sd=sd(students$mg3, na.rm=TRUE)))
    #to display the graph request the contents of the variable be shown
    gg

![](/images/qq4.jpg)

    #Create a qqplot
    qqnorm(students$mg3)
    qqline(students$mg3, col=2) #show a line on theplot
    

![](/images/qq3.jpg)

#### Inferences from Graphs :

*   It appears normal from both histogram and QQ Plot

### INSPECT absences.m

**Number of School Absences - absences.m**

    
    #numerical summary and histograms of absences.m 
    
    #stat.desc is a function from pastecs - we include the basic switch=F to ensure we don't get scienfitic notation
    pastecs::stat.desc(students$absences.m, basic=F)

          median         mean      SE.mean CI.mean.0.95          var      std.dev     coef.var 
       3.0000000    5.3193717    0.3901418    0.7671006   58.1444531    7.6252510    1.4334872 

    #skewness and kurtosis from semTools with standard error
    tpskew<-semTools::skew(students$absences.m)
    tpkurt<-semTools::kurtosis(students$absences.m)
    
    #We divide the skew statistic by the standard error to get the standardised score
    tpskew[1]/tpskew[2]

    skew (g1) 
     32.26225 

    tpkurt[1]/tpkurt[2]

    Excess Kur (g2) 
            106.969 

    #Create standardised scores and sort
    sort(scale(students$absences.m))

      [1] -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956
      [9] -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956
     [17] -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956
     [25] -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956
     [33] -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956
     [41] -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956
     [49] -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956
     [57] -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956
     [65] -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956
     [73] -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956
     [81] -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956
     [89] -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956
     [97] -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956
    [105] -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.69759956
    [113] -0.69759956 -0.69759956 -0.69759956 -0.69759956 -0.56645633 -0.56645633 -0.56645633 -0.43531311
    [121] -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311
    [129] -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311
    [137] -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311
    [145] -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311
    [153] -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311
    [161] -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311
    [169] -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311
    [177] -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311 -0.43531311
    [185] -0.43531311 -0.43531311 -0.30416989 -0.30416989 -0.30416989 -0.30416989 -0.30416989 -0.30416989
    [193] -0.17302666 -0.17302666 -0.17302666 -0.17302666 -0.17302666 -0.17302666 -0.17302666 -0.17302666
    [201] -0.17302666 -0.17302666 -0.17302666 -0.17302666 -0.17302666 -0.17302666 -0.17302666 -0.17302666
    [209] -0.17302666 -0.17302666 -0.17302666 -0.17302666 -0.17302666 -0.17302666 -0.17302666 -0.17302666
    [217] -0.17302666 -0.17302666 -0.17302666 -0.17302666 -0.17302666 -0.17302666 -0.17302666 -0.17302666
    [225] -0.17302666 -0.17302666 -0.17302666 -0.17302666 -0.17302666 -0.17302666 -0.17302666 -0.17302666
    [233] -0.17302666 -0.17302666 -0.17302666 -0.17302666 -0.17302666 -0.17302666 -0.17302666 -0.17302666
    [241] -0.17302666 -0.17302666 -0.17302666 -0.04188344 -0.04188344 -0.04188344 -0.04188344  0.08925979
    [249]  0.08925979  0.08925979  0.08925979  0.08925979  0.08925979  0.08925979  0.08925979  0.08925979
    [257]  0.08925979  0.08925979  0.08925979  0.08925979  0.08925979  0.08925979  0.08925979  0.08925979
    [265]  0.08925979  0.08925979  0.08925979  0.08925979  0.08925979  0.08925979  0.08925979  0.08925979
    [273]  0.08925979  0.08925979  0.08925979  0.08925979  0.08925979  0.22040301  0.22040301  0.22040301
    [281]  0.22040301  0.22040301  0.22040301  0.22040301  0.22040301  0.35154623  0.35154623  0.35154623
    [289]  0.35154623  0.35154623  0.35154623  0.35154623  0.35154623  0.35154623  0.35154623  0.35154623
    [297]  0.35154623  0.35154623  0.35154623  0.35154623  0.35154623  0.35154623  0.35154623  0.35154623
    [305]  0.35154623  0.35154623  0.48268946  0.48268946  0.48268946  0.61383268  0.61383268  0.61383268
    [313]  0.61383268  0.61383268  0.61383268  0.61383268  0.61383268  0.61383268  0.61383268  0.61383268
    [321]  0.61383268  0.61383268  0.61383268  0.61383268  0.61383268  0.61383268  0.74497590  0.74497590
    [329]  0.87611913  0.87611913  0.87611913  0.87611913  0.87611913  0.87611913  0.87611913  0.87611913
    [337]  0.87611913  0.87611913  1.00726235  1.00726235  1.00726235  1.13840557  1.13840557  1.13840557
    [345]  1.13840557  1.13840557  1.13840557  1.13840557  1.13840557  1.13840557  1.13840557  1.13840557
    [353]  1.26954880  1.26954880  1.26954880  1.40069202  1.40069202  1.40069202  1.40069202  1.40069202
    [361]  1.40069202  1.53183525  1.66297847  1.66297847  1.66297847  1.66297847  1.79412169  1.92526492
    [369]  1.92526492  2.05640814  2.18755136  2.18755136  2.18755136  2.31869459  2.44983781  2.58098103
    [377]  2.71212426  2.97441071  3.23669715  6.38413452  6.64642097  9.13814222

#### Inferences :

*   Since both, Skew and Kurtosis are not falling in the range of -2 and 2 (rounded up 1.96), we will check for standardized scores. Skew value is very high (~32), showing a high positive skew, which you can see in below graphs too.
*   Since, our sample size is more than 80 (it is 382), if 95% of our data falls within +/- 3.29 then we can treat the data as normal
*   Entire data lies between +/- 3.39 in our case, so **it is ok to say that absences.m variable is approaching Normality**

### GRAPH absence.m

We can also check for normal distribution, by looking at histogram and Q-Q plots

**QQ plot** It is a plot between Expected and Observed Z-scores. If it is a normal distribution, more and more points will lie on the reference line.

**Histogram with normal curve** Basically it compares the spacing of our data to what we would expect to see in terms of spacing if our data were approximately normal.  
If our data is approximately normally distributed, only few observations will come in both the tails. More and more observations will come as we move towards the mean(centre) from the either side. The spacing is symmetric about the mean.

    #We will allocate the histogram to a variable to allow us to manipulate it
    gg <- ggplot(students, aes(x=students$absences.m))
    
    #Change the label of the x axis
    gg <- gg + labs(x="Number of School Absences (Maths)")
    #manage binwidth and colours
    gg <- gg + geom_histogram(binwidth=2, colour="black", aes(y=..density.., fill=..count..))
    gg <- gg + scale_fill_gradient("Count", low="#DCDCDC", high="#7C7C7C")
    #adding a normal curve
    #use stat_function to compute a normalised score for each value of tpcois
    #pass the mean and standard deviation
    #use the na.rm parameter to say how missing values are handled
    gg <- gg + stat_function(fun=dnorm, color="red",args=list(mean=mean(students$absences.m, na.rm=TRUE), sd=sd(students$absences.m, na.rm=TRUE)))
    #to display the graph request the contents of the variable be shown
    gg

![](/images/qq2.jpg)

    #Create a qqplot
    qqnorm(students$absences.m)
    qqline(students$absences.m, col=2) #show a line on theplot
    

![](/images/qq1.jpg)

#### Inferences from Graphs :

*   It appears positively skewed from both histogram and QQ Plot

1.3 Hypothesis
--------------

> A Hypothesis is always a statement about population parameter.

1.  Hypothesis 1 - **Correlation** between Maths Grade at Period 1 and Final Maths Grade  
    Ho: There is no relationship between mG1 and mG3  
    Ha: There is a relationship between mG1 and mG3
    
2.  Hypothesis 2 - **Correlation** between Number of School Absences and Final Maths Grade  
    Ho: There is no relationship between absences.m and mG3  
    Ha: There is a relationship between absences.m and mG3
    
3.  Hypothesis 3 - **Difference** Independent samples t-test for Gender  
    Ho: Population means are equal for both males and females  
    Ha: Population means are different
    
4.  Hypothesis 4 - ANOVA **Difference involving a categorical variable with more than 2 values** for Mother’s job  
    Ho: means of first group is equal second, which is equal to third, fourth and fifth (all means are equal)  
    Ha: Atleast one mean value is different from other groups
    
5.  Hypothesis 5 - **Repeated Measures** - Paired Sample t-test on Maths grade in Period one and Period two  
    Ho: Population means are equal for both mg1 and mg2  
    Ha: Population means are different
    

2\. Results
===========

My findings from the various tests, explained in sub-sections for each hypothesis along with separate code chunks for each.

2.1 Hypothesis 1 - Correlation between Maths Grade at Period 1 and Final Maths Grade
------------------------------------------------------------------------------------

> **Hypothesis** - Two-tailed hypothesis

> *   Ho: There is no relationship between mG1 and mG3
> *   Ha: There is a relationship between mG1 and mG3

Correlation Assumptions are as follows :

*   **Level of Measurement** - the two variables should be ratio or scaler variables.
    *   mG1 is Scale variable
    *   mG3 is Scale variable
*   **Related Pairs** - Each variable should hava a value for every case or sample
    *   There are no missing values in mG1
    *   There are no missing values in mG3
*   **Independence of Observations** - Every meansurement is independent or uninfluenced from the other
    *   This data approach student achievement in secondary education of two Portuguese schools.The data attributes include student grades, demographic, social and school related features) and it was collected by using school reports and questionnaires. It is highly likely that every observation is indepentdent.
*   **Normality** - Scores should be normally distributed
    *   mG1 is normally distributed as explained in section 1.2
    *   mG3 is normally distributed as explained in section 1.2
*   **Linearity** - A linear relationship must exist between the two variables. Both Linearity and Homoscedasticity refer to the shape formed by the scatterplot. You should be able to draw a straight line and not a curve through the plots, from left to right.
    *   Scatter plots of mG1 and mG3 suggest that there exist a linear relationship between them.
*   **Homoscedasticity** - Variability should be similar in both the variables. Homoscedasticity basically referrs to the distance between the points from the straight line drawn through the plot to describe it.
    *   The scatter plot of two variables, mG1 and mG3, suggest that the data points spread like a tube around the straight line, hence there is Homoscedasticity. If there would have been a cone like structure, we would have concluded that Homoscadasticity is not met.

> Since, all the above assumptions are meeting, we can run Correlation tests on these two parametric variables - mG1 and mG3.

#### Scatterplot

    #Code chunk for hypothesis 1 
    #Simple scatterplot of mG1 and mG3
    #aes(x,y)
    scatter <- ggplot(students, aes(students$mg1, students$mg3))
    scatter + geom_point() + labs(x = "Maths Grade at Period 1", y = "Final Maths Grade") 

![](/images/scatter3.jpg)
    
    #Add a regression line
    scatter + geom_point() + geom_smooth(method = "lm", colour = "Red", se = F) + labs(x = "Maths Grade at Period 1", y = "Final Maths Grade") 
    

![](/images/scatter4.jpg)

There appears to be a positive correlation. As Maths Grade in Period 1 increases, Final Maths Grade increase too.

#### Conducting Correlation Test - Pearson

    #Code chunk for hypothesis 2
    #Pearson Correlation
    #We can also use Spearman and kendall's tau tests to test Correlation if required 
    stats::cor.test(students$mg1, students$mg3, method='pearson')

    
        Pearson's product-moment correlation
    
    data:  students$mg1 and students$mg3
    t = 26.462, df = 380, p-value < 2.2e-16
    alternative hypothesis: true correlation is not equal to 0
    95 percent confidence interval:
     0.7667312 0.8377861
    sample estimates:
          cor 
    0.8051287 

Understanding the tests output -

*   df, degrees of freedom = 380
*   p-value, indicates whether you have a statistically significant result or not < 0.001
*   cor, Pearson’s Correlation Coefficient also referred as r while reporting = 0.805

Here r = 0.805 (rounded to three decimal places)  
Using Cohen’s heuristic - Since r is >= +-0.5, there is a strong correlation between mG1 and mG3

Reporting a Pearson Correlation in words

> “The relationship between Maths grade at period 1 (mG1 derived from the Student Performance Data Set) and Final maths grade (mG3 derived from the Student Performance Data Set) was investigated using a Pearson correlation. A strong positive correlation was found (r =.805, n=380, p<.001). A statistically significant p-value (<0.001) suggests that we have enough evidence to reject the null hypothesis in favor of our alternative hypothesis.”

2.2 Hypothesis 2 - Correlation between Number of School Absences and Final Maths Grade
--------------------------------------------------------------------------------------

> **Hypothesis** - Two-tailed hypothesis

> *   Ho: There is no relationship between absences.m and mG3
> *   Ha: There is a relationship between absences.m and mG3

Correlation Assumptions are as follows :

*   **Level of Measurement** - the two variables should be ratio or scaler variables.
    *   absences.m is Scale variable
    *   mG3 is Scale variable
*   **Related Pairs** - Each variable should hava a value for every case or sample
    *   There are no missing values in absences.m
    *   There are no missing values in mG3
*   **Independence of Observations** - Every meansurement is independent or uninfluenced from the other
    *   This data approach student achievement in secondary education of two Portuguese schools.The data attributes include student grades, demographic, social and school related features) and it was collected by using school reports and questionnaires. It is highly likely that every observation is indepentdent.
*   **Normality** - Scores should be normally distributed
    *   absences.m is normally distributed as explained in section 1.2
    *   mG3 is normally distributed as explained in section 1.2
*   **Linearity** - A linear relationship must exist between the two variables. Both Linearity and Homoscedasticity refer to the shape formed by the scatterplot. You should be able to draw a straight line and not a curve through the plots, from left to right.
    *   Scatter plots of absences.m and mG3 suggest that there exist a linear relationship between them.
*   **Homoscedasticity** - Variability should be similar in both the variables. Homoscedasticity basically referrs to the distance between the points from the straight line drawn through the plot to describe it.
    *   The scatter plot of two variables, absences.m and mG3, suggest that the data points spread like a tube around the straight line, hence there is Homoscedasticity. If there would have been a cone like structure, we would have concluded that Homoscadasticity is not met.

> Since, all the above assumptions are met, we can run Correlation tests on our two parametric variables - absences.m and mG3.

#### Scatterplot

    #Code chunk for hypothesis 2
    #Simple scatterplot of mG1 and mG3
    #aes(x,y)
    scatter <- ggplot(students, aes(students$mg3,students$absences.m))
    scatter + geom_point() + labs(x = "Final Maths Grade", y = "Number of School Absences") 

![](/images/scatter1.jpg)

    
    #Add a regression line
    scatter + geom_point() + geom_smooth(method = "lm", colour = "Red", se = F) + labs(x = "Number of School Absences", y = "Final Maths Grade") 

![](/images/scatter2.jpg)

There appears to be no correlation between Number of School Absences and Final Maths Grade.

#### Conducting Correlation Test - Pearson

    #Code chunk for hypothesis 2
    #Pearson Correlation
    #We can also use Spearman and kendall's tau tests to test Correlation if required 
    stats::cor.test(students$absences.m, students$mg3, method='pearson')

    
        Pearson's product-moment correlation
    
    data:  students$absences.m and students$mg3
    t = 0.5653, df = 380, p-value = 0.5722
    alternative hypothesis: true correlation is not equal to 0
    95 percent confidence interval:
     -0.0715587  0.1289500
    sample estimates:
           cor 
    0.02898725 

Understanding the tests output -

*   df, degrees of freedom = 380
*   p-value, indicates whether you have a statistically significant result or not = 0.572
*   cor, Pearson’s Correlation Coefficient also referred as r while reporting = 0.029

Here r = 0.029 (rounded to three decimal places) Using Cohen’s heuristic - Since r is between +-0.1, there is very weak or no correlation between absences.m and mG3.

Reporting a Pearson Correlation in words

> “The relationship between Number of School Absences (absences.m derived from the Student Performance Data Set) and Final maths grade (mG3 derived from the Student Performance Data Set) was investigated using a Pearson correlation. A very weak or no correlation was found (r = 0.029, n=380, p>0.05). A statistically non-significant p-value (>0.05) suggests that we don’t have enough evidence to reject the null hypothesis in favor of our alternative hypothesis.”

2.3 Hypothesis 3 - Independent samples t-test between
-----------------------------------------------------

> Hypothesis – It is always a statement about population parameter.

> *   Ho: Population means are equal
> *   Ha: Population means are different

> So this is again a two-tail test as we are only proving whether two mean are different. It would have been a one-tail test if we either proved that mean of one population is greater or smaller than the other.

There are two **assumptions** of t-tests, and they are as follows -

*   Assumption of normality (t-test is a parametric test)
    *   Data should be interval or scale.
    *   It should be normally distributed. As per section 1.2 inspection of absences.m variable is approaching normmality, and hence can be treated as parametric.
*   Assumption of Homogeneity of variance. In other words, Variances in two populations are roughly equal.
    *   If the samples in each group are large and nearly equal, the t-test can still be conducted even though assumptions are not met. Sex has two groups - male and female. Levene Test is showing that there is a homogeneity of variance.

We will be conducting the **independent t-test**, as these assumptions have been met and also because the observations are independent of each other. Grades of different students are measured in different or independent conditions.

### Differences - Parametric Tests

#### Inspecting Categorical Variable - sex (gender of student)

    #Code chunk for hypothesis 3
    
    #Get descriptive stastitics by group
    #describeBy is part of the psych package so you need to use it
    psych::describeBy(students$absences.m,group=students$sex)

    
     Descriptive statistics by group 
    group: F

![](/images/statpost1_3.jpg)

#### Levene test

Choosing Levene Test because its a very robust test for normally distributed data, it can handle slight deviations from normality. And absence.m variable is approaching normality, even though it’s bit positively skewed.

    #Conduct Levene's test for homogeneity of variance in library car
    
    car::leveneTest(absences.m~sex, data=students)

    Levene's Test for Homogeneity of Variance (center = median)
           Df F value Pr(>F)
    group   1  2.5549 0.1108
          380               

Leven’s test output:

*   F-statistic = 2.555
*   significance value, or p-value = 0.111 (>0.05)

Test is coming non-significant so we can assume _homogeneity of variance_. Or that, variance of two groups is similar.

#### Independent t-test

    #Conduct the t-test
    #var=True specifies equal variances
    t.test(absences.m~sex,var.equal=TRUE, data=students)

    
        Two Sample t-test
    
    data:  absences.m by sex
    t = 1.2466, df = 380, p-value = 0.2133
    alternative hypothesis: true difference in means is not equal to 0
    95 percent confidence interval:
     -0.5614691  2.5067919
    sample estimates:
    mean in group F mean in group M 
           5.787879        4.815217 

    #We get a statistically insignificant result
    

Understanding the t-test’s output -

*   df, degrees of freedom = 380
*   p-value, indicates whether you have a statistically significant result or not = 0.213 (>0.05)
*   mean values = mean of Male and Female populatoions are almost similar

#### Effect - size

It is the magnitude of difference between the means of your groups.

*   It ranges from 0 to 1
*   t=t-statistics, N1=Number in group 1, N2 = number in group 2

    #Calculate the effect-size or eta-squared
    #t-statistics
    t = 1.247
    #no. of females
    N1 = 198
    #no. of males
    N2 = 184
    #eta square formula
    eta_squared = (t^2) /(t^2 + (N1 + N2 -2))
    eta_squared

    [1] 0.004075452

Understanding Eta squared test’s output -

*   Guidelines on effect size: 0.01 = small, 0.06 = moderate, 0.14 =large
*   0.004 is small effect-size

Reporting a t-test in words:

> An independent-samples t-test was conducted to compare absence records for male and female students. No significant difference in the absence records was found (M=5.79, SD= 9.16 for female stuudents, M= 4.82, SD= 5.5 for male students), (t(380)= 1.247, p = 0.213). The eta square statistic also indicated a very small effect size (0.004). A statistically non-significant p-value (>0.05) suggests that we don’t have enough evidence to reject the null hypothesis in favor of our alternative hypothesis. This suggest that the mean of two populations is almost same.

2.4 Hypothesis 4 - ANOVA
------------------------

> Hypothesis – It is always a statement about population parameter.

> *   Ho: means of first group is equal second, which is equal to third, fourth and fifth (all means are equal)
> *   Ha: Atleast one mean value is different from other groups

There are two main **assumptions** of anova test, and they are similar to t-test -

*   Assumption of normality
    *   Data should be interval or scale.
    *   It should be normally distributed. As per section 1.2 inspection of mG3 variable, the distribution is normmal, and hence can be treated as parametric.
*   Assumption of Homogeneity of variance. In other words, Variances in group populations are roughly equal.
    *   If the samples in each group are large and nearly equal, the t-test can still be conducted even though assumptions are not met. Mjob has five groups - at\_home, health, other, services, and teacher. Bartlett Test is showing that there is a homogeneity of variance (see below)

Conditions needed -

*   One independent variable with three or more levels (mother’s job, a categorical variable) (mjob)
*   One continuous variable (Final Maths Grades) (mG3)

> We will thus be conducting the **One-way Between-Groups ANOVA** test, as above assumptions as well as the conditions have been met. We undertake **ANOVA** when we have more than two levels of measurement on our independent variable. Also please note that, the observations are independent of each other as Grades of different students are measured in different or independent conditions.

* * *

**Please Note this**  
Why we don’t take individual t-tests (pair wise independent sample t-tests) to find the difference in these groups?  
Answer is, the probability of committing a type-1 error rises to significantly.

* * *

### Question: Is there a difference in final maths scores of students with different jobs of mother?

#### Inspecting mjob categorical variable -

    #Code chunk for hypothesis 4
    #Summary statistics by group (we know we can use mean and sd but you can adjust to calculate median and IQR)
    group_by(students, students$mjob) %>% 
    dplyr::summarise( 
    count = n(), 
    mean = mean(mg3, na.rm = TRUE), 
    sd = sd(mg3, na.rm = TRUE) )

![](/images/statpost1_2.jpg)

Here, we are getting count, mean and standard deviations of individual groups.

#### Homogeneity of Variance

    
    #Check for homogeneity of variance
    #We use Bartlett's test 
    
    stats::bartlett.test(students$mg3, students$mjob)

    
        Bartlett test of homogeneity of variances
    
    data:  students$mg3 and students$mjob
    Bartlett's K-squared = 1.1537, df = 4, p-value = 0.8857

    #Can be argued that the variances are homogeneous if the p-value > 0.05
    

Understanding Bartlett test’s output -

*   p-value = 0.886 (>0.05), hence non-significant
*   df, degree of freedom = 4

A non-significant test suggests that there is a **Homogeneity of variance** between the groups.

#### ANOVA test

ANOVA tests for one overall effect only (this makes it an _omnibus_ test), it can tell us if there is difference between groups but it doesn’t provide information about which specific groups were affected. Now, to identify which group is different – we follow this test with a _post hoc_ test, it finds out which pairing of the groups have contributed this particular significance.

    
    #run User friendly science one-way anova test using the correct post-hoc test Tukey in our case
    #Use Games-Howell for unequal variances
    one.way <- userfriendlyscience::oneway(students$mjob, y = students$mg3, posthoc = 'Tukey') 
     
    #printout a summary of the anova 
    one.way 

    ### Oneway Anova for y=mg3 and x=mjob (groups: at_home, health, other, services, teacher)
    
    Omega squared: 95% CI = [.01; .08], point estimate = .03
    Eta Squared: 95% CI = [.01; .07], point estimate = .04


![](/images/statpost1_1.jpg)
    
    ### Post hoc test: Tukey
    
                     diff  lwr   upr  p adj
    health-at_home   3.21  0.41  6.01 .015 
    other-at_home    0.91  -1.13 2.95 .737 
    services-at_home 2.47  0.31  4.64 .016 
    teacher-at_home  1.91  -0.45 4.27 .177 
    other-health     -2.3  -4.75 0.15 .077 
    services-health  -0.74 -3.29 1.81 .932 
    teacher-health   -1.3  -4.02 1.42 .684 
    services-other   1.56  -0.12 3.24 .082 
    teacher-other    1     -0.93 2.93 .618 
    teacher-services -0.56 -2.62 1.49 .944 

Understanding the **ANOVA** test output -

*   p-value is significant >0.005
*   There is a statistically significant difference, but between which groups? This can be answered by TukeyHSD test.
*   sum of squares between groups = 364.52
*   total sum of squares = 8006.14

Understanding the **Tukey** test output -

*   Final maths grade of students with their mother’s job as _health_ and _at\_home_ are _significantly_ different.
*   Only signifcant difference is between our at\_home mjob group and health mjob group and the magnitude is 3.21

#### Calculating the effect size

    #eta_squared = sum of squares between groups/total sum of squares (from our ANOVA output (rounded up))
    eta_squared=365/8006
    eta_squared

    [1] 0.04559081

Understanding the **eta\_squared** value -

*   Guidelines on effect size: 0.01 = small, 0.06 = moderate, 0.14 =large
*   Effect-size is 0.04 (very small)

**Reporting the ANOVA result**

> A one-way between-groups analysis of variance was conducted to explore the impact of mother’s job on final maths grades. Participants were divided into five groups according to mother’s job (Group 1: at\_home; Group 2: health; Group 3: services; Group 4: teacher; Group 5: other). There was a statistically significant difference at the p < .05 level in final math scores for the five mother’s job groups: F(4, 377)=4.3, p<0.05. Despite reaching statistical significance, the actual difference in mean final maths grades between most of the groups was quite small. The effect size, calculated using eta squared was .04. Post-hoc comparisons using the Tukey HSD test indicated that the mean score for at\_home mother’s job group (M=8.85, SD=4.88) was statistically different to health mother’s job group(M=12.06, SD=4.26). Rest of the mother’s job groups did not differ significantly from any other group.

2.5 Hypothesis 5 - Repeated Measures - Paired Sample t-test
-----------------------------------------------------------

Repeated Measures basically implies that, data has been collected from same group at two different conditions or occasions.

> Hypothesis – It is always a statement about population parameter.

> *   Ho: Population means are equal
> *   Ha: Population means are different

These are the **assumptions** of t-tests -

*   Assumption of normality (it is a parametric test)
    *   Data should be interval or scale.
    *   It should be normally distributed. As per section 1.2 inspection of mG1 variable an mG2 variable shows that they both are normally distributed, and hence are both parametric.
*   Assumption of Homogeneity of variance. In other words, Variances in two populations are roughly equal.
    *   If the samples in each group are large and nearly equal, the t-test can still be conducted even though assumptions are not met. Sex has two groups - male and female. Levene Test is showing that there is a homogeneity of variance.

Conditions needed for Paired sample t-test -

*   One categorical independent variable, which in this case is Time with two different levels (Period 1 and Period 2)
*   One continuous dependent variable (Maths Grades) measured on two different occasions or under different conditions (mG1 and mG2)

> We will be conducting the **paired sample t-test**, as these assumptions and conditions have been met. Paired sample t-test will tell us whether there is a statistically significant difference between the mean maths grades for Time 1 and Time 2.

#### Question: Is there a significant change in student’s Maths Grades from Period 1 tp Period 2?

    #Code chunk for hypothesis 5
    
    #Paired T-test
    #mG1 and mG2 should both be numeric
    t.test(students$mg1,students$mg2,paired = TRUE) 

    
        Paired t-test
    
    data:  students$mg1 and students$mg2
    t = 1.4926, df = 381, p-value = 0.1364
    alternative hypothesis: true difference in means is not equal to 0
    95 percent confidence interval:
     -0.04734382  0.34577314
    sample estimates:
    mean of the differences 
                  0.1492147 

    #This shows there is no significant difference in the means in the grades for mg1 and mg2 
    

understanding the output -

*   t = 1.49,
*   df =381,
*   p-value (>0.05)
*   sample estimates: mean of the differences 0.149
*   We have established a non-significant difference to the level of 0.15 (rounded)

#### Calculating an Effect Size

    #t-statastics
    t = 1.49
    #no of observations
    N = 382
    #eta squared = 𝑡2/(𝑡2+(𝑁−1))
    eta_squared = (t^2)/(t^2 +(N-1))
    eta_squared

    [1] 0.005793277

Understanding eta square output

*   eta squared value = 0.006 (rounded)
*   Cohen’s guidelines : .01 = small, .06 = moderate, .014=large
*   very small difference of 0.006

**Reporting the paired t-test**

> A paired-samples t-test was conducted to evaluate the difference in students’ maths grades in period 1 and period 2 (mg1 and mg2). There was no statistically significant change in maths grade scores from Time 1 (M=10.86, SD=3.35) to Time 2 (M=10.71, SD=3.83), t (381)=1.49, p<.05). The mean decrease in maths grades was 0.15 with a 95% confidence interval ranging from -0.04 to 0.35. The eta squared statistic (.006) indicated a very small effect size.

3\. Discussion
==============

Key findings in this report are :

*   There is a very strong correlation between Maths Grade at Period 1 and Final Maths Grade
    
*   There is no correlation between Number of School Absences and Final Maths Grade
    
*   Number of absences for both boys and girls are similar.
    
*   Students whose mothers work in health sector and students whose mother does not work and stays at home have significant difference between them in their final maths grades.
    
*   Students whose mothers work as a teacher, in services or in some other sectors have identical performances in their final math grades.
    
*   Maths grades in Period 1 an Period 2 are very much similar.
    

* * *

While building a Predictive model to predict Final Maths Grades (mG3) there are a few things which can be kept in mind, based on the analysis explained in this report -

    * Maths grade in Period 1 (mG1) can be used as a preditor (or inependent variable) as it shows a strong correlation with Final grades (mG3).  
    
    * On similar lines, absences should not be used in predicting final grades.  
    
    * Maths grades in period 1 and period 2 are similar variables as have come out in paired sample t-test. So either one can be used, however, it will thus be futile to use both of them together.

References
==========

P. Cortez and A. Silva (2008). Using Data Mining to Predict Secondary School Student Performance. In A. Brito and J.Teixeira Eds., _Proceedings of 5th FUture BUsiness TEChnology Conference_ (FUBUTEC 2008) pp. 5-12, Porto, Portugal, April, 2008, EUROSIS, ISBN 978-9077381-39-7.
