---
layout: post
title: "Hand-Rolling OLS Regression using R"
categories: misc
---

To illustrate how to calculate ordinary least squares (OLS) by hand, I am going to use the dataset provided by Nerlove (1963) "Returns to Scale in Electricity Supply" which is publically available at [EconPapers](https://econpapers.repec.org/paper/bocbocins/nerlove63.htm).

Let's first import the data into R and take a glance.


```r
nerlove63 <- foreign::read.dta("http://fmwww.bc.edu/ec-p/data/hayashi/nerlove63.dta")
tail(nerlove63, 5) # print the last five observations 
```

```
##     totcost output plabor pfuel pkap
## 141  44.894   9956   1.68  28.8  203
## 142  67.120  11477   2.24  26.5  151
## 143  73.050  11796   2.12  28.6  148
## 144 139.422  14359   2.31  33.5  212
## 145 119.939  16719   2.30  23.6  162
```

The dataset contains five variables: cost (i.e., total cost in million \$), output (i.e., quantity (Q) in billion kilowatt hours), pLabor (i.e., unit price of labor or wage rate in \$ per hour), pCapital (i.e., unit price of capital), and pFuel (i.e., unit price of fuels in cent per million British thermal unit). Note that it is a firm-level cross-sectional data that comprises of observations from 145 American electric utility companies in 1955.

__Nerlove (1963) posits the following production function (this follows [the Cobb-Douglas](https://en.wikipedia.org/wiki/Cobb%E2%80%93Douglas_production_function) specification):__

$$\begin{align}
output_{i} = A_{i}(pLabor_{i})^{\alpha_{1}}(pCapital_{i})^{\alpha_{2}}(pFuel_{i})^{\alpha_{3}}, \tag{1}
\end{align}$$

which implies the following equation on the total cost:

$$\begin{align}
log(cost_{i}) = \frac{1}{r}log(output_{i})+\frac{\alpha_{1}}{r}log(pLabor_{i})+\frac{\alpha_{2}}{r}log(pCapital_{i})+\frac{\alpha_{3}}{r}log(pFuel_{i})+log\biggl[r(A_{i}\alpha_{1}^{\alpha_{1}}\alpha_{2}^{\alpha_{2}}\alpha_{3}^{\alpha_{3}})^{-\frac{1}{r}}\biggl], \tag{2}
\end{align}$$

where $$r \equiv \alpha_{1} + \alpha_{2} + \alpha_{3}$$ (i.e., the degree of returns to scale).

Equation (2) can be estimated by OLS using the following unrestricted model:

$$\begin{align}
log(cost) = \beta_{1} + \beta_{2} \times log(output) + \beta_{3} \times log(pLabor) \\
+ \beta_{4} \times log(pCapital) + \beta_{5} \times log(pFuel) + \epsilon. \tag{3}
\end{align}$$

The linear regression model can be written as $$y_{i} = X\beta+\epsilon$$, and the $$\hat\beta$$ can be calculated as $$(X^{T}X)^{-1}X^{T}y$$.

Let's take it step by step! 


__1. Data Construction__

First, we will create the $$X$$ and $$Y$$ matrices and see what it looks like.

```r
X <- as.matrix(cbind(int = 1, log(nerlove63$output), log(nerlove63$plabor), log(nerlove63$pkap), log(nerlove63$pfuel)))
Y <- as.vector(cbind(log(nerlove63$totcost)))
print(data.table::data.table(cbind(Y,X))) # V3 ~ V6 correspond to X1 ~ X4, respectively
```

```
##                Y int        V3        V4       V5       V6
##   1: -2.50103600   1 0.6931472 0.7371640 5.209486 2.884801
##   2: -0.41400142   1 1.0986123 0.7178398 5.159055 3.558201
##   3: -0.01005033   1 1.3862944 0.7178398 5.141664 3.558201
##   4: -1.15518265   1 1.3862944 0.6043160 5.111988 3.471966
##   5: -1.62455157   1 1.6094379 0.7514160 5.451038 3.353407
##  ---                                                      
## 141:  3.80430418   1 9.2059307 0.5187938 5.313206 3.360375
## 142:  4.20648210   1 9.3481003 0.8064759 5.017280 3.277145
## 143:  4.29114418   1 9.3755158 0.7514160 4.997212 3.353407
## 144:  4.93750528   1 9.5721322 0.8372475 5.356586 3.511545
## 145:  4.78698331   1 9.7243011 0.8329091 5.087596 3.161247
```


__2. The Estimates for the Coefficients, $$\hat\beta$$__

Next, we will calculate $$(X^{T}X)^{-1}$$

```r
XXi <- solve(t(X) %*% X)
```

and $$X^{T}y$$.

```r
XY <- t(X) %*% Y
```

Putting them together, we get the estimates for the coefficients.

```r
b <- as.vector(XXi %*% XY)
b <- as.data.frame(cbind(c("Intercept", "log(output)", "log(pLabor)", "log(pCapital)", "log(pFuel)"), format(b, digits = 3)))
names(b) = c("", "Coefficients")
print(b)
```

```
##                 Coefficients
## 1     Intercept       -3.527
## 2   log(output)        0.720
## 3   log(pLabor)        0.436
## 4 log(pCapital)       -0.220
## 5    log(pFuel)        0.427
```


__3. The Standard Errors for the Coefficients__

First, we calculate the residuals of the model $$\epsilon$$ can be calculated as follows:

```r
n <- length(Y) # number of observations
p <- ncol(X) - 1 # number of covariates

i <- diag(1, nrow = n, ncol = n) # identity matrix
h <- X %*% XXi %*% t(X) # hat matrix of X

res <- (i - h) %*% Y # Model residuals
print(data.table::data.table(res)[, .(Residuals = V1)])
```

```
##      Residuals
##   1: 0.1195616
##   2: 1.6246277
##   3: 1.8175100
##   4: 0.7521680
##   5: 0.1829830
##  ---          
## 141: 0.2075931
## 142: 0.3522538
## 143: 0.4042512
## 144: 0.8830925
## 145: 0.7151026
```

Next, we will calculate the standard errors of the coefficients which typically are displayed in parenthesis underneath the coefficients in the regression output tables.

```r
SST <- sum((Y - mean(Y))^2) # Sum of Squares Total
SSE <- t(res) %*% res # Sum of Squares Error
SSM <- SST - SSE # Sum of Squares for the regression model

df.e <- (n - p - 1) # Degrees of Freedom for Error
df.t <- (n - 1) # Total Degrees of Freedom
df.m <- df.t - df.e # Degrees of Freedom for Model

s2 <- as.vector(SSE / df.e)
b.standard.errors <- sqrt(diag(XXi)) * sqrt(s2) # Standard Errors of the Coefficients

names(b.standard.errors) = c("Intercept", "log(output)", "log(pLabor)", "log(pCapital)", "log(pFuel)")
print(round(b.standard.errors, digit = 3))
```

```
##     Intercept   log(output)   log(pLabor) log(pCapital)    log(pFuel) 
##         1.774         0.017         0.291         0.339         0.100
```


__4. The Coefficient of Determination__

Lastly, we will calculate the coefficient of determination for the model commonly denoted as $$R^{2}$$.

```r
Rsquared <- 1 - (SSE / SST)
print(round(Rsquared, digit = 3))
```

```
##       [,1]
## [1,] 0.926
```

__Let's check if we got our hand-rolled regression results correctly using the lm() function in R.__

```r
regOut <- lm(log(totcost) ~ log(output) + log(plabor) + log(pkap) + log(pfuel), data = nerlove63)
stargazer::stargazer(regOut, type = 'text')
```

```
## 
## ===============================================
##                         Dependent variable:    
##                     ---------------------------
##                            log(totcost)        
## -----------------------------------------------
## log(output)                  0.720***          
##                               (0.017)          
##                                                
## log(plabor)                    0.436           
##                               (0.291)          
##                                                
## log(pkap)                     -0.220           
##                               (0.339)          
##                                                
## log(pfuel)                   0.427***          
##                               (0.100)          
##                                                
## Constant                     -3.527**          
##                               (1.774)          
##                                                
## -----------------------------------------------
## Observations                    145            
## R2                             0.926           
## Adjusted R2                    0.924           
## Residual Std. Error      0.392 (df = 140)      
## F Statistic          437.686*** (df = 4; 140)  
## ===============================================
## Note:               *p<0.1; **p<0.05; ***p<0.01
```

The results obtained using the built-in function are identical to ours. Check! :)

###### Created on Feb. 13, 2019
